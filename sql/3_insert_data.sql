USE wfc353_1;

INSERT INTO Locations
(locationID, type, name, address, city, province, postalCode, capacity)
VALUES
(1, 'Head',   'Montreal Head Club', '1000 De Maisonneuve Blvd W', 'Montreal', 'Quebec', 'H3G 1M8', 500),
(2, 'Branch', 'Laval Club','2000 Chomedey Blvd', 'Laval', 'Quebec', 'H7T 2W3', 300),
(3, 'Branch', 'Longueuil Club', '3000 Taschereau Blvd', 'Longueuil','Quebec', 'J4V 2H1', 250),
(4, 'Branch', 'Brossard Club', '4000 Rome Blvd', 'Brossard', 'Quebec', 'J4Y 0B3', 220),
(5, 'Branch', 'Verdun Club', '5000 Wellington St', 'Verdun', 'Quebec', 'H4G 1X8', 200),
(6, 'Branch', 'Saint-Laurent Club', '6000 Cote-Vertu Blvd', 'Montreal', 'Quebec', 'H4S 1Y9', 240),
(7, 'Branch', 'West Island Club', '7000 Sources Blvd', 'Dollard-des-Ormeaux', 'Quebec', 'X2K 1K8', 210),
(8, 'Branch', 'Anjou Club', '8000 Anjou Blvd', 'Montreal', 'Quebec', 'H1K 4S3', 180),
(9, 'Branch', 'Lasalle Club', '9000 Newman Blvd', 'Lasalle', 'Quebec', 'H8N 1X1', 190),
(10,'Branch', 'Rosemont Club', '10000 Rosemont Blvd', 'Montreal', 'Quebec', 'H1T 2E6', 330);

INSERT INTO LocationPhones (locationID, phone)
VALUES
(1, '514-555-1111'),
(1, '514-908-9080'),
(2, '514-190-8712'),
(3, '514-539-8357'),
(4, '514-555-1005'),
(5, '514-234-9393'),
(6, '514-343-9876'),
(7, '514-278-4100'),
(8, '514-676-6767'),
(9, '514-900-6801'),
(10,'514-900-1023');

INSERT INTO Personnel
(personnelID, firstName, lastName, dob, ssn, medicareNo, phone, email,
 address, city, province, postalCode, `role`, mandate)
