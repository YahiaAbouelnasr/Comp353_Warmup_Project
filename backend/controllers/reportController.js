// Items 8-19: the analytical reports. Each function is a direct,
// parameterized port of the matching query in sql/7_queries.sql --
// same conventions documented there:
//   - major/minor computed from age (dob vs today), not Minors/Majors
//   - active = previous year's payments cover the fee for their age bracket
//   - FIFA game = ParticipatesIn/PlaysIn/FIFA_Games (separate from club Sessions)
//   - current location = MemberAt row with endDate IS NULL
const pool = require('../db');

// Item 8: locations with >= 2 members who played a FIFA game
async function locationsWithFifaPlayers(req, res) {
  const [rows] = await pool.query(`
    WITH LocationFifaPlayers AS (
        SELECT ma.locationID, COUNT(DISTINCT pi.memberNo) AS numFifaPlayers
        FROM MemberAt ma
        JOIN ParticipatesIn pi ON pi.memberNo = ma.memberNo
        WHERE ma.endDate IS NULL
        GROUP BY ma.locationID
        HAVING COUNT(DISTINCT pi.memberNo) >= 2
    )
    SELECT
        l.locationID,
        l.address, l.city, l.province, l.postalCode,
        GROUP_CONCAT(DISTINCT lp.phone SEPARATOR ', ') AS phoneNumbers,
        l.webAddress, l.type, l.capacity,
        CONCAT(gm.firstName, ' ', gm.lastName) AS generalManagerName,
        (SELECT COUNT(*) FROM MemberAt ma2 JOIN ClubMembers cm2 ON cm2.memberNo = ma2.memberNo
         WHERE ma2.locationID = l.locationID AND ma2.endDate IS NULL
           AND TIMESTAMPDIFF(YEAR, cm2.dob, CURDATE()) < 18) AS numMinorMembers,
        (SELECT COUNT(*) FROM MemberAt ma3 JOIN ClubMembers cm3 ON cm3.memberNo = ma3.memberNo
         WHERE ma3.locationID = l.locationID AND ma3.endDate IS NULL
           AND TIMESTAMPDIFF(YEAR, cm3.dob, CURDATE()) >= 18) AS numMajorMembers,
        lfp.numFifaPlayers
    FROM Locations l
    JOIN LocationFifaPlayers lfp ON lfp.locationID = l.locationID
    LEFT JOIN LocationPhones lp ON lp.locationID = l.locationID
    LEFT JOIN Manages mgr ON mgr.locationID = l.locationID
    LEFT JOIN Personnel gm ON gm.personnelID = mgr.personnelID
    GROUP BY l.locationID, l.address, l.city, l.province, l.postalCode,
             l.webAddress, l.type, l.capacity, gm.firstName, gm.lastName, lfp.numFifaPlayers
    ORDER BY lfp.numFifaPlayers DESC
  `);
  res.json(rows);
}

// Item 9: primary family members with >= 2 FIFA-playing club members
async function primaryFamilyWithFifaKids(req, res) {
  const [rows] = await pool.query(`
    WITH PrimaryFifaKids AS (
        SELECT fo.familyID, fo.memberNo, fo.relationship
        FROM FamilyOf fo
        WHERE fo.familyType = 'Primary' AND fo.endDate IS NULL
          AND EXISTS (SELECT 1 FROM ParticipatesIn pi WHERE pi.memberNo = fo.memberNo)
    ),
    Qualified AS (
        SELECT familyID FROM PrimaryFifaKids GROUP BY familyID HAVING COUNT(DISTINCT memberNo) >= 2
    )
    SELECT
        fm.firstName, fm.lastName,
        cm.memberNo, cm.firstName AS childFirstName, cm.lastName AS childLastName,
        cm.dob, pfk.relationship
    FROM Qualified q
    JOIN FamilyMembers fm ON fm.familyID = q.familyID
    JOIN PrimaryFifaKids pfk ON pfk.familyID = q.familyID
    JOIN ClubMembers cm ON cm.memberNo = pfk.memberNo
    ORDER BY fm.firstName ASC, fm.lastName ASC, cm.memberNo ASC
  `);
  res.json(rows);
}

