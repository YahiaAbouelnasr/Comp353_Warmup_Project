// Shared business-rule constants/helpers, kept consistent with the
// conventions documented at the top of sql/7_queries.sql:
//   - major/minor is computed from age (dob vs today), not the
//     Minors/Majors tables (those just record how someone registered)
//   - active = previous year's payments cover the fee for their age bracket
//   - current location = MemberAt row with endDate IS NULL

const MINOR_ANNUAL_FEE = 100;
const MAJOR_ANNUAL_FEE = 200;
const MAX_INSTALLMENTS_PER_YEAR = 4;

// Kept permissive/consistent with what's actually used across
// sql/3_insert_data.sql and sql/7_queries.sql (item 16 specifically
// filters on the short forms 'Sweeper' and 'Defending'), rather than
// only the compound names from the project spec.
const VALID_ROLES = [
  'Goalkeeper',
  'Right Fullback',
  'Left Fullback',
  'Center Back',
  'Sweeper',
  'Defending',
  'Defending Midfielder',
  'Right Winger',
  'Central Midfielder',
  'Striker',
  'Attacking Midfielder',
  'Left Winger',
];

/** Whole-years age as of `asOf` (Date or 'YYYY-MM-DD'), given a dob string/Date. */
function ageAsOf(dob, asOf = new Date()) {
  const d = new Date(dob);
  const ref = new Date(asOf);
  let age = ref.getFullYear() - d.getFullYear();
  const m = ref.getMonth() - d.getMonth();
  if (m < 0 || (m === 0 && ref.getDate() < d.getDate())) age--;
  return age;
}

function isMajor(dob, asOf = new Date()) {
  return ageAsOf(dob, asOf) >= 18;
}

function annualFeeFor(dob, asOf = new Date()) {
  return isMajor(dob, asOf) ? MAJOR_ANNUAL_FEE : MINOR_ANNUAL_FEE;
}

module.exports = {
  MINOR_ANNUAL_FEE,
  MAJOR_ANNUAL_FEE,
  MAX_INSTALLMENTS_PER_YEAR,
  VALID_ROLES,
  ageAsOf,
  isMajor,
  annualFeeFor,
};
