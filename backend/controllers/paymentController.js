// Item 7: make/edit/delete a payment for a club member. Mirrors
// sql/6_assignment_payment.sql "Item 7". The 4-installments-per-year
// cap is enforced by trg_payments_max_installments (sql/5_triggers.sql)
// -- this controller just inserts and lets that trigger's SIGNAL
// bubble up to the central error handler as a 409 if it's the 5th.
const pool = require('../db');
const { annualFeeFor } = require('../utils/rules');

async function nextPaymentId(conn) {
  const [[row]] = await conn.query('SELECT COALESCE(MAX(paymentID), 500) + 1 AS id FROM Payments');
  return row.id;
}

async function listPayments(req, res) {
  const { memberNo, memYear } = req.query;
  let sql = `
    SELECT p.paymentID, p.memberNo, p.paymentDate, p.amount, p.method, p.memYear,
           SUM(p.amount) OVER (PARTITION BY p.memberNo, p.memYear) AS totalPaidThatYear
    FROM Payments p
  `;
  const where = [];
  const params = [];
  if (memberNo) {
    where.push('p.memberNo = ?');
    params.push(memberNo);
  }
  if (memYear) {
    where.push('p.memYear = ?');
    params.push(memYear);
  }
  if (where.length) sql += ' WHERE ' + where.join(' AND ');
  sql += ' ORDER BY p.paymentDate';
  const [rows] = await pool.query(sql, params);
  res.json(rows);
}

// Fee/donation breakdown for one member/year -- the excess over the
// $100 (minor) / $200 (major) annual fee counts as a donation, per
// the spec. Nothing is stored for this; it's computed on read.
async function getPaymentSummary(req, res) {
  const { memberNo, memYear } = req.params;
  const [[cm]] = await pool.query('SELECT dob FROM ClubMembers WHERE memberNo = ?', [memberNo]);
  if (!cm) return res.status(404).json({ error: 'Club member not found' });

  // Fee bracket uses the member's *current* age, same convention as
  // the active/inactive calculation in sql/7_queries.sql (age is
  // read as of CURDATE() everywhere, not as of the membership year).
  const fee = annualFeeFor(cm.dob);
  const [[{ totalPaid }]] = await pool.query(
    'SELECT COALESCE(SUM(amount), 0) AS totalPaid FROM Payments WHERE memberNo = ? AND memYear = ?',
    [memberNo, memYear]
  );
  const paid = Number(totalPaid);
  res.json({
    memberNo: Number(memberNo),
    memYear: Number(memYear),
    feeOwed: fee,
    totalPaid: paid,
    towardFee: Math.min(paid, fee),
    donation: Math.max(0, paid - fee),
    fullyPaid: paid >= fee,
  });
}

async function createPayment(req, res) {
  const { memberNo, paymentDate, amount, method, memYear } = req.body;
  if (!memberNo || !amount || !method || !memYear) {
    return res.status(400).json({ error: 'memberNo, amount, method, memYear are required' });
  }
  if (!['Cash', 'Debit', 'Credit'].includes(method)) {
    return res.status(400).json({ error: "method must be 'Cash', 'Debit', or 'Credit'" });
  }

  const conn = await pool.getConnection();
  try {
    await conn.beginTransaction();
    const paymentID = await nextPaymentId(conn);
    await conn.query(
      'INSERT INTO Payments (paymentID, memberNo, paymentDate, amount, method, memYear) VALUES (?, ?, ?, ?, ?, ?)',
      [paymentID, memberNo, paymentDate || new Date().toISOString().slice(0, 10), amount, method, memYear]
    );
    await conn.commit();
    res.status(201).json({ paymentID, memberNo, paymentDate, amount, method, memYear });
  } catch (err) {
    await conn.rollback();
    throw err;
  } finally {
    conn.release();
  }
}

async function updatePayment(req, res) {
  const { id } = req.params;
  const { paymentDate, amount, method } = req.body;
  const [result] = await pool.query(
    'UPDATE Payments SET paymentDate = COALESCE(?, paymentDate), amount = COALESCE(?, amount), method = COALESCE(?, method) WHERE paymentID = ?',
    [paymentDate, amount, method, id]
  );
  if (result.affectedRows === 0) return res.status(404).json({ error: 'Payment not found' });
  const [[row]] = await pool.query('SELECT * FROM Payments WHERE paymentID = ?', [id]);
  res.json(row);
}

async function deletePayment(req, res) {
  const { id } = req.params;
  const [result] = await pool.query('DELETE FROM Payments WHERE paymentID = ?', [id]);
  if (result.affectedRows === 0) return res.status(404).json({ error: 'Payment not found' });
  res.status(204).end();
}

module.exports = { listPayments, getPaymentSummary, createPayment, updatePayment, deletePayment };
