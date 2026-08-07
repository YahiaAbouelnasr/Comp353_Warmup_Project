// Small read-only lookups the frontend needs to populate dropdowns
// (team picker when scheduling a session, hobby picker when
// registering a member, etc). Nothing here mutates data.
const pool = require('../db');

async function listTeams(req, res) {
  const { locationID } = req.query;
  let sql = `
    SELECT t.teamID, t.teamName, t.gender, bt.locationID, l.name AS locationName
    FROM Teams t
    JOIN BelongsTo bt ON bt.teamID = t.teamID
    JOIN Locations l ON l.locationID = bt.locationID
  `;
  const params = [];
  if (locationID) {
    sql += ' WHERE bt.locationID = ?';
    params.push(locationID);
  }
  sql += ' ORDER BY t.teamID';
  const [rows] = await pool.query(sql, params);
  res.json(rows);
}

async function listHobbies(req, res) {
  const [rows] = await pool.query('SELECT hobbyName FROM Hobbies ORDER BY hobbyName');
  res.json(rows.map((r) => r.hobbyName));
}

async function listMinors(req, res) {
  const [rows] = await pool.query(`
    SELECT cm.memberNo, cm.firstName, cm.lastName, cm.dob
    FROM ClubMembers cm
    JOIN Minors mi ON mi.memberNo = cm.memberNo
    ORDER BY cm.lastName, cm.firstName
  `);
  res.json(rows);
}

module.exports = { listTeams, listHobbies, listMinors };