VALUES
(101, 'Alex', 'Perth', '1975-04-10', '111111101', 'KLHJS90877', '514-379-0101', 'Alex.perth@gmail.com', '101 Pine St', 'Montreal', 'Quebec', 'H3A 1A1', 'Administrator', 'Salaried'),
(102, 'Sarah', 'Andrew', '1980-08-22', '111111102', 'KFDJS90877', '514-324-0102', 'Sarah.andrew@gmail.com', '102 Pine St', 'Montreal', 'Quebec', 'H3A 1A2', 'Administrator', 'Salaried'),
(103, 'Laila', 'Mahmoud', '1978-02-14', '111111103', 'KLOPK87877', '514-234-0103', 'Laila.Mohammed@gmail.com', '103 Pine St', 'Montreal', 'Quebec', 'H3A 1A3', 'Administrator', 'Salaried'),
(104, 'Geroge', 'Carey', '1982-11-05', '111111104', 'KOMNH87610', '514-224-0104', 'GeorgeCary@gmail.com', '104 Pine St', 'Montreal', 'Quebec', 'H3A 1A4', 'Administrator', 'Volunteer'),
(105, 'Josh', 'Wilson', '1985-06-18', '111111105', 'JMONU90822', '514-245-0105', 'Josh.Wilson@gmail.com', '105 Pine St', 'Montreal', 'Quebec', 'H3A 1A5', 'Administrator', 'Volunteer'),
(106, 'Karim', 'Nassar', '2006-01-09', '111111106', 'JKLMN23456', '514-578-0106', 'karim.nassar@gmail.com', '106 Maple St', 'Laval', 'Quebec', 'H7A 1B1', 'Coach', 'Salaried'),
(107, 'Sophia', 'Bernard', '2002-03-12', '111111107', 'KOLPM1234', '514-901-0107', 'Sopgia.Bernard@gmail.com', '107 Maple St', 'Longueuil','Quebec', 'J4A 1B2', 'Assistant Coach','Salaried'),
(108, 'Anthony', 'Lando', '1998-07-20', '111111108', 'KJNHU87652', '514-241-0108', 'Anthony.Lando@gmail.com', '108 Maple St', 'Brossard', 'Quebec', 'J4B 1B3', 'Captain', 'Salaried'),
(109, 'Alex', 'Roy', '2001-09-15', '111111109', 'KJUHN18923', '514-134-0109', 'Alex.roy@gmail.com', '109 Maple St',  'Verdun', 'Quebec', 'H4G 1B4', 'Coach', 'Salaried'),
(110, 'Ahmed', 'Saleh', '1983-12-02', '111111110', 'IJGHN88776', '514-903-0110', 'Ahmed.Saleh@gmail.com', '110 Maple St', 'Montreal', 'Quebec', 'H4S 1B5', 'Other', 'Volunteer'),
(111, 'Abdallah', 'Moshref', '1991-05-24', '111111111', 'JKOOO99000', '514-032-0111', 'AbdallahMoshref@gmail.com', '111 Cedar St', 'Dollard-des-Ormeaux', 'Quebec', 'H9B 1C1', 'Coach', 'Salaried'),
(112, 'Franklin', 'Saint', '1988-10-30', '111111112', 'KOPOH89994', '514-261-0112', 'FranklinSaint@gmail.com', '112 Cedar St', 'Montreal', 'Quebec', 'H1K 1C2', 'Assistant Coach','Volunteer'),
(113, 'Rachel', 'King', '1992-04-08', '111111113', 'KLOPP2019', '514-001-0113', 'RachelKing@gmail.com', '113 Cedar St', 'Lasalle', 'Quebec', 'H8N 1C3', 'Captain', 'Salaried'),
(114, 'Jack', 'Joseph', '1984-08-17', '111111114', 'BHVUI91135', '514-389-0114', 'JackJoseph@gmail.com', '114 Cedar St', 'Montreal', 'Quebec', 'H1T 1C4', 'Other', 'Salaried');

INSERT INTO FamilyMembers
(familyID, firstName, lastName, dob, ssn, medicareNo, phone, email,
 address, city, province, postalCode)
VALUES
(201, 'John', 'Carter', '1985-05-05', '222222201', 'SHJDB77898', '514-555-0201', 'john.carter@gmail.ca', '201 Oak St', 'Montreal', 'Quebec', 'H3B 2A1'),
(202, 'Sara', 'Ahmed', '1988-09-14', '222222202', 'SJNDB98000', '514-555-0202', 'sara.ahmed@gmail.ca', '202 Oak St', 'Laval', 'Quebec', 'H7B 2A2'),
(203, 'Michael', 'Brown', '1981-01-22', '222222203', 'SJFBS77762', '514-555-0203', 'michael.brown@gmail.ca', '203 Oak St', 'Longueuil','Quebec', 'J4B 2A3'),
(204, 'Linda', 'Wilson', '1983-06-16', '222222204', 'SDJHB87654', '514-555-0204', 'linda.wilson@gmail.ca', '204 Oak St', 'Brossard', 'Quebec', 'J4C 2A4'),
(205, 'Robert', 'Martin', '1979-02-28', '222222205', 'JSBDH99999', '514-555-0205', 'robert.martin@gmail.ca', '205 Oak St', 'Verdun', 'Quebec', 'H4G 2A5'),
(206, 'Emily', 'Lee', '1986-12-09', '222222206', 'SJDKF81776', '514-555-0206', 'emily.lee@gmail.ca', '206 Oak St', 'Montreal', 'Quebec', 'H4S 2A6'),
(207, 'Daniel', 'Roy', '1980-07-19', '222222207', 'SKJDB82176', '514-555-0207', 'daniel.roy@gmail.ca', '207 Oak St', 'Dollard-des-Ormeaux', 'Quebec', 'H9B 2A7'),
(208, 'Karen', 'King', '1984-04-11', '222222208', 'WDKJN82631', '514-555-0208', 'karen.king@gmail.ca', '208 Oak St', 'Montreal', 'Quebec', 'H1K 2A8'),
(209, 'Steven', 'Moore', '1982-10-25', '222222209', 'QWLKD87621', '514-555-0209', 'steven.moore@gmail.ca', '209 Oak St', 'Lasalle',  'Quebec', 'H8N 2A9'),
(210, 'Amina', 'Patel', '1987-03-03', '222222210', 'AEDJH81271', '514-555-0210', 'amina.patel@gmail.ca', '210 Oak St', 'Montreal', 'Quebec', 'H1T 2B1');