// Item 10: team formations for a given location + period
async function teamFormationsForLocation(req, res) {
  const { locationID, start, end } = req.query;
  if (!locationID || !start || !end) {
    return res.status(400).json({ error: 'locationID, start, end query params are required' });
  }
  const [rows] = await pool.query(
    `
    SELECT
        p.firstName AS headCoachFirstName, p.lastName AS headCoachLastName,
        s.sessionDateTime AS startTime, s.address, s.nature,
        t.teamName, tf.score,
        (SELECT COUNT(*) FROM AssignedTo at2 WHERE at2.teamID = tf.teamID AND at2.sessionID = tf.sessionID) AS totalPlayers,
        cm.firstName AS playerFirstName, cm.lastName AS playerLastName, at.\`role\`
    FROM TeamFormations tf
    JOIN Teams t ON t.teamID = tf.teamID
    JOIN BelongsTo bt ON bt.teamID = tf.teamID
    JOIN Sessions s ON s.sessionID = tf.sessionID
    JOIN Personnel p ON p.personnelID = tf.personnelID
    LEFT JOIN AssignedTo at ON at.teamID = tf.teamID AND at.sessionID = tf.sessionID
    LEFT JOIN ClubMembers cm ON cm.memberNo = at.memberNo
    WHERE bt.locationID = ?
      AND DATE(s.sessionDateTime) BETWEEN ? AND ?
    ORDER BY s.sessionDateTime ASC, t.teamName, cm.lastName
    `,
    [locationID, start, end]
  );
  res.json(rows);
}

// Item 11: club members who played >= 5 FIFA games
async function frequentFifaPlayers(req, res) {
  const [rows] = await pool.query(`
    WITH FifaCounts AS (
        SELECT pi.memberNo, COUNT(DISTINCT pi.gameID) AS numGames,
               MIN(YEAR(g.gameDate)) AS minYear, MAX(YEAR(g.gameDate)) AS maxYear
        FROM ParticipatesIn pi
        JOIN FIFA_Games g ON g.gameID = pi.gameID
        GROUP BY pi.memberNo
        HAVING COUNT(DISTINCT pi.gameID) >= 5
    )
    SELECT cm.memberNo, cm.firstName, cm.lastName, fc.numGames, fc.minYear, fc.maxYear
    FROM FifaCounts fc
    JOIN ClubMembers cm ON cm.memberNo = fc.memberNo
    ORDER BY fc.numGames DESC
  `);
  res.json(rows);
}

// Item 12: formation report per location for a period, >= 4 game sessions only
async function formationsSummaryByLocation(req, res) {
  const { start, end } = req.query;
  if (!start || !end) return res.status(400).json({ error: 'start, end query params are required' });

  const [rows] = await pool.query(
    `
    WITH LocationTeamFormations AS (
        SELECT bt.locationID, tf.teamID, tf.sessionID, s.nature
        FROM TeamFormations tf
        JOIN BelongsTo bt ON bt.teamID = tf.teamID
        JOIN Sessions s ON s.sessionID = tf.sessionID
        WHERE DATE(s.sessionDateTime) BETWEEN ? AND ?
    )
    SELECT
        l.name AS locationName,
        COUNT(DISTINCT CASE WHEN ltf.nature = 'Training' THEN ltf.sessionID END) AS numTrainingSessions,
        COUNT(CASE WHEN ltf.nature = 'Training' THEN at.memberNo END) AS numTrainingPlayers,
        COUNT(DISTINCT CASE WHEN ltf.nature = 'Game' THEN ltf.sessionID END) AS numGameSessions,
        COUNT(CASE WHEN ltf.nature = 'Game' THEN at.memberNo END) AS numGamePlayers
    FROM LocationTeamFormations ltf
    JOIN Locations l ON l.locationID = ltf.locationID
    LEFT JOIN AssignedTo at ON at.teamID = ltf.teamID AND at.sessionID = ltf.sessionID
    GROUP BY l.locationID, l.name
    HAVING COUNT(DISTINCT CASE WHEN ltf.nature = 'Game' THEN ltf.sessionID END) >= 4
    ORDER BY numGameSessions DESC
    `,
    [start, end]
  );
  res.json(rows);
}

