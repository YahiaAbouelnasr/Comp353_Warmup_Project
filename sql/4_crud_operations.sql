USE wfc353_1;

-- Item 1: Location CRUD

-- create
INSERT INTO Locations (locationID, type, name, address, city, province, postalCode, webAddress, capacity)
VALUES (11, 'Branch', 'Pointe-Claire Club', '11000 Pointe-Claire Blvd', 'Pointe-Claire', 'Quebec', 'H9R 1B1',
        'https://www.SoccerClub.com/pointe-claire', 200);

INSERT INTO LocationPhones (locationID, phone)
VALUES (11, '514-555-1100'), (11, '514-555-1101');

-- display
SELECT
    l.locationID, l.type, l.name, l.address, l.city, l.province, l.postalCode,
    l.webAddress, l.capacity,
    GROUP_CONCAT(DISTINCT lp.phone SEPARATOR ', ') AS phoneNumbers
FROM Locations l
LEFT JOIN LocationPhones lp ON lp.locationID = l.locationID
WHERE l.locationID = 11
GROUP BY l.locationID, l.type, l.name, l.address, l.city, l.province, l.postalCode, l.webAddress, l.capacity;

-- edit
UPDATE Locations
SET capacity = 230, webAddress = 'https://www.SoccerClub.com/pointe-claire-branch'
WHERE locationID = 11;

-- delete (phones first, FK)
DELETE FROM LocationPhones WHERE locationID = 11;
DELETE FROM Locations WHERE locationID = 11;


-- Item 2: Personnel CRUD

-- create
INSERT INTO Personnel
(personnelID, firstName, lastName, dob, ssn, medicareNo, phone, email, address, city, province, postalCode, `role`, title, mandate)
VALUES
(116, 'Marc', 'Dubois', '1990-02-11', '111111116', 'MDUB901145', '514-555-0116', 'marc.dubois@gmail.com',
 '116 Cedar St', 'Longueuil', 'Quebec', 'J4B 2A9', 'Coach', 'Assistant Coach', 'Volunteer');

INSERT INTO WorksAt (personnelID, locationID, startDate, endDate)
VALUES (116, 3, CURDATE(), NULL);

-- display (with current location)
SELECT
    p.personnelID, p.firstName, p.lastName, p.dob, p.ssn, p.medicareNo, p.phone, p.email,
    p.address, p.city, p.province, p.postalCode, p.`role`, p.title, p.mandate,
    l.name AS currentLocation, w.startDate AS workingSince
FROM Personnel p
JOIN WorksAt w ON w.personnelID = p.personnelID AND w.endDate IS NULL
JOIN Locations l ON l.locationID = w.locationID
WHERE p.personnelID = 116;

-- edit
UPDATE Personnel
SET phone = '514-555-9999', title = 'Assistant Coach'
WHERE personnelID = 116;

-- delete (end WorksAt first)
UPDATE WorksAt SET endDate = CURDATE() WHERE personnelID = 116 AND endDate IS NULL;
DELETE FROM WorksAt WHERE personnelID = 116;
DELETE FROM Personnel WHERE personnelID = 116;


-- Item 3: FamilyMember CRUD (Primary/Secondary)

-- create, registers at Head location
INSERT INTO FamilyMembers
(familyID, firstName, lastName, dob, ssn, medicareNo, phone, email, address, city, province, postalCode)
VALUES
(211, 'Nadia', 'Haddad', '1979-11-02', '222222211', 'NHAD881234', '514-555-0211', 'nadia.haddad@gmail.ca',
 '211 Oak St', 'Montreal', 'Quebec', 'H3B 2A1');

INSERT INTO RegistersAt (familyID, locationID, startDate, endDate)
VALUES (211, 1, CURDATE(), NULL);

-- link as Primary guardian of member 5 (demote their old primary to Secondary first)
UPDATE FamilyOf SET endDate = CURDATE()
WHERE memberNo = 5 AND familyID = 203 AND familyType = 'Primary' AND endDate IS NULL;

INSERT INTO FamilyOf (memberNo, familyID, relationship, familyType, startDate, endDate)
VALUES (5, 203, 'Friend', 'Secondary', CURDATE(), NULL);

INSERT INTO FamilyOf (memberNo, familyID, relationship, familyType, startDate, endDate)
VALUES (5, 211, 'Tutor', 'Primary', CURDATE(), NULL);

-- display, with associated club members
SELECT
    fm.familyID, fm.firstName, fm.lastName, fm.dob, fm.ssn, fm.medicareNo, fm.phone, fm.email,
    fm.address, fm.city, fm.province, fm.postalCode,
    cm.memberNo, cm.firstName AS childFirstName, cm.lastName AS childLastName,
    fo.relationship, fo.familyType
FROM FamilyMembers fm
JOIN FamilyOf fo ON fo.familyID = fm.familyID AND fo.endDate IS NULL
JOIN ClubMembers cm ON cm.memberNo = fo.memberNo
WHERE fm.familyID = 211;

-- edit
UPDATE FamilyMembers
SET phone = '514-555-0299', address = '299 Oak St', postalCode = 'H3B 2C9'
WHERE familyID = 211;

-- delete
UPDATE FamilyOf SET endDate = CURDATE() WHERE familyID = 211 AND memberNo = 5 AND endDate IS NULL;
DELETE FROM FamilyOf WHERE familyID = 211;
DELETE FROM RegistersAt WHERE familyID = 211;
DELETE FROM FamilyMembers WHERE familyID = 211;

