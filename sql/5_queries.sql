USE wfc353_1;

-- status (active/inactive) is based on whether payments for the previous
-- calendar year (YEAR(CURDATE()) - 1) cover the required annual fee
-- (100$ minor / 200$ major). Requires MySQL 8+ for CTEs.

-- Query i: complete details for every location, sorted ascending by number of club members
SELECT
    l.locationID,
    l.name,
    l.address,
    l.city,
    l.province,
    l.postalCode,
    GROUP_CONCAT(DISTINCT lp.phone SEPARATOR ', ') AS phoneNumbers,
    l.webAddress,
    l.type,
    l.capacity,
    CONCAT(gm.firstName, ' ', gm.lastName) AS generalManagerName,
    (SELECT COUNT(*)
     FROM WorksAt w
     WHERE w.locationID = l.locationID AND w.endDate IS NULL) AS numPersonnel,
    (SELECT COUNT(*)
     FROM MemberAt ma
     WHERE ma.locationID = l.locationID AND ma.endDate IS NULL) AS numClubMembers,
    (SELECT COUNT(DISTINCT ma.memberNo)
     FROM MemberAt ma
     JOIN ParticipatesIn pi ON pi.memberNo = ma.memberNo
     WHERE ma.locationID = l.locationID AND ma.endDate IS NULL) AS numMembersPlayedFIFA
FROM Locations l
LEFT JOIN LocationPhones lp ON lp.locationID = l.locationID
LEFT JOIN Manages mgr ON mgr.locationID = l.locationID
LEFT JOIN Personnel gm ON gm.personnelID = mgr.personnelID
GROUP BY l.locationID, l.name, l.address, l.city, l.province, l.postalCode,
         l.webAddress, l.type, l.capacity, gm.firstName, gm.lastName
ORDER BY numClubMembers ASC;

-- Query ii: major club members who played in at least one FIFA game, sorted ascending by number of games played
WITH GameCounts AS (
    SELECT memberNo, COUNT(DISTINCT gameID) AS numGames
    FROM ParticipatesIn
    GROUP BY memberNo
),
MemberStatus AS (
    SELECT cm.memberNo,
           CASE
               WHEN COALESCE(prev.totalPaid, 0) >= IF(mi.memberNo IS NOT NULL, 100, 200)
               THEN 'Active' ELSE 'Inactive'
           END AS status
    FROM ClubMembers cm
    LEFT JOIN Minors mi ON mi.memberNo = cm.memberNo
    LEFT JOIN (
        SELECT memberNo, SUM(amount) AS totalPaid
        FROM Payments
        WHERE memYear = YEAR(CURDATE()) - 1
        GROUP BY memberNo
    ) prev ON prev.memberNo = cm.memberNo
)
SELECT
    l.name AS locationName,
    cm.memberNo,
    cm.firstName,
    cm.lastName,
    TIMESTAMPDIFF(YEAR, cm.dob, CURDATE()) AS age,
    cm.city,
    cm.province,
    ms.status,
    gc.numGames
FROM ClubMembers cm
JOIN Majors mj ON mj.memberNo = cm.memberNo
JOIN GameCounts gc ON gc.memberNo = cm.memberNo
JOIN MemberAt ma ON ma.memberNo = cm.memberNo AND ma.endDate IS NULL
JOIN Locations l ON l.locationID = ma.locationID
JOIN MemberStatus ms ON ms.memberNo = cm.memberNo
ORDER BY gc.numGames ASC;

-- Query iii: club members with at least four different hobbies, sorted descending by age, then ascending by location name
WITH HobbyCounts AS (
    SELECT memberNo, COUNT(DISTINCT hobbyName) AS numHobbies
    FROM HasHobby
    GROUP BY memberNo
    HAVING COUNT(DISTINCT hobbyName) >= 4
),
MemberStatus AS (
    SELECT cm.memberNo,
           CASE
               WHEN COALESCE(prev.totalPaid, 0) >= IF(mi.memberNo IS NOT NULL, 100, 200)
               THEN 'Active' ELSE 'Inactive'
           END AS status
    FROM ClubMembers cm
    LEFT JOIN Minors mi ON mi.memberNo = cm.memberNo
    LEFT JOIN (
        SELECT memberNo, SUM(amount) AS totalPaid
        FROM Payments
        WHERE memYear = YEAR(CURDATE()) - 1
        GROUP BY memberNo
    ) prev ON prev.memberNo = cm.memberNo
)
SELECT
    l.name AS locationName,
    cm.memberNo,
    cm.firstName,
    cm.lastName,
    TIMESTAMPDIFF(YEAR, cm.dob, CURDATE()) AS age,
    cm.city,
    cm.province,
    ms.status,
    hc.numHobbies
FROM ClubMembers cm
JOIN HobbyCounts hc ON hc.memberNo = cm.memberNo
JOIN MemberAt ma ON ma.memberNo = cm.memberNo AND ma.endDate IS NULL
JOIN Locations l ON l.locationID = ma.locationID
JOIN MemberStatus ms ON ms.memberNo = cm.memberNo
ORDER BY age DESC, locationName ASC;