INSERT INTO ClubMembers
(memberNo, firstName, lastName, dob, height, weight, ssn, medicareNo,
 phone, address, city, province, postalCode)
VALUES
(1,  'Noah', 'Carter', '2014-03-12', 145.00, 40.00, '900000001', 'SDFHD83844', '514-555-0201', '201 Oak St', 'Montreal', 'Quebec', 'H3B 2A1'),
(2,  'Lina', 'Ahmed', '2012-07-08', 155.00, 48.00, '900000002', 'SDFSD34332', '514-555-0202', '202 Oak St', 'Laval', 'Quebec', 'H7B 2A2'),
(3,  'Emma', 'Carter', '2015-09-20', 138.00, 35.00, '900000003', 'JWDFS34222', '514-555-0201', '201 Oak St', 'Montreal', 'Quebec', 'H3B 2A1'),
(4,  'Adam', 'Ahmed', '2010-11-30', 165.00, 55.00, '900000004', 'FSADD73626', '514-555-0202', '202 Oak St', 'Laval', 'Quebec', 'H7B 2A2'),
(5,  'Lucas', 'Brown', '2016-02-15', 135.00, 33.00, '900000005', 'ASDFJ24321', '514-555-0203', '203 Oak St', 'Longueuil','Quebec', 'J4B 2A3'),
(6,  'Mia', 'Wilson', '2013-06-25', 150.00, 44.00, '900000006', 'DSFIJQ90822', '514-555-0204', '204 Oak St', 'Brossard', 'Quebec', 'J4C 2A4'),
(7,  'Ethan', 'Martin', '2011-04-10', 160.00, 52.00, '900000007', 'SDFIH19230', '514-555-0205', '205 Oak St', 'Verdun', 'Quebec', 'H4G 2A5'),
(8,  'Zoe', 'Lee', '2017-08-18', 130.00, 30.00, '900000008', 'ASDAR23121', '514-555-0206', '206 Oak St', 'Montreal', 'Quebec', 'H4S 2A6'),
(9,  'Liam', 'Roy', '2009-12-05', 172.00, 60.00, '900000009', 'BISMA12311', '514-555-0207', '207 Oak St', 'Dollard-des-Ormeaux', 'Quebec', 'H9B 2A7'),
(10, 'Ava', 'King', '2018-01-22', 125.00, 28.00, '900000010', 'AKJDS90133', '514-555-0208', '208 Oak St', 'Montreal', 'Quebec', 'H1K 2A8'),
(11, 'Steph', 'Moore', '2009-01-23', 190.00, 78.00, '900000011', 'SDAFA72834', '514-555-0209', '209 Oak St', 'Lasalle',  'Quebec', 'H8N 2A9'),
(12, 'Karl', 'Patel', '2022-01-29', 130.00, 35.00, '900000012', 'KAHRU81923', '514-555-0210','210 Oak St', 'Montreal', 'Quebec', 'H1T 2B1'),
(13, 'Frash', 'Jako', '2008-07-21', 180.00, 82.00, '900000013', 'SDIHFU21313', '514-555-0311', '311 Elm St', 'Montreal', 'Quebec', 'H3C 3B2'),
(14, 'Sara', 'Ahmed', '1988-09-14', 169.00, 52.00, '222222202', 'SJNDB98000', '514-555-0202', '202 Oak St', 'Laval', 'Quebec', 'H7B 2A2'),
(15, 'Steven', 'Moore', '1982-10-25', 193.00, 83.00, '222222209', 'QWLKD87621', '514-555-0209', '209 Oak St', 'Lasalle',  'Quebec', 'H8N 2A9'),
(16, 'Chloe', 'Davis', '2000-03-27', 165.00, 58.00, '900000016', 'DFIUHU82741', '514-555-0314', '314 Elm St', 'Brossard', 'Quebec', 'J4D 3B5'),
(17, 'Ryan', 'Clark', '1998-12-19', 182.00, 85.00, '900000017', 'FAHLO1839', '514-555-0315', '315 Elm St', 'Verdun', 'Quebec', 'H4G 3B6'),
(18, 'Julia', 'Adams', '2004-06-02', 170.00, 64.00, '900000018', 'SDFHI90383', '514-555-0316', '316 Elm St', 'Montreal', 'Quebec', 'H4S 3B7'),
(19, 'Marc', 'Tremblay', '1990-07-21', 176.00, 74.00, '900000019', 'FWRUH81271', '514-555-0317', '317 Elm St', 'Dollard-des-Ormeaux', 'Quebec', 'H9B 3B8'),
(20, 'Sophie', 'Gagnon', '2003-10-09', 167.00, 60.00, '900000020', 'AHFUY81237', '514-555-0318', '318 Elm St', 'Montreal', 'Quebec', 'H1K 3B9'),
(21, 'Alex', 'Nguyen','1997-04-16', 181.00, 80.00, '900000021', 'ASIFH12398', '514-555-0319', '319 Elm St', 'Lasalle', 'Quebec', 'H8N 3C1'),
(22, 'Amina', 'Patel', '1987-03-03', 171.00, 68.00, '222222210', 'AEDJH81271', '514-555-0210', '210 Oak St', 'Montreal', 'Quebec', 'H1T 2B1');

