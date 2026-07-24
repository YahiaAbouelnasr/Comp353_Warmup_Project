USE wfc353_1;

-- 1: new family member registers at the Head location
INSERT INTO FamilyMembers
(familyID, firstName, lastName, dob, ssn, medicareNo, phone, email, address, city, province, postalCode)
VALUES
(211, 'Nadia', 'Haddad', '1979-11-02', '222222211', 'NHAD881234', '514-555-0211', 'nadia.haddad@gmail.ca', '211 Oak St', 'Montreal', 'Quebec', 'H3B 2A1');

INSERT INTO RegistersAt (familyID, locationID, startDate, endDate)
VALUES (211, 1, CURDATE(), NULL);

-- 2: that family member registers her child as a new minor club member
INSERT INTO ClubMembers
(firstName, lastName, dob, height, weight, ssn, medicareNo, phone, address, city, province, postalCode)
VALUES
('Yara', 'Haddad', '2017-05-14', 128.00, 29.00, '900000023', 'YHAD190233', '514-555-0211', '211 Oak St', 'Montreal', 'Quebec', 'H3B 2A1');

SET @newMinorNo = LAST_INSERT_ID();

INSERT INTO Minors (memberNo) VALUES (@newMinorNo);

INSERT INTO FamilyOf (memberNo, familyID, relationship, startDate, endDate)
VALUES (@newMinorNo, 211, 'Mother', CURDATE(), NULL);

INSERT INTO MemberAt (memberNo, locationID, startDate, endDate)
VALUES (@newMinorNo, 1, CURDATE(), NULL);

-- 3: new major club member registers directly, no family member needed
INSERT INTO ClubMembers
(firstName, lastName, dob, height, weight, ssn, medicareNo, phone, address, city, province, postalCode)
VALUES
('Omar', 'Khalil', '1995-03-09', 178.00, 76.00, '900000024', 'OKHA773421', '514-555-0212', '212 Oak St', 'Montreal', 'Quebec', 'H3B 2A2');

SET @newMajorNo = LAST_INSERT_ID();

INSERT INTO Majors (memberNo) VALUES (@newMajorNo);

INSERT INTO MemberAt (memberNo, locationID, startDate, endDate)
VALUES (@newMajorNo, 1, CURDATE(), NULL);

-- 4: member 9 pays a second installment toward their 2025 fee
INSERT INTO Payments (memberNo, paymentDate, amount, method, memYear)
VALUES (9, CURDATE(), 50.00, 'Debit', 2025);

-- 5: member 7 moves to a different branch
UPDATE MemberAt
SET endDate = CURDATE()
WHERE memberNo = 7 AND endDate IS NULL;

INSERT INTO MemberAt (memberNo, locationID, startDate, endDate)
VALUES (7, 6, CURDATE(), NULL);

-- 6: personnel 106 finishes at Laval, starts at West Island the next day
UPDATE WorksAt
SET endDate = CURDATE()
WHERE personnelID = 106 AND locationID = 2 AND endDate IS NULL;

INSERT INTO WorksAt (personnelID, locationID, startDate, endDate)
VALUES (106, 7, DATE_ADD(CURDATE(), INTERVAL 1 DAY), NULL);

-- 7: Laval (location 2) gets a new manager since 106 has left
UPDATE Manages
SET personnelID = 102
WHERE locationID = 2;

-- 8: member 7's guardian relationship ends, a new one begins with family member 206
UPDATE FamilyOf
SET endDate = CURDATE()
WHERE memberNo = 7 AND familyID = 205 AND endDate IS NULL;

INSERT INTO FamilyOf (memberNo, familyID, relationship, startDate, endDate)
VALUES (7, 206, 'Friend', DATE_ADD(CURDATE(), INTERVAL 1 DAY), NULL);

-- 9: member 7 adds a new hobby
INSERT INTO HasHobby (memberNo, hobbyName) VALUES (7, 'Hockey');

-- 10: new FIFA game is played, member 2's participation is recorded
INSERT INTO FIFA_Games (gameID, gameDate, venue, finalScore)
VALUES (511, CURDATE(), 'Montreal Stadium', '2-2');

INSERT INTO PlaysIn (teamID, gameID) VALUES (401, 511), (402, 511);

INSERT INTO ParticipatesIn (memberNo, teamID, gameID) VALUES (2, 402, 511);