// Item 13: active members never assigned to a formation, but played a FIFA game
async function activeNeverAssignedButFifa(req, res) {
  const [rows] = await pool.query(`
    WITH MemberStatus AS (
        SELECT cm.memberNo,
               CASE WHEN COALESCE(prev.totalPaid, 0) >= IF(TIMESTAMPDIFF(YEAR, cm.dob, CURDATE()) >= 18, 200, 100)
                    THEN 'Active' ELSE 'Inactive' END AS status
        FROM ClubMembers cm
        LEFT JOIN (
            SELECT memberNo, SUM(amount) AS totalPaid
            FROM Payments WHERE memYear = YEAR(CURDATE()) - 1
            GROUP BY memberNo
        ) prev ON prev.memberNo = cm.memberNo
    )
    SELECT
        cm.memberNo, cm.firstName, cm.lastName,
        TIMESTAMPDIFF(YEAR, cm.dob, CURDATE()) AS age,
        cm.phone, cm.email,
        COUNT(DISTINCT pi.gameID) AS numFifaGames,
        l.name AS currentLocation
    FROM ClubMembers cm
    JOIN MemberStatus ms ON ms.memberNo = cm.memberNo AND ms.status = 'Active'
    JOIN ParticipatesIn pi ON pi.memberNo = cm.memberNo
    JOIN MemberAt ma ON ma.memberNo = cm.memberNo AND ma.endDate IS NULL
    JOIN Locations l ON l.locationID = ma.locationID
    WHERE NOT EXISTS (SELECT 1 FROM AssignedTo at WHERE at.memberNo = cm.memberNo)
    GROUP BY cm.memberNo, cm.firstName, cm.lastName, cm.dob, cm.phone, cm.email, l.name
    ORDER BY l.name ASC, numFifaGames ASC
  `);
  res.json(rows);
}

// Item 14: major members who've been members since they were minors
async function majorsSinceMinors(req, res) {
  const [rows] = await pool.query(`
    SELECT
        cm.memberNo, cm.firstName, cm.lastName,
        CASE WHEN COALESCE(prev.totalPaid, 0) >= 200 THEN 'Active' ELSE 'Inactive' END AS status,
        joinInfo.dateJoined,
        TIMESTAMPDIFF(YEAR, cm.dob, CURDATE()) AS age,
        cm.phone, cm.email,
        l.name AS currentLocation
    FROM ClubMembers cm
    JOIN Minors mi ON mi.memberNo = cm.memberNo
    JOIN MemberAt ma ON ma.memberNo = cm.memberNo AND ma.endDate IS NULL
    JOIN Locations l ON l.locationID = ma.locationID
    JOIN (SELECT memberNo, MIN(startDate) AS dateJoined FROM MemberAt GROUP BY memberNo) joinInfo
        ON joinInfo.memberNo = cm.memberNo
    LEFT JOIN (
        SELECT memberNo, SUM(amount) AS totalPaid
        FROM Payments WHERE memYear = YEAR(CURDATE()) - 1
        GROUP BY memberNo
    ) prev ON prev.memberNo = cm.memberNo
    WHERE TIMESTAMPDIFF(YEAR, cm.dob, CURDATE()) >= 18
    ORDER BY l.name ASC, age ASC
  `);
  res.json(rows);
}

// Item 15: active members only ever assigned as Goalkeeper
async function goalkeeperOnlyMembers(req, res) {
  const [rows] = await pool.query(`
    WITH MemberStatus AS (
        SELECT cm.memberNo,
               CASE WHEN COALESCE(prev.totalPaid, 0) >= IF(TIMESTAMPDIFF(YEAR, cm.dob, CURDATE()) >= 18, 200, 100)
                    THEN 'Active' ELSE 'Inactive' END AS status
        FROM ClubMembers cm
        LEFT JOIN (
            SELECT memberNo, SUM(amount) AS totalPaid
            FROM Payments WHERE memYear = YEAR(CURDATE()) - 1
            GROUP BY memberNo
        ) prev ON prev.memberNo = cm.memberNo
    ),
    GoalkeeperOnly AS (
        SELECT memberNo
        FROM AssignedTo
        GROUP BY memberNo
        HAVING SUM(CASE WHEN \`role\` = 'Goalkeeper' THEN 1 ELSE 0 END) = COUNT(*)
           AND SUM(CASE WHEN \`role\` = 'Goalkeeper' THEN 1 ELSE 0 END) >= 1
    )
    SELECT
        cm.memberNo, cm.firstName, cm.lastName,
        TIMESTAMPDIFF(YEAR, cm.dob, CURDATE()) AS age,
        cm.phone, cm.email,
        l.name AS currentLocation,
        COUNT(DISTINCT pi.gameID) AS numFifaGames
    FROM ClubMembers cm
    JOIN GoalkeeperOnly go ON go.memberNo = cm.memberNo
    JOIN MemberStatus ms ON ms.memberNo = cm.memberNo AND ms.status = 'Active'
    JOIN MemberAt ma ON ma.memberNo = cm.memberNo AND ma.endDate IS NULL
    JOIN Locations l ON l.locationID = ma.locationID
    LEFT JOIN ParticipatesIn pi ON pi.memberNo = cm.memberNo
    GROUP BY cm.memberNo, cm.firstName, cm.lastName, cm.dob, cm.phone, cm.email, l.name
    ORDER BY l.name ASC, cm.memberNo ASC
  `);
  res.json(rows);
}

