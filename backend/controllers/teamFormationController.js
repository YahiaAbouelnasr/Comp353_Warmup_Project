// Item 5: TeamFormation CRUD, and Item 6: assign/edit/delete a club
// member on a formation. Mirrors sql/4_crud_operations.sql "Item 5"
// and sql/6_assignment_payment.sql "Item 6".
//
// The 3-hour same-day conflict rule is enforced by the DB triggers
// trg_assignedto_conflict_ins / _upd (sql/5_triggers.sql) -- this
// controller does NOT re-implement that check, it just lets the
// trigger's SIGNAL bubble up; server.js's error handler turns that
// into a 409 with the trigger's message.
const pool = require('../db');
const { VALID_ROLES } = require('../utils/rules');

async function nextSessionId(conn) {
  const [[row]] = await conn.query('SELECT COALESCE(MAX(sessionID), 600) + 1 AS id FROM Sessions');
  return row.id;
}

async function listSessions(req, res) {
  const { locationID, start, end, nature } = req.query;
  let sql = `
    SELECT DISTINCT s.sessionID, s.sessionDateTime, s.address, s.nature
    FROM Sessions s
  `;
  const where = [];
  const params = [];
  if (locationID) {
    sql += ' JOIN TeamFormations tf ON tf.sessionID = s.sessionID JOIN BelongsTo bt ON bt.teamID = tf.teamID';
    where.push('bt.locationID = ?');
    params.push(locationID);
  }
  if (start) {
    where.push('DATE(s.sessionDateTime) >= ?');
    params.push(start);
  }
  if (end) {
    where.push('DATE(s.sessionDateTime) <= ?');
    params.push(end);
  }
  if (nature) {
    where.push('s.nature = ?');
    params.push(nature);
  }
  if (where.length) sql += ' WHERE ' + where.join(' AND ');
  sql += ' ORDER BY s.sessionDateTime';
  const [rows] = await pool.query(sql, params);
  res.json(rows);
}

// Full detail for one session: both formations, head coaches, scores,
// and rosters. Same shape as the "display" query in Item 5.
async function getSession(req, res) {
  const { sessionID } = req.params;
  const [[session]] = await pool.query('SELECT * FROM Sessions WHERE sessionID = ?', [sessionID]);
  if (!session) return res.status(404).json({ error: 'Session not found' });

  const [rows] = await pool.query(
    `SELECT
       t.teamID, t.teamName, t.gender, bt.locationID,
       tf.personnelID, CONCAT(p.firstName, ' ', p.lastName) AS headCoach,
       tf.score,
       cm.memberNo, cm.firstName, cm.lastName, at.\`role\`
     FROM TeamFormations tf
     JOIN Teams t ON t.teamID = tf.teamID
     JOIN BelongsTo bt ON bt.teamID = tf.teamID
     JOIN Personnel p ON p.personnelID = tf.personnelID
     LEFT JOIN AssignedTo at ON at.teamID = tf.teamID AND at.sessionID = tf.sessionID
     LEFT JOIN ClubMembers cm ON cm.memberNo = at.memberNo
     WHERE tf.sessionID = ?
     ORDER BY tf.teamID, cm.lastName`,
    [sessionID]
  );

  const formations = {};
  for (const r of rows) {
    if (!formations[r.teamID]) {
      formations[r.teamID] = {
        teamID: r.teamID,
        teamName: r.teamName,
        gender: r.gender,
        locationID: r.locationID,
        personnelID: r.personnelID,
        headCoach: r.headCoach,
        score: r.score,
        roster: [],
      };
    }
    if (r.memberNo) {
      formations[r.teamID].roster.push({ memberNo: r.memberNo, firstName: r.firstName, lastName: r.lastName, role: r.role });
    }
  }

  res.json({ ...session, formations: Object.values(formations) });
}

// body: { sessionDateTime, address, nature, formations: [{ teamID, personnelID, score }, ...] }
async function createSession(req, res) {
  const { sessionDateTime, address, nature, formations = [] } = req.body;
  if (!sessionDateTime || !address || !nature) {
    return res.status(400).json({ error: 'sessionDateTime, address, nature are required' });
  }
  if (!['Training', 'Game'].includes(nature)) {
    return res.status(400).json({ error: "nature must be 'Training' or 'Game'" });
  }
  if (formations.length !== 2) {
    return res.status(400).json({ error: 'A session needs exactly two team formations (spec: every session consists of two teams).' });
  }

  const conn = await pool.getConnection();
  try {
    await conn.beginTransaction();
    const sessionID = await nextSessionId(conn);
    await conn.query('INSERT INTO Sessions (sessionID, sessionDateTime, address, nature) VALUES (?, ?, ?, ?)', [
      sessionID,
      sessionDateTime,
      address,
      nature,
    ]);
    for (const f of formations) {
      await conn.query('INSERT INTO TeamFormations (personnelID, teamID, sessionID, score) VALUES (?, ?, ?, ?)', [
        f.personnelID,
        f.teamID,
        sessionID,
        f.score ?? null,
      ]);
    }
    await conn.commit();
    res.status(201).json({ sessionID, sessionDateTime, address, nature, formations });
  } catch (err) {
    await conn.rollback();
    throw err;
  } finally {
    conn.release();
  }
}

