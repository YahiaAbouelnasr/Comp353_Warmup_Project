require('dotenv').config();
const express = require('express');
const cors = require('cors');

const locationsRouter = require('./routes/locations');
const personnelRouter = require('./routes/personnel');
const familyMembersRouter = require('./routes/familyMembers');
const clubMembersRouter = require('./routes/clubMembers');
const teamFormationsRouter = require('./routes/teamFormations');
const paymentsRouter = require('./routes/payments');
const reportsRouter = require('./routes/reports');
const emailsRouter = require('./routes/emails');
const lookupsRouter = require('./routes/lookups');

const app = express();
app.use(cors());
app.use(express.json());

app.get('/api/health', (req, res) => res.json({ ok: true }));

app.use('/api/locations', locationsRouter);
app.use('/api/personnel', personnelRouter);
app.use('/api/family-members', familyMembersRouter);
app.use('/api/club-members', clubMembersRouter);
app.use('/api', teamFormationsRouter); // /api/sessions, /api/formations/...
app.use('/api/payments', paymentsRouter);
app.use('/api/reports', reportsRouter);
app.use('/api/emails', emailsRouter);
app.use('/api/lookups', lookupsRouter);

// Central error handler. Converts MySQL trigger SIGNALs and common
// constraint violations into clean HTTP responses instead of raw
// stack traces, so the frontend can just read err.error.
app.use((err, req, res, next) => {
  console.error(err);

  // BEFORE INSERT/UPDATE trigger: SIGNAL SQLSTATE '45000' (business
  // rule rejection -- age limit, formation conflict, installment cap,
  // single Head location, etc.)
  if (err.sqlState === '45000') {
    return res.status(409).json({ error: err.sqlMessage || 'Rejected by a database business-rule trigger.' });
  }
  if (err.code === 'ER_DUP_ENTRY') {
    return res.status(409).json({ error: 'Duplicate value violates a uniqueness constraint (SSN, Medicare number, etc).' });
  }
  if (err.code === 'ER_ROW_IS_REFERENCED_2' || err.code === 'ER_ROW_IS_REFERENCED') {
    return res.status(409).json({ error: 'Cannot delete/update: other records still reference this row.' });
  }
  if (err.code === 'ER_NO_REFERENCED_ROW_2' || err.code === 'ER_NO_REFERENCED_ROW') {
    return res.status(400).json({ error: 'Referenced record does not exist (bad foreign key).' });
  }

  res.status(500).json({ error: err.sqlMessage || err.message || 'Internal server error' });
});

const PORT = process.env.PORT || 3000;
app.listen(PORT, () => console.log(`CSCS backend listening on http://localhost:${PORT}`));
