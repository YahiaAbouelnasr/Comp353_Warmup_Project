USE wfc353_1;

-- Item 21: integrity demo. Every "EXPECTED TO FAIL" statement should error
-- out when run -- that's the point.

-- 1) ssn cannot be null
-- EXPECTED TO FAIL: Column 'ssn' cannot be null
INSERT INTO Personnel
(personnelID, firstName, lastName, dob, ssn, phone, `role`, mandate)
VALUES (901, 'No', 'Ssn', '1990-01-01', NULL, '514-555-9000', 'Other', 'Volunteer');

-- 2) no two personnel share an ssn
-- EXPECTED TO FAIL: duplicate key on ssn (101 already uses this one)
INSERT INTO Personnel
(personnelID, firstName, lastName, dob, ssn, phone, `role`, mandate)
VALUES (902, 'Dup', 'Ssn', '1990-01-01', '111111101', '514-555-9001', 'Other', 'Volunteer');

-- 3) no two personnel share a medicare number
-- EXPECTED TO FAIL: duplicate key on medicareNo (101 already uses this one)
INSERT INTO Personnel
(personnelID, firstName, lastName, dob, ssn, medicareNo, phone, `role`, mandate)
VALUES (903, 'Dup', 'Medicare', '1990-01-01', '111111199', 'KLHJS90877', '514-555-9002', 'Other', 'Volunteer');

-- 4) new club member must be >= 4 years old (trg_clubmembers_min_age)
-- EXPECTED TO FAIL: SQLSTATE 45000, age rejection
INSERT INTO ClubMembers
(firstName, lastName, dob, ssn, postalCode)
VALUES ('Too', 'Young', DATE_SUB(CURDATE(), INTERVAL 2 YEAR), '900000099', 'H0H 0H0');

-- 5) can't assign a member to two sessions <3h apart same day (trg_assignedto_conflict_ins)
INSERT INTO Sessions (sessionID, sessionDateTime, address, nature) VALUES
(651, '2026-09-01 09:00:00', 'Montreal Practice Field', 'Training'),
(652, '2026-09-01 10:00:00', 'Montreal Stadium', 'Game');
-- 1 hour apart -> conflict

INSERT INTO TeamFormations (personnelID, teamID, sessionID, score) VALUES
(115, 401, 651, NULL), (106, 402, 651, NULL),
(115, 401, 652, NULL), (106, 402, 652, NULL);

INSERT INTO AssignedTo (memberNo, teamID, sessionID, `role`) VALUES (1, 401, 651, 'Goalkeeper');

-- EXPECTED TO FAIL: SQLSTATE 45000, assignment conflict
INSERT INTO AssignedTo (memberNo, teamID, sessionID, `role`) VALUES (1, 401, 652, 'Striker');

-- cleanup
DELETE FROM AssignedTo WHERE sessionID IN (651, 652);
DELETE FROM TeamFormations WHERE sessionID IN (651, 652);
DELETE FROM Sessions WHERE sessionID IN (651, 652);

-- 6) max 4 installments per membership year (trg_payments_max_installments)
-- member 6 already has 4 for 2025, see 6_assignment_payment.sql
-- EXPECTED TO FAIL: SQLSTATE 45000, installment cap
INSERT INTO Payments (paymentID, memberNo, paymentDate, amount, method, memYear)
VALUES (938, 6, CURDATE(), 5.00, 'Cash', 2025);

-- 7) FK: can't place a member at a location that doesn't exist
-- EXPECTED TO FAIL: FK constraint (no locationID = 999)
INSERT INTO MemberAt (memberNo, locationID, startDate, endDate)
VALUES (1, 999, CURDATE(), NULL);

-- 8) FK: can't delete a location that still has dependents
-- EXPECTED TO FAIL: FK constraint (location 1 still referenced)
DELETE FROM Locations WHERE locationID = 1;