async function updateSession(req, res) {
  const { sessionID } = req.params;
  const { sessionDateTime, address, nature } = req.body;
  const [existing] = await pool.query('SELECT * FROM Sessions WHERE sessionID = ?', [sessionID]);
  if (existing.length === 0) return res.status(404).json({ error: 'Session not found' });

  await pool.query(
    `UPDATE Sessions SET sessionDateTime = COALESCE(?, sessionDateTime), address = COALESCE(?, address),
       nature = COALESCE(?, nature) WHERE sessionID = ?`,
    [sessionDateTime, address, nature, sessionID]
  );
  const [[row]] = await pool.query('SELECT * FROM Sessions WHERE sessionID = ?', [sessionID]);
  res.json(row);
}

async function updateFormation(req, res) {
  const { teamID, sessionID } = req.params;
  const { personnelID, score } = req.body;
  const [result] = await pool.query(
    `UPDATE TeamFormations SET personnelID = COALESCE(?, personnelID), score = ? WHERE teamID = ? AND sessionID = ?`,
    [personnelID || null, score ?? null, teamID, sessionID]
  );
  if (result.affectedRows === 0) return res.status(404).json({ error: 'Formation not found' });
  const [[row]] = await pool.query('SELECT * FROM TeamFormations WHERE teamID = ? AND sessionID = ?', [teamID, sessionID]);
  res.json(row);
}

async function deleteSession(req, res) {
  const { sessionID } = req.params;
  const conn = await pool.getConnection();
  try {
    await conn.beginTransaction();
    await conn.query('DELETE FROM AssignedTo WHERE sessionID = ?', [sessionID]);
    await conn.query('DELETE FROM TeamFormations WHERE sessionID = ?', [sessionID]);
    const [result] = await conn.query('DELETE FROM Sessions WHERE sessionID = ?', [sessionID]);
    await conn.commit();
    if (result.affectedRows === 0) return res.status(404).json({ error: 'Session not found' });
    res.status(204).end();
  } catch (err) {
    await conn.rollback();
    throw err;
  } finally {
    conn.release();
  }
}

// ---- Item 6: assign / edit / delete a club member on a formation ----

async function assignMember(req, res) {
  const { teamID, sessionID } = req.params;
  const { memberNo, role } = req.body;
  if (!memberNo || !role) return res.status(400).json({ error: 'memberNo and role are required' });
  if (!VALID_ROLES.includes(role)) {
    return res.status(400).json({ error: `role must be one of: ${VALID_ROLES.join(', ')}` });
  }

  // trg_assignedto_conflict_ins fires here and throws (SQLSTATE 45000)
  // if this member is already booked within 3 hours the same day --
  // that error propagates to the central handler as a 409.
  await pool.query('INSERT INTO AssignedTo (memberNo, teamID, sessionID, `role`) VALUES (?, ?, ?, ?)', [
    memberNo,
    teamID,
    sessionID,
    role,
  ]);
  res.status(201).json({ memberNo: Number(memberNo), teamID: Number(teamID), sessionID: Number(sessionID), role });
}

async function updateAssignment(req, res) {
  const { teamID, sessionID, memberNo } = req.params;
  const { role } = req.body;
  if (!role || !VALID_ROLES.includes(role)) {
    return res.status(400).json({ error: `role must be one of: ${VALID_ROLES.join(', ')}` });
  }
  const [result] = await pool.query(
    'UPDATE AssignedTo SET `role` = ? WHERE teamID = ? AND sessionID = ? AND memberNo = ?',
    [role, teamID, sessionID, memberNo]
  );
  if (result.affectedRows === 0) return res.status(404).json({ error: 'Assignment not found' });
  res.json({ memberNo: Number(memberNo), teamID: Number(teamID), sessionID: Number(sessionID), role });
}

async function deleteAssignment(req, res) {
  const { teamID, sessionID, memberNo } = req.params;
  const [result] = await pool.query('DELETE FROM AssignedTo WHERE teamID = ? AND sessionID = ? AND memberNo = ?', [
    teamID,
    sessionID,
    memberNo,
  ]);
  if (result.affectedRows === 0) return res.status(404).json({ error: 'Assignment not found' });
  res.status(204).end();
}

module.exports = {
  listSessions,
  getSession,
  createSession,
  updateSession,
  updateFormation,
  deleteSession,
  assignMember,
  updateAssignment,
  deleteAssignment,
};