-- Query iv: major club members who have never played in any FIFA game, sorted ascending by location name, then by age
WITH MemberStatus AS (
    SELECT cm.memberNo,
           CASE
               WHEN COALESCE(prev.totalPaid, 0) >= IF(mi.memberNo IS NOT NULL, 100, 200)
               THEN 'Active' ELSE 'Inactive'
           END AS status
    FROM ClubMembers cm
    LEFT JOIN Minors mi ON mi.memberNo = cm.memberNo
    LEFT JOIN (
        SELECT memberNo, SUM(amount) AS totalPaid
        FROM Payments
        WHERE memYear = YEAR(CURDATE()) - 1
        GROUP BY memberNo
    ) prev ON prev.memberNo = cm.memberNo
)
SELECT
    l.name AS locationName,
    cm.memberNo,
    cm.firstName,
    cm.lastName,
    TIMESTAMPDIFF(YEAR, cm.dob, CURDATE()) AS age,
    cm.city,
    cm.province,
    ms.status
FROM ClubMembers cm
JOIN Majors mj ON mj.memberNo = cm.memberNo
JOIN MemberAt ma ON ma.memberNo = cm.memberNo AND ma.endDate IS NULL
JOIN Locations l ON l.locationID = ma.locationID
JOIN MemberStatus ms ON ms.memberNo = cm.memberNo
WHERE NOT EXISTS (
    SELECT 1 FROM ParticipatesIn pi WHERE pi.memberNo = cm.memberNo
)
ORDER BY locationName ASC, age ASC;

-- Query v: total number of club members for every age across all locations, sorted descending by age
SELECT
    TIMESTAMPDIFF(YEAR, dob, CURDATE()) AS age,
    COUNT(*) AS numMembers
FROM ClubMembers
GROUP BY age
ORDER BY age DESC;

-- Query vi: for every major club member who is also a family member (matched by SSN), details of all club members associated with them
WITH MemberStatus AS (
    SELECT cm.memberNo,
           CASE
               WHEN COALESCE(prev.totalPaid, 0) >= IF(mi.memberNo IS NOT NULL, 100, 200)
               THEN 'Active' ELSE 'Inactive'
           END AS status
    FROM ClubMembers cm
    LEFT JOIN Minors mi ON mi.memberNo = cm.memberNo
    LEFT JOIN (
        SELECT memberNo, SUM(amount) AS totalPaid
        FROM Payments
        WHERE memYear = YEAR(CURDATE()) - 1
        GROUP BY memberNo
    ) prev ON prev.memberNo = cm.memberNo
)
SELECT
    majorCM.firstName AS majorFirstName,
    majorCM.lastName AS majorLastName,
    minorCM.memberNo,
    minorCM.firstName,
    minorCM.lastName,
    minorCM.dob,
    minorCM.ssn,
    minorCM.medicareNo,
    minorCM.phone,
    minorCM.address,
    minorCM.city,
    minorCM.province,
    minorCM.postalCode,
    fo.relationship,
    ms.status
FROM ClubMembers majorCM
JOIN Majors mj ON mj.memberNo = majorCM.memberNo
JOIN FamilyMembers fm ON fm.ssn = majorCM.ssn
JOIN FamilyOf fo ON fo.familyID = fm.familyID AND fo.endDate IS NULL
JOIN ClubMembers minorCM ON minorCM.memberNo = fo.memberNo
JOIN MemberStatus ms ON ms.memberNo = minorCM.memberNo
ORDER BY majorCM.lastName, majorCM.firstName, minorCM.memberNo;

-- Query vii: sum of membership fees paid and sum of donations collected from major club members between 2023 and 2025
WITH MajorYearly AS (
    SELECT p.memberNo, p.memYear, SUM(p.amount) AS totalPaid
    FROM Payments p
    JOIN Majors mj ON mj.memberNo = p.memberNo
    WHERE p.memYear BETWEEN 2023 AND 2025
    GROUP BY p.memberNo, p.memYear
)
SELECT
    SUM(LEAST(totalPaid, 200)) AS totalMembershipFeesCollected,
    SUM(GREATEST(totalPaid - 200, 0)) AS totalDonationsCollected
FROM MajorYearly;

-- Query viii: club members who played in at least four different FIFA games, sorted ascending by location name, then by age
WITH GameCounts AS (
    SELECT memberNo, COUNT(DISTINCT gameID) AS numGames
    FROM ParticipatesIn
    GROUP BY memberNo
    HAVING COUNT(DISTINCT gameID) >= 4
),
MemberStatus AS (
    SELECT cm.memberNo,
           CASE
               WHEN COALESCE(prev.totalPaid, 0) >= IF(mi.memberNo IS NOT NULL, 100, 200)
               THEN 'Active' ELSE 'Inactive'
           END AS status
    FROM ClubMembers cm
    LEFT JOIN Minors mi ON mi.memberNo = cm.memberNo
    LEFT JOIN (
        SELECT memberNo, SUM(amount) AS totalPaid
        FROM Payments
        WHERE memYear = YEAR(CURDATE()) - 1
        GROUP BY memberNo
    ) prev ON prev.memberNo = cm.memberNo
)
SELECT
    l.name AS locationName,
    cm.memberNo,
    cm.firstName,
    cm.lastName,
    TIMESTAMPDIFF(YEAR, cm.dob, CURDATE()) AS age,
    cm.city,
    cm.province,
    ms.status,
    gc.numGames
FROM ClubMembers cm
JOIN GameCounts gc ON gc.memberNo = cm.memberNo
JOIN MemberAt ma ON ma.memberNo = cm.memberNo AND ma.endDate IS NULL
JOIN Locations l ON l.locationID = ma.locationID
JOIN MemberStatus ms ON ms.memberNo = cm.memberNo
ORDER BY locationName ASC, age ASC;