-- restore member 5's original primary link
UPDATE FamilyOf SET endDate = NULL
WHERE memberNo = 5 AND familyID = 203 AND familyType = 'Secondary';
UPDATE FamilyOf SET familyType = 'Primary'
WHERE memberNo = 5 AND familyID = 203;


-- Item 4: ClubMember CRUD (Major/Minor)

-- create major, no family needed
INSERT INTO ClubMembers
(firstName, lastName, dob, height, weight, ssn, medicareNo, phone, email, address, city, province, postalCode)
VALUES
('Omar', 'Khalil', '1995-03-09', 178.00, 76.00, '900000024', 'OKHA773421', '514-555-0212', 'omar.khalil@gmail.com',
 '212 Oak St', 'Montreal', 'Quebec', 'H3B 2A2');

SET @newMajorNo = LAST_INSERT_ID();
INSERT INTO Majors (memberNo) VALUES (@newMajorNo);
INSERT INTO MemberAt (memberNo, locationID, startDate, endDate) VALUES (@newMajorNo, 1, CURDATE(), NULL);
INSERT INTO HasHobby (memberNo, hobbyName) VALUES (@newMajorNo, 'Soccer');

-- create minor, needs a family member (mother, family 202)
INSERT INTO ClubMembers
(firstName, lastName, dob, height, weight, ssn, medicareNo, phone, address, city, province, postalCode)
VALUES
('Yara', 'Haddad', '2017-05-14', 128.00, 29.00, '900000025', 'YHAD190233', '514-555-0211',
 '211 Oak St', 'Montreal', 'Quebec', 'H3B 2A1');

SET @newMinorNo = LAST_INSERT_ID();
INSERT INTO Minors (memberNo) VALUES (@newMinorNo);
INSERT INTO FamilyOf (memberNo, familyID, relationship, familyType, startDate, endDate)
VALUES (@newMinorNo, 202, 'Grandmother', 'Primary', CURDATE(), NULL);
INSERT INTO MemberAt (memberNo, locationID, startDate, endDate) VALUES (@newMinorNo, 1, CURDATE(), NULL);

-- display (works for both)
SELECT
    cm.memberNo, cm.firstName, cm.lastName, cm.dob, cm.height, cm.weight, cm.ssn, cm.medicareNo,
    cm.phone, cm.email, cm.address, cm.city, cm.province, cm.postalCode,
    IF(mi.memberNo IS NOT NULL, 'Minor', 'Major') AS memberType,
    l.name AS currentLocation,
    GROUP_CONCAT(DISTINCT hh.hobbyName SEPARATOR ', ') AS hobbies
FROM ClubMembers cm
LEFT JOIN Minors mi ON mi.memberNo = cm.memberNo
LEFT JOIN MemberAt ma ON ma.memberNo = cm.memberNo AND ma.endDate IS NULL
LEFT JOIN Locations l ON l.locationID = ma.locationID
LEFT JOIN HasHobby hh ON hh.memberNo = cm.memberNo
WHERE cm.memberNo IN (@newMajorNo, @newMinorNo)
GROUP BY cm.memberNo, cm.firstName, cm.lastName, cm.dob, cm.height, cm.weight, cm.ssn, cm.medicareNo,
         cm.phone, cm.email, cm.address, cm.city, cm.province, cm.postalCode, memberType, l.name;

-- edit
UPDATE ClubMembers SET height = 130.00, weight = 30.50 WHERE memberNo = @newMinorNo;

-- delete major (clear dependents first)
UPDATE MemberAt SET endDate = CURDATE() WHERE memberNo = @newMajorNo AND endDate IS NULL;
DELETE FROM HasHobby WHERE memberNo = @newMajorNo;
DELETE FROM MemberAt WHERE memberNo = @newMajorNo;
DELETE FROM Majors WHERE memberNo = @newMajorNo;
DELETE FROM ClubMembers WHERE memberNo = @newMajorNo;


-- Item 5: TeamFormation CRUD

-- create: training session, two teams
INSERT INTO Sessions (sessionID, sessionDateTime, address, nature)
VALUES (611, '2026-08-20 17:00:00', 'Montreal Practice Field', 'Training');

INSERT INTO TeamFormations (personnelID, teamID, sessionID, score)
VALUES
(115, 401, 611, NULL),  -- Lions, coach Priya Sharma
(106, 402, 611, NULL);  -- Falcons, coach Karim Nassar

-- display: coach, session, score, roster
SELECT
    t.teamName, tm.teamID, s.sessionID, s.sessionDateTime, s.address, s.nature,
    CONCAT(p.firstName, ' ', p.lastName) AS headCoach,
    tm.score,
    cm.memberNo, cm.firstName, cm.lastName, at.`role`
FROM TeamFormations tm
JOIN Teams t ON t.teamID = tm.teamID
JOIN Sessions s ON s.sessionID = tm.sessionID
JOIN Personnel p ON p.personnelID = tm.personnelID
LEFT JOIN AssignedTo at ON at.teamID = tm.teamID AND at.sessionID = tm.sessionID
LEFT JOIN ClubMembers cm ON cm.memberNo = at.memberNo
WHERE tm.sessionID = 611
ORDER BY tm.teamID, cm.memberNo;

-- edit
UPDATE Sessions SET address = 'Montreal Practice Field B' WHERE sessionID = 611;

-- delete (roster rows first, none exist here)
DELETE FROM AssignedTo WHERE sessionID = 611;
DELETE FROM TeamFormations WHERE sessionID = 611;
DELETE FROM Sessions WHERE sessionID = 611;