INSERT INTO Hobbies (hobbyName)
VALUES
('Soccer'),('Swimming'),('Tennis'),('Golf'),('Volleyball'),
('Hockey'),('Ping Pong'),('Running'),('Cycling'),('Basketball');

INSERT INTO Teams (teamID, teamName, gender)
VALUES
(401, 'Montreal Lions', 'Boys'),
(402, 'Laval Falcons', 'Boys'),
(403, 'Longueuil United', 'Boys'),
(404, 'Brossard Stars', 'Boys'),
(405, 'Verdun Eagles', 'Boys'),
(406, 'Saint-Laurent FC', 'Boys'),
(407, 'West Island Wolves', 'Girls'),
(408, 'Anjou Tigers', 'Girls'),
(409, 'Lasalle Warriors', 'Girls'),
(410, 'Rosemont Royals',  'Girls');

INSERT INTO FIFA_Games (gameID, gameDate, venue, finalScore)
VALUES
(501, '2025-05-01', 'Montreal Stadium','2-1'),
(502, '2025-05-08', 'Laval Stadium','1-1'),
(503, '2025-05-15', 'Longueuil Stadium', '3-0'),
(504, '2025-05-22', 'Brossard Stadium','0-2'),
(505, '2025-06-01', 'Verdun Stadium','2-2'),
(506, '2025-06-08', 'Saint-Laurent Park','1-0'),
(507, '2025-06-15', 'West Island Park', '2-3'),
(508, '2025-06-22', 'Anjou Stadium', '4-1'),
(509, '2025-07-01', 'Lasalle Stadium', '0-0'),
(510, '2025-07-08', 'Rosemont Stadium', '3-2');

INSERT INTO Minors (memberNo)
VALUES (1), (2), (3), (4), (5), (6), (7), (8), (9), (10), (11), (12);

