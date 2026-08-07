// Item 2: Personnel CRUD. Mirrors sql/4_crud_operations.sql section "Item 2".
// Creating a personnel record also opens a WorksAt row at the given
// location (trg_worksat_close_previous style history isn't needed here
// since a new hire has no prior row); deleting closes out WorksAt/Manages
// first so the FK constraints don't block it.
const pool = require('../db');

const SELECT_WITH_LOCATION = `
  SELECT
    p.personnelID, p.firstName, p.lastName, p.dob, p.ssn, p.medicareNo, p.phone, p.email,
    p.address, p.city, p.province, p.postalCode, p.\`role\`, p.title, p.mandate,
    l.locationID AS currentLocationID, l.name AS currentLocation, w.startDate AS workingSince
  FROM Personnel p
  LEFT JOIN WorksAt w ON w.personnelID = p.personnelID AND w.endDate IS NULL
  LEFT JOIN Locations l ON l.locationID = w.locationID
`;

async function listPersonnel(req, res) {
  const { locationID } = req.query;
  let sql = SELECT_WITH_LOCATION;
  const params = [];
  if (locationID) {
    sql += ' WHERE l.locationID = ?';
    params.push(locationID);
  }
  sql += ' ORDER BY p.personnelID';
  const [rows] = await pool.query(sql, params);
  res.json(rows);
}

async function getPersonnel(req, res) {
  const [rows] = await pool.query(`${SELECT_WITH_LOCATION} WHERE p.personnelID = ?`, [req.params.id]);
  if (rows.length === 0) return res.status(404).json({ error: 'Personnel not found' });
  res.json(rows[0]);
}

async function nextPersonnelId(conn) {
  const [[row]] = await conn.query('SELECT COALESCE(MAX(personnelID), 100) + 1 AS id FROM Personnel');
  return row.id;
}

async function createPersonnel(req, res) {
  const {
    firstName, lastName, dob, ssn, medicareNo, phone, email,
    address, city, province, postalCode, role, title, mandate, locationID,
  } = req.body;

  if (!firstName || !lastName || !dob || !ssn || !role || !mandate || !locationID) {
    return res.status(400).json({ error: 'firstName, lastName, dob, ssn, role, mandate, locationID are required' });
  }

  const conn = await pool.getConnection();
  try {
    await conn.beginTransaction();
    const personnelID = await nextPersonnelId(conn);

    await conn.query(
      `INSERT INTO Personnel
       (personnelID, firstName, lastName, dob, ssn, medicareNo, phone, email, address, city, province, postalCode, \`role\`, title, mandate)
       VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)`,
      [personnelID, firstName, lastName, dob, ssn, medicareNo || null, phone || null, email || null,
        address || null, city || null, province || null, postalCode || null, role, title || null, mandate]
    );

    await conn.query('INSERT INTO WorksAt (personnelID, locationID, startDate, endDate) VALUES (?, ?, CURDATE(), NULL)', [
      personnelID,
      locationID,
    ]);

    await conn.commit();
    const [[row]] = await conn.query(`${SELECT_WITH_LOCATION} WHERE p.personnelID = ?`, [personnelID]);
    res.status(201).json(row);
  } catch (err) {
    await conn.rollback();
    if (err.code === 'ER_DUP_ENTRY') {
      return res.status(409).json({ error: 'Duplicate SSN or Medicare number.' });
    }
    throw err;
  } finally {
    conn.release();
  }
}

async function updatePersonnel(req, res) {
  const { id } = req.params;
  const {
    firstName, lastName, dob, ssn, medicareNo, phone, email,
    address, city, province, postalCode, role, title, mandate,
  } = req.body;

  const [existing] = await pool.query('SELECT * FROM Personnel WHERE personnelID = ?', [id]);
  if (existing.length === 0) return res.status(404).json({ error: 'Personnel not found' });

  try {
    await pool.query(
      `UPDATE Personnel SET
         firstName = COALESCE(?, firstName), lastName = COALESCE(?, lastName), dob = COALESCE(?, dob),
         ssn = COALESCE(?, ssn), medicareNo = COALESCE(?, medicareNo), phone = COALESCE(?, phone),
         email = COALESCE(?, email), address = COALESCE(?, address), city = COALESCE(?, city),
         province = COALESCE(?, province), postalCode = COALESCE(?, postalCode),
         \`role\` = COALESCE(?, \`role\`), title = COALESCE(?, title), mandate = COALESCE(?, mandate)
       WHERE personnelID = ?`,
      [firstName, lastName, dob, ssn, medicareNo, phone, email, address, city, province, postalCode, role, title, mandate, id]
    );
  } catch (err) {
    if (err.code === 'ER_DUP_ENTRY') {
      return res.status(409).json({ error: 'Duplicate SSN or Medicare number.' });
    }
    throw err;
  }

  const [[row]] = await pool.query(`${SELECT_WITH_LOCATION} WHERE p.personnelID = ?`, [id]);
  res.json(row);
}

// Moves a personnel record to a new location: closes the current
// active WorksAt row and opens a new one, same pattern the DB trigger
// trg_worksat_close_previous performs automatically if you insert
// straight into WorksAt with a NULL endDate.
async function transferPersonnel(req, res) {
  const { id } = req.params;
  const { locationID, startDate } = req.body;
  if (!locationID) return res.status(400).json({ error: 'locationID is required' });

  const conn = await pool.getConnection();
  try {
    await conn.beginTransaction();
    const effectiveStart = startDate || new Date().toISOString().slice(0, 10);
    await conn.query(
      'UPDATE WorksAt SET endDate = DATE_SUB(?, INTERVAL 1 DAY) WHERE personnelID = ? AND endDate IS NULL',
      [effectiveStart, id]
    );
    await conn.query('INSERT INTO WorksAt (personnelID, locationID, startDate, endDate) VALUES (?, ?, ?, NULL)', [
      id,
      locationID,
      effectiveStart,
    ]);
    await conn.commit();
    const [[row]] = await conn.query(`${SELECT_WITH_LOCATION} WHERE p.personnelID = ?`, [id]);
    res.json(row);
  } catch (err) {
    await conn.rollback();
    throw err;
  } finally {
    conn.release();
  }
}

async function deletePersonnel(req, res) {
  const { id } = req.params;
  const conn = await pool.getConnection();
  try {
    await conn.beginTransaction();
    await conn.query('UPDATE WorksAt SET endDate = CURDATE() WHERE personnelID = ? AND endDate IS NULL', [id]);
    await conn.query('DELETE FROM Manages WHERE personnelID = ?', [id]);
    await conn.query('DELETE FROM WorksAt WHERE personnelID = ?', [id]);
    const [result] = await conn.query('DELETE FROM Personnel WHERE personnelID = ?', [id]);
    await conn.commit();
    if (result.affectedRows === 0) return res.status(404).json({ error: 'Personnel not found' });
    res.status(204).end();
  } catch (err) {
    await conn.rollback();
    if (err.code === 'ER_ROW_IS_REFERENCED_2' || err.code === 'ER_ROW_IS_REFERENCED') {
      return res.status(409).json({ error: 'Cannot delete: personnel still referenced (e.g. as a head coach in TeamFormations).' });
    }
    throw err;
  } finally {
    conn.release();
  }
}

module.exports = {
  listPersonnel,
  getPersonnel,
  createPersonnel,
  updatePersonnel,
  transferPersonnel,
  deletePersonnel,
};
