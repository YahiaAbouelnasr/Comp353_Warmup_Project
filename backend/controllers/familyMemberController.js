// Item 3: FamilyMember CRUD (Primary/Secondary). Mirrors
// sql/4_crud_operations.sql section "Item 3".
const pool = require('../db');

async function listFamilyMembers(req, res) {
  const [rows] = await pool.query(`
    SELECT fm.*, l.locationID AS currentLocationID, l.name AS currentLocation
    FROM FamilyMembers fm
    LEFT JOIN RegistersAt ra ON ra.familyID = fm.familyID AND ra.endDate IS NULL
    LEFT JOIN Locations l ON l.locationID = ra.locationID
    ORDER BY fm.familyID
  `);
  res.json(rows);
}

async function getFamilyMember(req, res) {
  const { id } = req.params;
  const [[fm]] = await pool.query('SELECT * FROM FamilyMembers WHERE familyID = ?', [id]);
  if (!fm) return res.status(404).json({ error: 'Family member not found' });

  const [children] = await pool.query(
    `SELECT cm.memberNo, cm.firstName AS childFirstName, cm.lastName AS childLastName,
            cm.dob, fo.relationship, fo.familyType, fo.startDate
     FROM FamilyOf fo
     JOIN ClubMembers cm ON cm.memberNo = fo.memberNo
     WHERE fo.familyID = ? AND fo.endDate IS NULL`,
    [id]
  );

  const [[loc]] = await pool.query(
    `SELECT l.locationID, l.name FROM RegistersAt ra
     JOIN Locations l ON l.locationID = ra.locationID
     WHERE ra.familyID = ? AND ra.endDate IS NULL`,
    [id]
  );

  res.json({ ...fm, currentLocation: loc || null, children });
}

async function nextFamilyId(conn) {
  const [[row]] = await conn.query('SELECT COALESCE(MAX(familyID), 200) + 1 AS id FROM FamilyMembers');
  return row.id;
}

async function createFamilyMember(req, res) {
  const { firstName, lastName, dob, ssn, medicareNo, phone, email, address, city, province, postalCode, locationID } = req.body;

  if (!firstName || !lastName || !dob || !phone || !postalCode || !locationID) {
    return res.status(400).json({ error: 'firstName, lastName, dob, phone, postalCode, locationID are required' });
  }

  const conn = await pool.getConnection();
  try {
    await conn.beginTransaction();
    const familyID = await nextFamilyId(conn);
    await conn.query(
      `INSERT INTO FamilyMembers (familyID, firstName, lastName, dob, ssn, medicareNo, phone, email, address, city, province, postalCode)
       VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)`,
      [familyID, firstName, lastName, dob, ssn || null, medicareNo || null, phone, email || null, address || null, city || null, province || null, postalCode]
    );
    await conn.query('INSERT INTO RegistersAt (familyID, locationID, startDate, endDate) VALUES (?, ?, CURDATE(), NULL)', [
      familyID,
      locationID,
    ]);
    await conn.commit();
    res.status(201).json({ familyID, firstName, lastName, dob, ssn, medicareNo, phone, email, address, city, province, postalCode });
  } catch (err) {
    await conn.rollback();
    if (err.code === 'ER_DUP_ENTRY') return res.status(409).json({ error: 'Duplicate SSN.' });
    throw err;
  } finally {
    conn.release();
  }
}

async function updateFamilyMember(req, res) {
  const { id } = req.params;
  const { firstName, lastName, dob, ssn, medicareNo, phone, email, address, city, province, postalCode } = req.body;

  const [existing] = await pool.query('SELECT * FROM FamilyMembers WHERE familyID = ?', [id]);
  if (existing.length === 0) return res.status(404).json({ error: 'Family member not found' });

  await pool.query(
    `UPDATE FamilyMembers SET
       firstName = COALESCE(?, firstName), lastName = COALESCE(?, lastName), dob = COALESCE(?, dob),
       ssn = COALESCE(?, ssn), medicareNo = COALESCE(?, medicareNo), phone = COALESCE(?, phone),
       email = COALESCE(?, email), address = COALESCE(?, address), city = COALESCE(?, city),
       province = COALESCE(?, province), postalCode = COALESCE(?, postalCode)
     WHERE familyID = ?`,
    [firstName, lastName, dob, ssn, medicareNo, phone, email, address, city, province, postalCode, id]
  );
  const [[row]] = await pool.query('SELECT * FROM FamilyMembers WHERE familyID = ?', [id]);
  res.json(row);
}

// Link (or re-link) a family member to a minor club member. If
// familyType='Primary', any existing active Primary link for that
// minor is closed out first (same "one active Primary" rule the
// trg_familyof_close_previous_primary-style logic enforces).
async function linkToMember(req, res) {
  const { id } = req.params; // familyID
  const { memberNo, relationship, familyType = 'Secondary' } = req.body;
  if (!memberNo || !relationship) return res.status(400).json({ error: 'memberNo and relationship are required' });

  const [[isMinor]] = await pool.query('SELECT 1 FROM Minors WHERE memberNo = ?', [memberNo]);
  if (!isMinor) return res.status(400).json({ error: 'FamilyOf links only apply to minor club members.' });

  const conn = await pool.getConnection();
  try {
    await conn.beginTransaction();
    if (familyType === 'Primary') {
      await conn.query(
        `UPDATE FamilyOf SET endDate = CURDATE()
         WHERE memberNo = ? AND familyType = 'Primary' AND endDate IS NULL`,
        [memberNo]
      );
    }
    await conn.query(
      `INSERT INTO FamilyOf (memberNo, familyID, relationship, familyType, startDate, endDate)
       VALUES (?, ?, ?, ?, CURDATE(), NULL)`,
      [memberNo, id, relationship, familyType]
    );
    await conn.commit();
    res.status(201).json({ memberNo: Number(memberNo), familyID: Number(id), relationship, familyType });
  } catch (err) {
    await conn.rollback();
    throw err;
  } finally {
    conn.release();
  }
}

async function unlinkFromMember(req, res) {
  const { id, memberNo } = req.params;
  const [result] = await pool.query(
    `UPDATE FamilyOf SET endDate = CURDATE() WHERE familyID = ? AND memberNo = ? AND endDate IS NULL`,
    [id, memberNo]
  );
  if (result.affectedRows === 0) return res.status(404).json({ error: 'No active link found for that family member/club member pair.' });
  res.status(204).end();
}

async function deleteFamilyMember(req, res) {
  const { id } = req.params;
  const conn = await pool.getConnection();
  try {
    await conn.beginTransaction();
    await conn.query(`UPDATE FamilyOf SET endDate = CURDATE() WHERE familyID = ? AND endDate IS NULL`, [id]);
    await conn.query('DELETE FROM FamilyOf WHERE familyID = ?', [id]);
    await conn.query('DELETE FROM RegistersAt WHERE familyID = ?', [id]);
    const [result] = await conn.query('DELETE FROM FamilyMembers WHERE familyID = ?', [id]);
    await conn.commit();
    if (result.affectedRows === 0) return res.status(404).json({ error: 'Family member not found' });
    res.status(204).end();
  } catch (err) {
    await conn.rollback();
    throw err;
  } finally {
    conn.release();
  }
}

module.exports = {
  listFamilyMembers,
  getFamilyMember,
  createFamilyMember,
  updateFamilyMember,
  linkToMember,
  unlinkFromMember,
  deleteFamilyMember,
};