INSERT INTO Majors (memberNo)
VALUES (13), (14), (15), (16), (17), (18), (19), (20), (21), (22);

INSERT INTO Payments (memberNo, paymentDate, amount, method, memYear)
VALUES
(1,'2025-01-05', 100.00, 'Credit', 2025),
(2,'2025-01-06', 100.00, 'Debit', 2025),
(3,'2025-01-07', 120.00, 'Cash', 2025),
(4,'2025-01-08', 100.00, 'Debit', 2025),
(5,'2025-01-09', 100.00, 'Credit', 2025),
(6,'2025-01-10', 100.00, 'Cash', 2025),
(7, '2025-01-11', 150.00, 'Debit', 2025),
(8, '2025-01-12', 100.00, 'Credit', 2025),
(9, '2025-01-13', 100.00, 'Cash', 2025),
(10,'2025-01-14', 100.00, 'Debit', 2025),
(11,'2023-01-15', 220.00, 'Credit', 2023),
(11, '2024-01-15', 250.00, 'Credit', 2024),
(11, '2025-01-15', 250.00, 'Credit', 2025),
(12, '2023-01-16', 200.00, 'Debit', 2023),
(12, '2024-01-16', 230.00, 'Debit', 2024),
(12, '2025-01-16', 220.00, 'Debit', 2025),
(13, '2023-01-17', 100.00, 'Cash', 2023),
(13, '2024-01-17', 150.00, 'Cash', 2024),
(13, '2025-01-17', 200.00, 'Cash',2025),
(14, '2025-01-18', 200.00, 'Credit', 2025),
(15, '2025-01-19', 200.00, 'Debit', 2025),
(16, '2025-01-20', 200.00, 'Cash', 2025),
(17, '2025-01-21', 200.00, 'Credit', 2025),
(18, '2025-01-22', 250.00, 'Debit', 2025),
(19, '2025-01-23', 200.00, 'Cash', 2025),
(20, '2025-01-24', 225.00, 'Credit', 2025),
(21,'2025-01-19', 90.00, 'Cash', 2025),
(22, '2025-01-01', 180.00, 'Credit', 2025);


INSERT INTO WorksAt (personnelID, locationID, startDate, endDate)
VALUES
(101,1,'2020-01-01',NULL),
(102,1,'2021-02-01',NULL),
(103,1,'2021-03-01',NULL),
(104,1,'2022-04-01',NULL),
(105,1,'2022-05-01',NULL),
(106,2,'2020-06-01',NULL),
(107,3,'2020-07-01',NULL),
(108,4,'2020-08-01',NULL),
(109,5,'2020-09-01',NULL),
(110,6,'2020-10-01',NULL),
(111,7,'2020-11-01',NULL),
(112,8,'2020-12-01',NULL),
(113,9,'2021-01-01',NULL),
(114,10,'2021-02-01',NULL);

INSERT INTO Manages (personnelID, locationID)
VALUES
(101,1),(106,2),(107,3),(108,4),(109,5),(110,6),(111,7),(112,8),(113,9),(114,10);

INSERT INTO RegistersAt (familyID, locationID, startDate, endDate)
VALUES
(201,1,'2024-01-01',NULL),
(202,2,'2024-01-02',NULL),
(203,3,'2024-01-03',NULL),
(204,4,'2024-01-04',NULL),
(205,5,'2024-01-05',NULL),
(206,6,'2024-01-06',NULL),
(207,7,'2024-01-07',NULL),
(208,8,'2024-01-08',NULL),
(209,9,'2024-01-09',NULL),
(210,10,'2024-01-10',NULL);

