const API_BASE = "http://localhost:3000/api";

async function apiRequest(path, options = {}) {
  const res = await fetch(API_BASE + path, {
    headers: { "Content-Type": "application/json" },
    ...options,
  });

  const body = await res.json().catch(() => ({}));

  if (!res.ok) {
    throw new Error(body.error || "Request failed");
  }

  return body;
}

function withQuery(path, params = {}) {
  const cleaned = {};
  for (const key in params) {
    if (params[key] !== undefined && params[key] !== null && params[key] !== "") {
      cleaned[key] = params[key];
    }
  }
  const query = new URLSearchParams(cleaned).toString();
  return query ? `${path}?${query}` : path;
}

function getLocations() {
  return apiRequest("/locations");
}
function getLocation(id) {
  return apiRequest(`/locations/${id}`);
}
function createLocation(data) {
  return apiRequest("/locations", { method: "POST", body: JSON.stringify(data) });
}
function updateLocation(id, data) {
  return apiRequest(`/locations/${id}`, { method: "PUT", body: JSON.stringify(data) });
}
function deleteLocation(id) {
  return apiRequest(`/locations/${id}`, { method: "DELETE" });
}

function getPersonnel(locationID) {
  return apiRequest(withQuery("/personnel", { locationID }));
}
function getPersonnelById(id) {
  return apiRequest(`/personnel/${id}`);
}
function createPersonnel(data) {
  return apiRequest("/personnel", { method: "POST", body: JSON.stringify(data) });
}
function updatePersonnel(id, data) {
  return apiRequest(`/personnel/${id}`, { method: "PUT", body: JSON.stringify(data) });
}
function transferPersonnel(id, data) {
  return apiRequest(`/personnel/${id}/transfer`, { method: "POST", body: JSON.stringify(data) });
}
function deletePersonnel(id) {
  return apiRequest(`/personnel/${id}`, { method: "DELETE" });
}

function getFamilyMembers() {
  return apiRequest("/family-members");
}
function getFamilyMember(id) {
  return apiRequest(`/family-members/${id}`);
}
function createFamilyMember(data) {
  return apiRequest("/family-members", { method: "POST", body: JSON.stringify(data) });
}
function updateFamilyMember(id, data) {
  return apiRequest(`/family-members/${id}`, { method: "PUT", body: JSON.stringify(data) });
}
function linkFamilyMemberToMinor(id, data) {
  return apiRequest(`/family-members/${id}/link`, { method: "POST", body: JSON.stringify(data) });
}
function unlinkFamilyMemberFromMinor(id, memberNo) {
  return apiRequest(`/family-members/${id}/link/${memberNo}`, { method: "DELETE" });
}
function deleteFamilyMember(id) {
  return apiRequest(`/family-members/${id}`, { method: "DELETE" });
}

function getClubMembers(filters = {}) {
  return apiRequest(withQuery("/club-members", filters)); 
}
function getClubMember(id) {
  return apiRequest(`/club-members/${id}`);
}
function createClubMember(data) {
  return apiRequest("/club-members", { method: "POST", body: JSON.stringify(data) });
}
function updateClubMember(id, data) {
  return apiRequest(`/club-members/${id}`, { method: "PUT", body: JSON.stringify(data) });
}
function transferClubMember(id, data) {
  return apiRequest(`/club-members/${id}/transfer`, { method: "POST", body: JSON.stringify(data) });
}
function deleteClubMember(id) {
  return apiRequest(`/club-members/${id}`, { method: "DELETE" });
}

function getSessions(filters = {}) {
  return apiRequest(withQuery("/sessions", filters)); 
}
function getSession(sessionID) {
  return apiRequest(`/sessions/${sessionID}`);
}
function createSession(data) {
  return apiRequest("/sessions", { method: "POST", body: JSON.stringify(data) });
}
function updateSession(sessionID, data) {
  return apiRequest(`/sessions/${sessionID}`, { method: "PUT", body: JSON.stringify(data) });
}
function deleteSession(sessionID) {
  return apiRequest(`/sessions/${sessionID}`, { method: "DELETE" });
}
function updateFormation(teamID, sessionID, data) {
  return apiRequest(`/formations/${teamID}/${sessionID}`, { method: "PUT", body: JSON.stringify(data) });
}
function assignMember(teamID, sessionID, data) {
  return apiRequest(`/formations/${teamID}/${sessionID}/assign`, { method: "POST", body: JSON.stringify(data) });
}
function updateAssignment(teamID, sessionID, memberNo, data) {
  return apiRequest(`/formations/${teamID}/${sessionID}/assign/${memberNo}`, {
    method: "PUT",
    body: JSON.stringify(data),
  });
}
function deleteAssignment(teamID, sessionID, memberNo) {
  return apiRequest(`/formations/${teamID}/${sessionID}/assign/${memberNo}`, { method: "DELETE" });
}

function getPayments(memberNo, memYear) {
  return apiRequest(withQuery("/payments", { memberNo, memYear }));
}
function getPaymentSummary(memberNo, memYear) {
  return apiRequest(`/payments/summary/${memberNo}/${memYear}`);
}
function createPayment(data) {
  return apiRequest("/payments", { method: "POST", body: JSON.stringify(data) });
}
function updatePayment(id, data) {
  return apiRequest(`/payments/${id}`, { method: "PUT", body: JSON.stringify(data) });
}
function deletePayment(id) {
  return apiRequest(`/payments/${id}`, { method: "DELETE" });
}

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

function getReport(reportKey, params = {}) {
  return apiRequest(withQuery(`/reports/${reportKey}`, params));
}

function getEmailLog(filters = {}) {
  return apiRequest(withQuery("/emails", filters)); 
}
function generateWeeklyEmails(refSunday) {
  return apiRequest("/emails/generate", {
    method: "POST",
    body: JSON.stringify(refSunday ? { refSunday } : {}),
  });
}

function getTeams(locationID) {
  return apiRequest(withQuery("/lookups/teams", { locationID }));
}
function getHobbies() {
  return apiRequest("/lookups/hobbies");
}
function getMinors() {
  return apiRequest("/lookups/minors");
}