// Item 16: active members with all 5 roles (Goalkeeper/Right Fullback/Sweeper/Defending/Striker) in game sessions
async function allFiveRolesMembers(req, res) {
  const [rows] = await pool.query(`
    WITH MemberStatus AS (
        SELECT cm.memberNo,
               CASE WHEN COALESCE(prev.totalPaid, 0) >= IF(TIMESTAMPDIFF(YEAR, cm.dob, CURDATE()) >= 18, 200, 100)
                    THEN 'Active' ELSE 'Inactive' END AS status
        FROM ClubMembers cm
        LEFT JOIN (
            SELECT memberNo, SUM(amount) AS totalPaid
            FROM Payments WHERE memYear = YEAR(CURDATE()) - 1
            GROUP BY memberNo
        ) prev ON prev.memberNo = cm.memberNo
    ),
    AllFiveRoles AS (
        SELECT at.memberNo
        FROM AssignedTo at
        JOIN Sessions s ON s.sessionID = at.sessionID AND s.nature = 'Game'
        WHERE at.\`role\` IN ('Goalkeeper', 'Right Fullback', 'Sweeper', 'Defending', 'Striker')
        GROUP BY at.memberNo
        HAVING COUNT(DISTINCT at.\`role\`) = 5
    )
    SELECT
        cm.memberNo, cm.firstName, cm.lastName,
        TIMESTAMPDIFF(YEAR, cm.dob, CURDATE()) AS age,
        cm.phone, cm.email,
        l.name AS currentLocation
    FROM ClubMembers cm
    JOIN AllFiveRoles afr ON afr.memberNo = cm.memberNo
    JOIN MemberStatus ms ON ms.memberNo = cm.memberNo AND ms.status = 'Active'
    JOIN MemberAt ma ON ma.memberNo = cm.memberNo AND ma.endDate IS NULL
    JOIN Locations l ON l.locationID = ma.locationID
    ORDER BY l.name ASC, cm.memberNo ASC
  `);
  res.json(rows);
}

// Item 17: family members (active associated member) who are also head coaches at the given location
async function familyMembersWhoAreHeadCoaches(req, res) {
  const { locationID } = req.query;
  if (!locationID) return res.status(400).json({ error: 'locationID query param is required' });

  const [rows] = await pool.query(
    `
    WITH MemberStatus AS (
        SELECT cm.memberNo,
               CASE WHEN COALESCE(prev.totalPaid, 0) >= IF(TIMESTAMPDIFF(YEAR, cm.dob, CURDATE()) >= 18, 200, 100)
                    THEN 'Active' ELSE 'Inactive' END AS status
        FROM ClubMembers cm
        LEFT JOIN (
            SELECT memberNo, SUM(amount) AS totalPaid
            FROM Payments WHERE memYear = YEAR(CURDATE()) - 1
            GROUP BY memberNo
        ) prev ON prev.memberNo = cm.memberNo
    ),
    HeadCoachesAtLocation AS (
        SELECT DISTINCT tf.personnelID
        FROM TeamFormations tf
        JOIN BelongsTo bt ON bt.teamID = tf.teamID
        WHERE bt.locationID = ?
    )
    SELECT DISTINCT fm.firstName, fm.lastName, fm.phone
    FROM FamilyMembers fm
    JOIN Personnel p ON p.ssn = fm.ssn
    JOIN HeadCoachesAtLocation hca ON hca.personnelID = p.personnelID
    JOIN FamilyOf fo ON fo.familyID = fm.familyID AND fo.endDate IS NULL
    JOIN MemberStatus ms ON ms.memberNo = fo.memberNo AND ms.status = 'Active'
    `,
    [locationID]
  );
  res.json(rows);
}

