// Item 4: ClubMember CRUD (Major/Minor). Mirrors sql/4_crud_operations.sql
// section "Item 4". Note: this schema classifies Minors/Majors by an
// explicit insert at registration time (not a trigger) -- age is
// computed here in JS and the matching subtype row is inserted in the
// same transaction, exactly like the SQL script does by hand.
const pool = require('../db');
const { ageAsOf, annualFeeFor } = require('../utils/rules');

const DETAIL_SELECT = `
  SELECT
    cm.memberNo, cm.firstName, cm.lastName, cm.dob, cm.height, cm.weight, cm.ssn, cm.medicareNo,
    cm.phone, cm.email, cm.address, cm.city, cm.province, cm.postalCode,
    IF(mi.memberNo IS NOT NULL, 'Minor', 'Major') AS memberType,
    l.locationID AS currentLocationID, l.name AS currentLocation,
    GROUP_CONCAT(DISTINCT hh.hobbyName SEPARATOR ', ') AS hobbies
  FROM ClubMembers cm
  LEFT JOIN Minors mi ON mi.memberNo = cm.memberNo
  LEFT JOIN MemberAt ma ON ma.memberNo = cm.memberNo AND ma.endDate IS NULL
  LEFT JOIN Locations l ON l.locationID = ma.locationID
  LEFT JOIN HasHobby hh ON hh.memberNo = cm.memberNo
`;
const DETAIL_GROUP_BY = `
  GROUP BY cm.memberNo, cm.firstName, cm.lastName, cm.dob, cm.height, cm.weight, cm.ssn, cm.medicareNo,
           cm.phone, cm.email, cm.address, cm.city, cm.province, cm.postalCode, memberType,
           l.locationID, l.name
`;

async function withStatus(row) {
  const [[prev]] = await pool.query(
    'SELECT COALESCE(SUM(amount), 0) AS totalPaid FROM Payments WHERE memberNo = ? AND memYear = YEAR(CURDATE()) - 1',
    [row.memberNo]
  );
  const fee = annualFeeFor(row.dob);
  return {
    ...row,
    age: ageAsOf(row.dob),
    status: Number(prev.totalPaid) >= fee ? 'Active' : 'Inactive',
  };
}

async function listClubMembers(req, res) {
  const { locationID, memberType } = req.query;
  let sql = DETAIL_SELECT;
  const where = [];
  const params = [];
  if (locationID) {
    where.push('l.locationID = ?');
    params.push(locationID);
  }
  if (memberType === 'Minor') where.push('mi.memberNo IS NOT NULL');
  if (memberType === 'Major') where.push('mi.memberNo IS NULL');
  if (where.length) sql += ' WHERE ' + where.join(' AND ');
  sql += DETAIL_GROUP_BY + ' ORDER BY cm.memberNo';

  const [rows] = await pool.query(sql, params);
  res.json(await Promise.all(rows.map(withStatus)));
}

async function getClubMember(req, res) {
  const [rows] = await pool.query(`${DETAIL_SELECT} WHERE cm.memberNo = ? ${DETAIL_GROUP_BY}`, [req.params.id]);
  if (rows.length === 0) return res.status(404).json({ error: 'Club member not found' });
  res.json(await withStatus(rows[0]));
}

async function createClubMember(req, res) {
  const {
    firstName, lastName, dob, height, weight, ssn, medicareNo, phone, email,
    address, city, province, postalCode, locationID, hobbies = [],
    familyID, relationship, // required when the new member is a minor
  } = req.body;

  if (!firstName || !lastName || !dob || !postalCode || !locationID) {
    return res.status(400).json({ error: 'firstName, lastName, dob, postalCode, locationID are required' });
  }
  const age = ageAsOf(dob);
  if (age < 4) {
    return res.status(400).json({ error: 'A new club member must be at least 4 years old.' });
  }
  const isMinor = age < 18;
  if (isMinor && (!familyID || !relationship)) {
    return res.status(400).json({ error: 'Minor registrations require familyID and relationship (a registered family member).' });
  }

  const conn = await pool.getConnection();
  try {
    await conn.beginTransaction();

    const [insertResult] = await conn.query(
      `INSERT INTO ClubMembers
       (firstName, lastName, dob, height, weight, ssn, medicareNo, phone, email, address, city, province, postalCode)
       VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)`,
      [firstName, lastName, dob, height || null, weight || null, ssn || null, medicareNo || null, phone || null,
        email || null, address || null, city || null, province || null, postalCode]
    );
    const memberNo = insertResult.insertId;

    if (isMinor) {
      await conn.query('INSERT INTO Minors (memberNo) VALUES (?)', [memberNo]);
      await conn.query(
        `INSERT INTO FamilyOf (memberNo, familyID, relationship, familyType, startDate, endDate)
         VALUES (?, ?, ?, 'Primary', CURDATE(), NULL)`,
        [memberNo, familyID, relationship]
      );
    } else {
      await conn.query('INSERT INTO Majors (memberNo) VALUES (?)', [memberNo]);
    }

    await conn.query('INSERT INTO MemberAt (memberNo, locationID, startDate, endDate) VALUES (?, ?, CURDATE(), NULL)', [
      memberNo,
      locationID,
    ]);

    for (const hobbyName of hobbies) {
      await conn.query('INSERT INTO HasHobby (memberNo, hobbyName) VALUES (?, ?)', [memberNo, hobbyName]);
    }

    await conn.commit();
    const [rows] = await pool.query(`${DETAIL_SELECT} WHERE cm.memberNo = ? ${DETAIL_GROUP_BY}`, [memberNo]);
    res.status(201).json(await withStatus(rows[0]));
  } catch (err) {
    await conn.rollback();
    if (err.code === 'ER_DUP_ENTRY') return res.status(409).json({ error: 'Duplicate SSN.' });
    if (err.errno === 1644) return res.status(400).json({ error: err.sqlMessage }); // trg_clubmembers_min_age SIGNAL
    throw err;
  } finally {
    conn.release();
  }
}

