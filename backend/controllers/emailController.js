// Item 22: generate the weekly session-reminder emails and expose
// the EmailLog. Mirrors sql/9_email_generation.sql. This calls the
// sp_generate_weekly_session_emails stored procedure, so that
// script must have been run against the DB first (it's not part of
// schema.sql -- see backend/README.md).
const pool = require('../db');

// body: { refSunday: 'YYYY-MM-DD' } -- the Sunday the weekly job
// "runs" on; emails go out for sessions in the following 7 days.
// Defaults to the most recent Sunday if omitted.
async function generateWeeklyEmails(req, res) {
  let { refSunday } = req.body || {};
  if (!refSunday) {
    const today = new Date();
    const day = today.getDay(); // 0 = Sunday
    const sunday = new Date(today);
    sunday.setDate(today.getDate() - day);
    refSunday = sunday.toISOString().slice(0, 10);
  }

  const [[before]] = await pool.query('SELECT COUNT(*) AS cnt FROM EmailLog');
  await pool.query('CALL sp_generate_weekly_session_emails(?)', [refSunday]);
  const [[after]] = await pool.query('SELECT COUNT(*) AS cnt FROM EmailLog');

  res.status(201).json({ refSunday, emailsGenerated: after.cnt - before.cnt });
}

async function listEmailLog(req, res) {
  const { receiver, sender } = req.query;
  let sql = `
    SELECT
      e.emailID, e.emailDate,
      l.name AS senderLocation,
      CONCAT(cm.firstName, ' ', cm.lastName) AS receiverName,
      e.receiver AS receiverMemberNo,
      e.subject, e.bodyPreview
    FROM EmailLog e
    JOIN Locations l ON l.locationID = e.sender
    JOIN ClubMembers cm ON cm.memberNo = e.receiver
  `;
  const where = [];
  const params = [];
  if (receiver) {
    where.push('e.receiver = ?');
    params.push(receiver);
  }
  if (sender) {
    where.push('e.sender = ?');
    params.push(sender);
  }
  if (where.length) sql += ' WHERE ' + where.join(' AND ');
  sql += ' ORDER BY e.emailID DESC';
  const [rows] = await pool.query(sql, params);
  res.json(rows);
}

module.exports = { generateWeeklyEmails, listEmailLog };
