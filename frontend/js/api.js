// talks to the Express backend in backend/server.js
// change BASE if the backend isn't running on localhost:3000
const BASE = "http://localhost:3000/api";

// shared fetch wrapper: sends/reads JSON, throws Error(message) on failure
async function apiFetch(path, options = {}) {
  const res = await fetch(BASE + path, {
    headers: { "Content-Type": "application/json" },
    ...options,
  });
  if (res.status === 204) return null; // DELETE responses have no body
  const body = await res.json().catch(() => ({}));
  if (!res.ok) throw new Error(body.error || res.statusText);
  return body;
}

// turns {a: 1, b: undefined} into "?a=1", dropping empty/missing values
function qs(params = {}) {
  const clean = Object.fromEntries(
    Object.entries(params).filter(([, v]) => v !== undefined && v !== null && v !== "")
  );
  const s = new URLSearchParams(clean).toString();
  return s ? "?" + s : "";
}

// ---- Locations (item 1) ----
function getLocations() {
  return apiFetch("/locations");
}
function createLocation(data) {
  return apiFetch("/locations", { method: "POST", body: JSON.stringify(data) });
}
function updateLocation(id, data) {
  return apiFetch(`/locations/${id}`, { method: "PUT", body: JSON.stringify(data) });
}
function deleteLocation(id) {
  return apiFetch(`/locations/${id}`, { method: "DELETE" });
}

// ---- Personnel (item 2) ----
function getPersonnel() {
  return apiFetch("/personnel");
}
function createPersonnel(data) {
  return apiFetch("/personnel", { method: "POST", body: JSON.stringify(data) });
}
function updatePersonnel(id, data) {
  return apiFetch(`/personnel/${id}`, { method: "PUT", body: JSON.stringify(data) });
}
function deletePersonnel(id) {
  return apiFetch(`/personnel/${id}`, { method: "DELETE" });
}

// ---- Family Members (item 3) ----
function getFamilyMembers() {
  return apiFetch("/family-members");
}
function createFamilyMember(data) {
  return apiFetch("/family-members", { method: "POST", body: JSON.stringify(data) });
}
function updateFamilyMember(id, data) {
  return apiFetch(`/family-members/${id}`, { method: "PUT", body: JSON.stringify(data) });
}
function deleteFamilyMember(id) {
  return apiFetch(`/family-members/${id}`, { method: "DELETE" });
}
function linkFamilyMemberToMinor(familyID, data) {
  return apiFetch(`/family-members/${familyID}/link`, { method: "POST", body: JSON.stringify(data) });
}
function unlinkFamilyMemberFromMinor(familyID, memberNo) {
  return apiFetch(`/family-members/${familyID}/link/${memberNo}`, { method: "DELETE" });
}

// ---- Club Members (item 4) ----
function getClubMembers() {
  return apiFetch("/club-members");
}
function createClubMember(data) {
  return apiFetch("/club-members", { method: "POST", body: JSON.stringify(data) });
}
function updateClubMember(id, data) {
  return apiFetch(`/club-members/${id}`, { method: "PUT", body: JSON.stringify(data) });
}
function deleteClubMember(id) {
  return apiFetch(`/club-members/${id}`, { method: "DELETE" });
}

// ---- Sessions / Team Formations (item 5), assignment (item 6) ----
function getSessions() {
  return apiFetch("/sessions");
}
function getSession(sessionID) {
  return apiFetch(`/sessions/${sessionID}`);
}
function createSession(data) {
  return apiFetch("/sessions", { method: "POST", body: JSON.stringify(data) });
}
function deleteSession(sessionID) {
  return apiFetch(`/sessions/${sessionID}`, { method: "DELETE" });
}
function assignMember(teamID, sessionID, data) {
  return apiFetch(`/formations/${teamID}/${sessionID}/assign`, { method: "POST", body: JSON.stringify(data) });
}
function deleteAssignment(teamID, sessionID, memberNo) {
  return apiFetch(`/formations/${teamID}/${sessionID}/assign/${memberNo}`, { method: "DELETE" });
}

// ---- Payments (item 7) ----
function getPayments(memberNo) {
  return apiFetch(`/payments${qs({ memberNo })}`);
}
function createPayment(data) {
  return apiFetch("/payments", { method: "POST", body: JSON.stringify(data) });
}

// ---- Emails (item 22) ----
function getEmailLog(params = {}) {
  return apiFetch(`/emails${qs(params)}`);
}
function generateWeeklyEmails(refSunday) {
  return apiFetch("/emails/generate", { method: "POST", body: JSON.stringify({ refSunday }) });
}

// ---- Lookups (dropdown data) ----
function getMinors() {
  return apiFetch("/lookups/minors");
}
function getTeams() {
  return apiFetch("/lookups/teams");
}

// ---- Reports (items 8-19) ----
// which query params each report needs, read by Reports.html for the input hints
const REPORTS = {
  "locations-fifa-players": { params: [] },
  "primary-family-fifa": { params: [] },
  "team-formations": { params: ["locationID", "start", "end"] },
  "frequent-fifa-players": { params: [] },
  "formations-summary": { params: ["start", "end"] },
  "never-assigned-fifa": { params: [] },
  "majors-since-minors": { params: [] },
  "goalkeeper-only": { params: [] },
  "all-five-roles": { params: [] },
  "head-coach-family": { params: ["locationID"] },
  "never-won": { params: [] },
  "volunteer-family-fifa": { params: [] },
};

function getReport(reportId, params = {}) {
  return apiFetch(`/reports/${reportId}${qs(params)}`);
}
