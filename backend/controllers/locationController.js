// Item 1: Location CRUD. Mirrors sql/4_crud_operations.sql section "Item 1".
const pool = require('../db');

async function nextLocationId(conn) {
  const [[row]] = await conn.query('SELECT COALESCE(MAX(locationID), 0) + 1 AS id FROM Locations');
  return row.id;
}

function baseSelect(whereClause = '') {
  return `
    SELECT
      l.locationID, l.type, l.name, l.address, l.city, l.province, l.postalCode,
      l.webAddress, l.capacity,
      GROUP_CONCAT(DISTINCT lp.phone SEPARATOR ', ') AS phoneNumbers
    FROM Locations l
    LEFT JOIN LocationPhones lp ON lp.locationID = l.locationID
    ${whereClause}
    GROUP BY l.locationID, l.type, l.name, l.address, l.city, l.province, l.postalCode,
             l.webAddress, l.capacity
    ORDER BY l.locationID
  `;
}

async function listLocations(req, res) {
  const [rows] = await pool.query(baseSelect());
  res.json(rows);
}

async function getLocation(req, res) {
  const [rows] = await pool.query(baseSelect('WHERE l.locationID = ?').replace('ORDER BY l.locationID', ''), [
    req.params.id,
  ]);
  if (rows.length === 0) return res.status(404).json({ error: 'Location not found' });
  res.json(rows[0]);
}

async function createLocation(req, res) {
  const { type, name, address, city, province, postalCode, webAddress, capacity, phones = [] } = req.body;

  if (!type || !name || !address || !city || !province || !postalCode || capacity == null) {
    return res.status(400).json({ error: 'type, name, address, city, province, postalCode, capacity are required' });
  }
  if (!['Head', 'Branch'].includes(type)) {
    return res.status(400).json({ error: "type must be 'Head' or 'Branch'" });
  }

  const conn = await pool.getConnection();
  try {
    await conn.beginTransaction();

    if (type === 'Head') {
      const [[{ cnt }]] = await conn.query("SELECT COUNT(*) AS cnt FROM Locations WHERE type = 'Head'");
      if (cnt > 0) {
        await conn.rollback();
        return res.status(409).json({ error: 'A Head location already exists; the club can only have one.' });
      }
    }

    const locationID = await nextLocationId(conn);
    await conn.query(
      `INSERT INTO Locations (locationID, type, name, address, city, province, postalCode, webAddress, capacity)
       VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)`,
      [locationID, type, name, address, city, province, postalCode, webAddress || null, capacity]
    );
    for (const phone of phones) {
      await conn.query('INSERT INTO LocationPhones (locationID, phone) VALUES (?, ?)', [locationID, phone]);
    }

    await conn.commit();
    res.status(201).json({ locationID, type, name, address, city, province, postalCode, webAddress, capacity, phones });
  } catch (err) {
    await conn.rollback();
    throw err;
  } finally {
    conn.release();
  }
}

async function updateLocation(req, res) {
  const { id } = req.params;
  const { type, name, address, city, province, postalCode, webAddress, capacity, phones } = req.body;

  const [existing] = await pool.query('SELECT * FROM Locations WHERE locationID = ?', [id]);
  if (existing.length === 0) return res.status(404).json({ error: 'Location not found' });

  const conn = await pool.getConnection();
  try {
    await conn.beginTransaction();

    if (type === 'Head' && existing[0].type !== 'Head') {
      const [[{ cnt }]] = await conn.query("SELECT COUNT(*) AS cnt FROM Locations WHERE type = 'Head' AND locationID <> ?", [id]);
      if (cnt > 0) {
        await conn.rollback();
        return res.status(409).json({ error: 'A Head location already exists; the club can only have one.' });
      }
    }

    await conn.query(
      `UPDATE Locations SET
         type = COALESCE(?, type), name = COALESCE(?, name), address = COALESCE(?, address),
         city = COALESCE(?, city), province = COALESCE(?, province), postalCode = COALESCE(?, postalCode),
         webAddress = COALESCE(?, webAddress), capacity = COALESCE(?, capacity)
       WHERE locationID = ?`,
      [type, name, address, city, province, postalCode, webAddress, capacity, id]
    );

    if (Array.isArray(phones)) {
      await conn.query('DELETE FROM LocationPhones WHERE locationID = ?', [id]);
      for (const phone of phones) {
        await conn.query('INSERT INTO LocationPhones (locationID, phone) VALUES (?, ?)', [id, phone]);
      }
    }

    await conn.commit();
    const [[row]] = await conn.query(baseSelect('WHERE l.locationID = ?').replace('ORDER BY l.locationID', ''), [id]);
    res.json(row);
  } catch (err) {
    await conn.rollback();
    throw err;
  } finally {
    conn.release();
  }
}

async function deleteLocation(req, res) {
  const { id } = req.params;
  const conn = await pool.getConnection();
  try {
    await conn.beginTransaction();
    await conn.query('DELETE FROM LocationPhones WHERE locationID = ?', [id]);
    const [result] = await conn.query('DELETE FROM Locations WHERE locationID = ?', [id]);
    await conn.commit();
    if (result.affectedRows === 0) return res.status(404).json({ error: 'Location not found' });
    res.status(204).end();
  } catch (err) {
    await conn.rollback();
    if (err.code === 'ER_ROW_IS_REFERENCED_2' || err.code === 'ER_ROW_IS_REFERENCED') {
      return res
        .status(409)
        .json({ error: 'Cannot delete: personnel, members, or teams still reference this location.' });
    }
    throw err;
  } finally {
    conn.release();
  }
}

module.exports = { listLocations, getLocation, createLocation, updateLocation, deleteLocation };