INSERT INTO MemberAt (memberNo, locationID, startDate, endDate)
VALUES
(1,1,'2024-01-01',NULL),
(2,2,'2024-01-02',NULL),
(3,1,'2024-01-03',NULL),
(4,2,'2024-01-04',NULL),
(5,3,'2024-01-05',NULL),
(6,4,'2024-01-06',NULL),
(7,5,'2024-01-07',NULL),
(8,6,'2024-01-08',NULL),
(9,7,'2024-01-09',NULL),
(10,8,'2024-01-10',NULL),
(11,8,'2024-01-22',NULL),
(12,4,'2024-01-23',NULL),
(13,1,'2023-01-01',NULL),
(14,2,'2023-01-02',NULL),
(15,3,'2023-01-03',NULL),
(16,4,'2023-01-04',NULL),
(17,5,'2023-01-05',NULL),
(18,6,'2023-01-06',NULL),
(19,7,'2023-01-07',NULL),
(20,8,'2023-01-08',NULL),
(21,9,'2023-01-09',NULL),
(22,10,'2023-01-10',NULL);

INSERT INTO FamilyOf
(memberNo, familyID, relationship, startDate, endDate)
VALUES
(1,201,'Father','2024-01-01',NULL),
(3,201,'Father','2024-01-03',NULL),
(2,202,'Mother','2024-01-02',NULL),
(4,202,'Mother','2024-01-04',NULL),
(5,203,'Father','2024-01-05',NULL),
(6,204,'Mother','2024-01-06',NULL),
(7,205,'Tutor','2024-01-07',NULL),
(8,206,'Mother','2024-01-08',NULL),
(9,207,'Father','2024-01-09',NULL),
(10,208,'Mother','2024-01-10',NULL),
(11, 209, 'Father', '2024-05-12', NULL),
(12, 210, 'Father', '2024-01-01', NULL);

INSERT INTO HasHobby (memberNo, hobbyName)
VALUES
(1,'Soccer'),(1,'Swimming'),(1,'Tennis'),(1,'Golf'),
(2,'Soccer'),(2,'Volleyball'),
(3,'Swimming'),
(4,'Soccer'),(4,'Hockey'),(4,'Running'),
(5,'Soccer'),(5,'Cycling'),
(6,'Swimming'),(6,'Basketball'),
(7,'Tennis'),
(8,'Golf'),
(9,'Soccer'),(9,'Running'),
(10,'Swimming'), (10, 'Running'),
(11,'Soccer'),(11,'Swimming'),(11,'Tennis'),(11,'Golf'),
(12,'Soccer'),(12,'Running'),
(13,'Cycling'),(13,'Basketball'),
(14,'Swimming'),
(15,'Soccer'),(15,'Tennis'),(15,'Running'), (15, 'Swimming'),
(16,'Golf'),
(17,'Soccer'),(17,'Cycling'),
(18,'Swimming'),(18,'Volleyball'),
(19,'Soccer'),(19,'Hockey'),(19,'Basketball'),
(20,'Tennis'),(20,'Running'),
(21,'Golf'), (21, 'Swimming'),
(22,'Soccer'), (22,'Swimming');

INSERT INTO BelongsTo (teamID, locationID)
VALUES
(401,1),(402,2),(403,3),(404,4),(405,5),
(406,6),(407,7),(408,8),(409,9),(410,10);

INSERT INTO PlaysIn (teamID, gameID)
VALUES
(401,501),(402,501),(403,502),(404,502),(405,503),
(406,503),(407,504),(408,504),(409,505),(410,505),
(401,506),(403,506),(402,507),(404,507),(405,508),
(407,508),(406,509),(408,509),(409,510),(401,510);

INSERT INTO ParticipatesIn (memberNo, teamID, gameID)
VALUES
(1,402,501),(2,404,502),(3,406,503),(4,408,504),
(5,410,505),(6,407,508),(7,406,509),(8,404,502),
(9,410,505),(10,410,505),(11,401,501),(11,401,506),
(12,402,507),(13,406,509),(14,401,510),(15,403,502),
(16,403,506),(17,404,507),(18,405,508),(19,405,503),
(20,407,504),(1,403,502),(1,404,507),(1,406,509),
(18,401,510),(18,404,507),(18,403,502);