// Item 18: active members who never won a game they played
async function neverWonMembers(req, res) {
  const [rows] = await pool.query(`
    WITH MemberStatus AS (
        SELECT cm.memberNo,
               CASE WHEN COALESCE(prev.totalPaid, 0) >= IF(TIMESTAMPDIFF(YEAR, cm.dob, CURDATE()) >= 18, 200, 100)
                    THEN 'Active' ELSE 'Inactive' END AS status
        FROM ClubMembers cm
        LEFT JOIN (
            SELECT memberNo, SUM(amount) AS totalPaid
            FROM Payments WHERE memYear = YEAR(CURDATE()) - 1
            GROUP BY memberNo
        ) prev ON prev.memberNo = cm.memberNo
    ),
    GameAssignments AS (
        SELECT at.memberNo, at.teamID, at.sessionID, tf.score AS ownScore,
               opp.score AS oppScore
        FROM AssignedTo at
        JOIN Sessions s ON s.sessionID = at.sessionID AND s.nature = 'Game'
        JOIN TeamFormations tf ON tf.teamID = at.teamID AND tf.sessionID = at.sessionID
        JOIN TeamFormations opp ON opp.sessionID = at.sessionID AND opp.teamID <> at.teamID
    ),
    NeverWon AS (
        SELECT memberNo
        FROM GameAssignments
        GROUP BY memberNo
        HAVING SUM(CASE WHEN ownScore > oppScore THEN 1 ELSE 0 END) = 0
    )
    SELECT
        cm.memberNo, cm.firstName, cm.lastName,
        TIMESTAMPDIFF(YEAR, cm.dob, CURDATE()) AS age,
        cm.phone, cm.email,
        l.name AS currentLocation
    FROM ClubMembers cm
    JOIN NeverWon nw ON nw.memberNo = cm.memberNo
    JOIN MemberStatus ms ON ms.memberNo = cm.memberNo AND ms.status = 'Active'
    JOIN MemberAt ma ON ma.memberNo = cm.memberNo AND ma.endDate IS NULL
    JOIN Locations l ON l.locationID = ma.locationID
    ORDER BY l.name ASC, cm.memberNo ASC
  `);
  res.json(rows);
}

// Item 19: volunteer personnel who are family members of a minor with FIFA participation
async function volunteerFamilyWithFifaKids(req, res) {
  const [rows] = await pool.query(`
    SELECT
        p.firstName, p.lastName,
        COUNT(DISTINCT fo.memberNo) AS numAssociatedMinors,
        COUNT(DISTINCT pi.memberNo) AS numFifaPlayers,
        p.phone, p.email,
        l.name AS currentLocation,
        p.\`role\`
    FROM Personnel p
    JOIN FamilyMembers fm ON fm.ssn = p.ssn
    JOIN FamilyOf fo ON fo.familyID = fm.familyID AND fo.endDate IS NULL
    LEFT JOIN ParticipatesIn pi ON pi.memberNo = fo.memberNo
    JOIN WorksAt w ON w.personnelID = p.personnelID AND w.endDate IS NULL
    JOIN Locations l ON l.locationID = w.locationID
    WHERE p.mandate = 'Volunteer'
    GROUP BY p.personnelID, p.firstName, p.lastName, p.phone, p.email, l.name, p.\`role\`
    HAVING COUNT(DISTINCT fo.memberNo) >= 1 AND COUNT(DISTINCT pi.memberNo) >= 1
    ORDER BY l.name ASC, p.\`role\` ASC, p.firstName ASC, p.lastName ASC
  `);
  res.json(rows);
}

module.exports = {
  locationsWithFifaPlayers,
  primaryFamilyWithFifaKids,
  teamFormationsForLocation,
  frequentFifaPlayers,
  formationsSummaryByLocation,
  activeNeverAssignedButFifa,
  majorsSinceMinors,
  goalkeeperOnlyMembers,
  allFiveRolesMembers,
  familyMembersWhoAreHeadCoaches,
  neverWonMembers,
  volunteerFamilyWithFifaKids,
};
