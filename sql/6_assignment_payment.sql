USE wfc353_1;

-- Item 6: assign / delete / edit a club member to a team formation
-- includes a conflicting assignment attempt (should get rejected by trigger)

-- two sessions same day 1.5h apart (conflict), one 4h apart (no conflict)
INSERT INTO Sessions (sessionID, sessionDateTime, address, nature) VALUES
(612, '2026-08-25 10:00:00', 'Montreal Practice Field', 'Training'),
(613, '2026-08-25 11:30:00', 'Montreal Stadium', 'Game'),
(615, '2026-08-25 14:00:00', 'Verdun Stadium', 'Game');

INSERT INTO TeamFormations (personnelID, teamID, sessionID, score) VALUES
(115, 401, 612, NULL), (106, 402, 612, NULL),
(107, 403, 613, NULL), (108, 404, 613, NULL),
(109, 405, 615, NULL), (110, 406, 615, NULL);

-- assign member 10 to 10:00 AM training -- succeeds
INSERT INTO AssignedTo (memberNo, teamID, sessionID, `role`)
VALUES (10, 401, 612, 'Right Fullback');

-- assign member 10 to 11:30 AM game, same day, only 1.5h later
-- EXPECTED TO FAIL: trigger rejects (conflict within 3 hours)
INSERT INTO AssignedTo (memberNo, teamID, sessionID, `role`)
VALUES (10, 403, 613, 'Striker');

-- assign member 10 to 2:00 PM game instead, 4h after the first -- succeeds
INSERT INTO AssignedTo (memberNo, teamID, sessionID, `role`)
VALUES (10, 405, 615, 'Left Winger');

-- display
SELECT
    at.memberNo, cm.firstName, cm.lastName, t.teamName, s.sessionID, s.sessionDateTime, s.nature, at.`role`
FROM AssignedTo at
JOIN ClubMembers cm ON cm.memberNo = at.memberNo
JOIN Teams t ON t.teamID = at.teamID
JOIN Sessions s ON s.sessionID = at.sessionID
WHERE at.memberNo = 10
ORDER BY s.sessionDateTime;

-- edit
UPDATE AssignedTo
SET `role` = 'Left Fullback'
WHERE memberNo = 10 AND teamID = 401 AND sessionID = 612;

-- delete
DELETE FROM AssignedTo WHERE memberNo = 10 AND teamID = 405 AND sessionID = 615;

-- cleanup demo sessions
DELETE FROM AssignedTo WHERE sessionID IN (612, 613, 615);
DELETE FROM TeamFormations WHERE sessionID IN (612, 613, 615);
DELETE FROM Sessions WHERE sessionID IN (612, 613, 615);


-- Item 7: make a payment

-- member 6 (minor, $100/yr) already paid $100 (paymentID 506), adds 3 more installments
INSERT INTO Payments (paymentID, memberNo, paymentDate, amount, method, memYear) VALUES
(529, 6, '2025-02-01', 20.00, 'Cash', 2025),
(530, 6, '2025-03-01', 20.00, 'Cash', 2025),
(531, 6, '2025-04-01', 10.00, 'Cash', 2025);
-- total now $150, $50 over the fee -> counts as donation (see 7_queries.sql)

-- 5th installment for member 6 in 2025
-- EXPECTED TO FAIL: trigger rejects (max 4 installments/year)
INSERT INTO Payments (paymentID, memberNo, paymentDate, amount, method, memYear)
VALUES (532, 6, '2025-05-01', 5.00, 'Cash', 2025);

-- display, with running total
SELECT
    p.paymentID, p.memberNo, p.paymentDate, p.amount, p.method, p.memYear,
    SUM(p.amount) OVER (PARTITION BY p.memberNo, p.memYear) AS totalPaidThatYear
FROM Payments p
WHERE p.memberNo = 6 AND p.memYear = 2025
ORDER BY p.paymentDate;

-- edit
UPDATE Payments SET amount = 15.00, method = 'Credit' WHERE paymentID = 530;

-- delete (create one for member 8, who's nowhere near the 4-installment cap, then remove it)
INSERT INTO Payments (paymentID, memberNo, paymentDate, amount, method, memYear)
VALUES (533, 8, '2025-04-15', 999.00, 'Cash', 2025);
DELETE FROM Payments WHERE paymentID = 533;