async function updateClubMember(req, res) {
  const { id } = req.params;
  const { firstName, lastName, dob, height, weight, ssn, medicareNo, phone, email, address, city, province, postalCode } = req.body;

  const [existing] = await pool.query('SELECT * FROM ClubMembers WHERE memberNo = ?', [id]);
  if (existing.length === 0) return res.status(404).json({ error: 'Club member not found' });

  await pool.query(
    `UPDATE ClubMembers SET
       firstName = COALESCE(?, firstName), lastName = COALESCE(?, lastName), dob = COALESCE(?, dob),
       height = COALESCE(?, height), weight = COALESCE(?, weight), ssn = COALESCE(?, ssn),
       medicareNo = COALESCE(?, medicareNo), phone = COALESCE(?, phone), email = COALESCE(?, email),
       address = COALESCE(?, address), city = COALESCE(?, city), province = COALESCE(?, province),
       postalCode = COALESCE(?, postalCode)
     WHERE memberNo = ?`,
    [firstName, lastName, dob, height, weight, ssn, medicareNo, phone, email, address, city, province, postalCode, id]
  );

  const [rows] = await pool.query(`${DETAIL_SELECT} WHERE cm.memberNo = ? ${DETAIL_GROUP_BY}`, [id]);
  res.json(await withStatus(rows[0]));
}

// Move a club member to a different branch (spec: "a member can move
// to a different branch if/when desired"). Same close-then-open
// pattern as personnel transfers.
async function transferClubMember(req, res) {
  const { id } = req.params;
  const { locationID, startDate } = req.body;
  if (!locationID) return res.status(400).json({ error: 'locationID is required' });

  const conn = await pool.getConnection();
  try {
    await conn.beginTransaction();
    const effectiveStart = startDate || new Date().toISOString().slice(0, 10);
    await conn.query('UPDATE MemberAt SET endDate = DATE_SUB(?, INTERVAL 1 DAY) WHERE memberNo = ? AND endDate IS NULL', [
      effectiveStart,
      id,
    ]);
    await conn.query('INSERT INTO MemberAt (memberNo, locationID, startDate, endDate) VALUES (?, ?, ?, NULL)', [
      id,
      locationID,
      effectiveStart,
    ]);
    await conn.commit();
    const [rows] = await pool.query(`${DETAIL_SELECT} WHERE cm.memberNo = ? ${DETAIL_GROUP_BY}`, [id]);
    res.json(await withStatus(rows[0]));
  } catch (err) {
    await conn.rollback();
    throw err;
  } finally {
    conn.release();
  }
}

async function deleteClubMember(req, res) {
  const { id } = req.params;
  const conn = await pool.getConnection();
  try {
    await conn.beginTransaction();
    await conn.query('UPDATE MemberAt SET endDate = CURDATE() WHERE memberNo = ? AND endDate IS NULL', [id]);
    await conn.query('DELETE FROM HasHobby WHERE memberNo = ?', [id]);
    await conn.query('DELETE FROM MemberAt WHERE memberNo = ?', [id]);
    await conn.query('UPDATE FamilyOf SET endDate = CURDATE() WHERE memberNo = ? AND endDate IS NULL', [id]);
    await conn.query('DELETE FROM FamilyOf WHERE memberNo = ?', [id]);
    await conn.query('DELETE FROM Minors WHERE memberNo = ?', [id]);
    await conn.query('DELETE FROM Majors WHERE memberNo = ?', [id]);
    const [result] = await conn.query('DELETE FROM ClubMembers WHERE memberNo = ?', [id]);
    await conn.commit();
    if (result.affectedRows === 0) return res.status(404).json({ error: 'Club member not found' });
    res.status(204).end();
  } catch (err) {
    await conn.rollback();
    if (err.code === 'ER_ROW_IS_REFERENCED_2' || err.code === 'ER_ROW_IS_REFERENCED') {
      return res.status(409).json({ error: 'Cannot delete: club member still referenced (payments, assignments, FIFA participation, etc.). Remove those first.' });
    }
    throw err;
  } finally {
    conn.release();
  }
}

module.exports = {
  listClubMembers,
  getClubMember,
  createClubMember,
  updateClubMember,
  transferClubMember,
  deleteClubMember,
};
