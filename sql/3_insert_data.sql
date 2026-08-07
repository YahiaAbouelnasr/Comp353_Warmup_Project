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
 address, city, province, postalCode, `role`, title, mandate)
VALUES
(101, 'Alex', 'Perth', '1975-04-10', '111111101', 'KLHJS90877', '514-379-0101', 'Alex.perth@gmail.com', '101 Pine St', 'Montreal', 'Quebec', 'H3A 1A1', 'Administrator', 'President', 'Salaried'),
(102, 'Sarah', 'Andrew', '1980-08-22', '111111102', 'KFDJS90877', '514-324-0102', 'Sarah.andrew@gmail.com', '102 Pine St', 'Montreal', 'Quebec', 'H3A 1A2', 'Administrator', 'Deputy Manager', 'Salaried'),
(103, 'Laila', 'Mahmoud', '1978-02-14', '111111103', 'KLOPK87877', '514-234-0103', 'Laila.Mohammed@gmail.com', '103 Pine St', 'Montreal', 'Quebec', 'H3A 1A3', 'Administrator', 'Treasurer', 'Salaried'),
(104, 'Geroge', 'Carey', '1982-11-05', '111111104', 'KOMNH87610', '514-224-0104', 'GeorgeCary@gmail.com', '104 Pine St', 'Montreal', 'Quebec', 'H3A 1A4', 'Administrator', 'Secretary', 'Volunteer'),
(105, 'Josh', 'Wilson', '1985-06-18', '111111105', 'JMONU90822', '514-245-0105', 'Josh.Wilson@gmail.com', '105 Pine St', 'Montreal', 'Quebec', 'H3A 1A5', 'Administrator', 'Administrator', 'Volunteer'),
(106, 'Karim', 'Nassar', '2006-01-09', '111111106', 'JKLMN23456', '514-578-0106', 'karim.nassar@gmail.com', '106 Maple St', 'Laval', 'Quebec', 'H7A 1B1', 'Coach', 'Branch Manager', 'Salaried'),
(107, 'Sophia', 'Bernard', '2002-03-12', '111111107', 'KOLPM1234', '514-901-0107', 'Sopgia.Bernard@gmail.com', '107 Maple St', 'Longueuil','Quebec', 'J4A 1B2', 'Assistant Coach', 'Branch Manager', 'Salaried'),
(108, 'Anthony', 'Lando', '1998-07-20', '111111108', 'KJNHU87652', '514-241-0108', 'Anthony.Lando@gmail.com', '108 Maple St', 'Brossard', 'Quebec', 'J4B 1B3', 'Captain', 'Branch Manager', 'Salaried'),
(109, 'Alex', 'Roy', '2001-09-15', '111111109', 'KJUHN18923', '514-134-0109', 'Alex.roy@gmail.com', '109 Maple St',  'Verdun', 'Quebec', 'H4G 1B4', 'Coach', 'Branch Manager', 'Salaried'),
(110, 'Ahmed', 'Saleh', '1983-12-02', '111111110', 'IJGHN88776', '514-903-0110', 'Ahmed.Saleh@gmail.com', '110 Maple St', 'Montreal', 'Quebec', 'H4S 1B5', 'Other', 'Branch Manager', 'Volunteer'),
(111, 'Abdallah', 'Moshref', '1991-05-24', '111111111', 'JKOOO99000', '514-032-0111', 'AbdallahMoshref@gmail.com', '111 Cedar St', 'Dollard-des-Ormeaux', 'Quebec', 'H9B 1C1', 'Coach', 'Branch Manager', 'Salaried'),
(112, 'Franklin', 'Saint', '1988-10-30', '111111112', 'KOPOH89994', '514-261-0112', 'FranklinSaint@gmail.com', '112 Cedar St', 'Montreal', 'Quebec', 'H1K 1C2', 'Assistant Coach', 'Branch Manager', 'Volunteer'),
(113, 'Rachel', 'King', '1992-04-08', '111111113', 'KLOPP2019', '514-001-0113', 'RachelKing@gmail.com', '113 Cedar St', 'Lasalle', 'Quebec', 'H8N 1C3', 'Captain','Branch Manager',  'Salaried'),
(114, 'Jack', 'Joseph', '1984-08-17', '111111114', 'BHVUI91135', '514-389-0114', 'JackJoseph@gmail.com', '114 Cedar St', 'Montreal', 'Quebec', 'H1T 1C4', 'Other','Branch Manager',  'Salaried'),
(115, 'Priya', 'Sharma', '1994-05-19', '111111115', 'MDCOA11501', '514-555-0115', 'priya.sharma@gmail.com', '115 Pine St', 'Montreal', 'Quebec', 'H3A 1A6','Coach', 'Branch Manager', 'Salaried');

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
 phone, email, address, city, province, postalCode)
VALUES
(1,  'Noah', 'Carter', '2014-03-12', 145.00, 40.00, '900000001', 'SDFHD83844', '514-555-0201', 'NoahCarter@gmail.com', '201 Oak St', 'Montreal', 'Quebec', 'H3B 2A1'),
(2,  'Lina', 'Ahmed', '2012-07-08', 155.00, 48.00, '900000002', 'SDFSD34332', '514-555-0202', 'LinaAhmed@gmail.com', '202 Oak St', 'Laval', 'Quebec', 'H7B 2A2'),
(3,  'Emma', 'Carter', '2015-09-20', 138.00, 35.00, '900000003', 'JWDFS34222', '514-555-0201', 'EmmaCarter@gmail.com', '201 Oak St', 'Montreal', 'Quebec', 'H3B 2A1'),
(4,  'Adam', 'Ahmed', '2010-11-30', 165.00, 55.00, '900000004', 'FSADD73626', '514-555-0202', 'AdamAhmed@gmail.com', '202 Oak St', 'Laval', 'Quebec', 'H7B 2A2'),
(5,  'Lucas', 'Brown', '2016-02-15', 135.00, 33.00, '900000005', 'ASDFJ24321', '514-555-0203', 'LucasBrown@gmail.com', '203 Oak St', 'Longueuil','Quebec', 'J4B 2A3'),
(6,  'Mia', 'Wilson', '2013-06-25', 150.00, 44.00, '900000006', 'DSFIJQ90822', '514-555-0204', 'MiaWilson@gmail.com',  '204 Oak St', 'Brossard', 'Quebec', 'J4C 2A4'),
(7,  'Ethan', 'Martin', '2011-04-10', 160.00, 52.00, '900000007', 'SDFIH19230', '514-555-0205', 'EthanMartin@gmail.com',  '205 Oak St', 'Verdun', 'Quebec', 'H4G 2A5'),
(8,  'Zoe', 'Lee', '2017-08-18', 130.00, 30.00, '900000008', 'ASDAR23121', '514-555-0206', 'ZoeLee@gmail.com',  '206 Oak St', 'Montreal', 'Quebec', 'H4S 2A6'),
(9,  'Liam', 'Roy', '2009-12-05', 172.00, 60.00, '900000009', 'BISMA12311', '514-555-0207', 'LiamRoy@gmail.com', '207 Oak St', 'Dollard-des-Ormeaux', 'Quebec', 'H9B 2A7'),
(10, 'Ava', 'King', '2018-01-22', 125.00, 28.00, '900000010', 'AKJDS90133', '514-555-0208', 'AvaKing@gmail.com', '208 Oak St', 'Montreal', 'Quebec', 'H1K 2A8'),
(11, 'Steph', 'Moore', '2009-01-23', 190.00, 78.00, '900000011', 'SDAFA72834', '514-555-0209', 'StephMoore@gmail.com', '209 Oak St', 'Lasalle',  'Quebec', 'H8N 2A9'),
(12, 'Karl', 'Patel', '2022-01-29', 130.00, 35.00, '900000012', 'KAHRU81923', '514-555-0210',' LarlPatel@gmail.com', '210 Oak St', 'Montreal', 'Quebec', 'H1T 2B1'),
(13, 'Frash', 'Jako', '2008-07-21', 180.00, 82.00, '900000013', 'SDIHFU21313', '514-555-0311', 'FrashJako@gmail.com', '311 Elm St', 'Montreal', 'Quebec', 'H3C 3B2'),
(14, 'Sara', 'Ahmed', '1988-09-14', 169.00, 52.00, '222222202', 'SJNDB98000', '514-555-0202', 'SaraAhmed@gmail.com', '202 Oak St', 'Laval', 'Quebec', 'H7B 2A2'),
(15, 'Steven', 'Moore', '1982-10-25', 193.00, 83.00, '222222209', 'QWLKD87621', '514-555-0209', 'StevenMoore@gmail.com', '209 Oak St', 'Lasalle',  'Quebec', 'H8N 2A9'),
(16, 'Chloe', 'Davis', '2000-03-27', 165.00, 58.00, '900000016', 'DFIUHU82741', '514-555-0314', 'ChloeDavis@gmail.com', '314 Elm St', 'Brossard', 'Quebec', 'J4D 3B5'),
(17, 'Ryan', 'Clark', '1998-12-19', 182.00, 85.00, '900000017', 'FAHLO1839', '514-555-0315', 'RyanClark@gmail.com', '315 Elm St', 'Verdun', 'Quebec', 'H4G 3B6'),
(18, 'Julia', 'Adams', '2004-06-02', 170.00, 64.00, '900000018', 'SDFHI90383', '514-555-0316', 'JulieAdams@gmail.com',  '316 Elm St', 'Montreal', 'Quebec', 'H4S 3B7'),
(19, 'Marc', 'Tremblay', '1990-07-21', 176.00, 74.00, '900000019', 'FWRUH81271', '514-555-0317', 'MarkTremblay@gmail.com', '317 Elm St', 'Dollard-des-Ormeaux', 'Quebec', 'H9B 3B8'),
(20, 'Sophie', 'Gagnon', '2003-10-09', 167.00, 60.00, '900000020', 'AHFUY81237', '514-555-0318', 'SophieGagnon@gmail.com', '318 Elm St', 'Montreal', 'Quebec', 'H1K 3B9'),
(21, 'Alex', 'Nguyen','1997-04-16', 181.00, 80.00, '900000021', 'ASIFH12398', '514-555-0319', 'AlexNguyen@gmail.com', '319 Elm St', 'Lasalle', 'Quebec', 'H8N 3C1'),
(22, 'Amina', 'Patel', '1987-03-03', 171.00, 68.00, '222222210', 'AEDJH81271', '514-555-0210', 'AminaPatel@gmail.com', '210 Oak St', 'Montreal', 'Quebec', 'H1T 2B1');

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

INSERT INTO Sessions (sessionID, sessionDateTime, address, nature)
VALUES
(601, '2025-05-01 15:00:00', 'Montreal Stadium', 'Game'),
(602, '2025-05-08 15:00:00', 'Laval Stadium', 'Game'),
(603, '2025-05-15 15:00:00', 'Longueuil Stadium', 'Game'),
(604, '2025-05-22 15:00:00', 'Brossard Stadium', 'Game'),
(605, '2025-06-01 15:00:00', 'Verdun Stadium', 'Game'),
(606, '2025-06-08 15:00:00', 'Saint-Laurent Park', 'Game'),
(607, '2025-04-20 10:00:00', 'Montreal Practice Field', 'Training'),
(608, '2025-04-27 10:00:00', 'Laval Practice Field', 'Training'),
(609, '2025-07-15 10:00:00', 'Longueuil Practice Field', 'Training'),
(610, '2025-07-22 10:00:00', 'West Island Practice Field', 'Training');


INSERT INTO Minors (memberNo)
VALUES (1), (2), (3), (4), (5), (6), (7), (8), (9), (10), (11), (12);

INSERT INTO Majors (memberNo)
VALUES (13), (14), (15), (16), (17), (18), (19), (20), (21), (22);

INSERT INTO Payments (paymentID, memberNo, paymentDate, amount, method, memYear)
VALUES
(501, 1,'2025-01-05', 100.00, 'Credit', 2025),
(502, 2,'2025-01-06', 100.00, 'Debit', 2025),
(503, 3,'2025-01-07', 120.00, 'Cash', 2025),
(504, 4,'2025-01-08', 100.00, 'Debit', 2025),
(505, 5,'2025-01-09', 100.00, 'Credit', 2025),
(506, 6,'2025-01-10', 100.00, 'Cash', 2025),
(507, 7, '2025-01-11', 150.00, 'Debit', 2025),
(508, 8, '2025-01-12', 100.00, 'Credit', 2025),
(509, 9, '2025-01-13', 100.00, 'Cash', 2025),
(510, 10,'2025-01-14', 100.00, 'Debit', 2025),
(511, 11,'2023-01-15', 220.00, 'Credit', 2023),
(512, 11, '2024-01-15', 250.00, 'Credit', 2024),
(513, 11, '2025-01-15', 250.00, 'Credit', 2025),
(514, 12, '2023-01-16', 200.00, 'Debit', 2023),
(515, 12, '2024-01-16', 230.00, 'Debit', 2024),
(516, 12, '2025-01-16', 220.00, 'Debit', 2025),
(517, 13, '2023-01-17', 100.00, 'Cash', 2023),
(518, 13, '2024-01-17', 150.00, 'Cash', 2024),
(519, 13, '2025-01-17', 200.00, 'Cash',2025),
(520, 14, '2025-01-18', 200.00, 'Credit', 2025),
(521, 15, '2025-01-19', 200.00, 'Debit', 2025),
(522, 16, '2025-01-20', 200.00, 'Cash', 2025),
(523, 17, '2025-01-21', 200.00, 'Credit', 2025),
(524, 18, '2025-01-22', 250.00, 'Debit', 2025),
(525, 19, '2025-01-23', 200.00, 'Cash', 2025),
(526, 20, '2025-01-24', 225.00, 'Credit', 2025),
(527, 21,'2025-01-19', 90.00, 'Cash', 2025),
(528, 22, '2025-01-01', 180.00, 'Credit', 2025);

INSERT INTO TeamFormations (personnelID, teamID, sessionID, score)
VALUES
(115, 401, 601, 2),
(106, 402, 601, 1),
(107, 403, 602, 1),
(108, 404, 602, 1),
(109, 405, 603, 3),
(110, 406, 603, 0),
(111, 407, 604, 0),
(112, 408, 604, 2),
(113, 409, 605, 2),
(114, 410, 605, 2),
(115, 401, 606, 1),
(107, 403, 606, 0),
(115, 401, 607, NULL),
(110, 406, 607, NULL),
(106, 402, 608, NULL),
(108, 404, 608, NULL),
(107, 403, 609, NULL),
(109, 405, 609, NULL),
(111, 407, 610, NULL),
(113, 409, 610, NULL);

INSERT INTO EmailLog (emailID, emailDate, sender, receiver, subject, bodyPreview)
VALUES
(1, '2025-04-13 08:00:00', 1, 1, 'Montreal Lions Sunday 20-Apr-2025 10:00 AM training session', 'Dear Noah, you are scheduled as Goalkeeper for training on Apr 20 at Montreal Practice Field'),
(2, '2025-04-13 08:00:00', 1, 3, 'Montreal Lions Sunday 20-Apr-2025 10:00 AM training session', 'Dear Emma, you are scheduled as Center Back for training on Apr 20 at Montreal Practice Field'),
(3, '2025-04-27 08:00:00', 1, 1, 'Montreal Lions Sunday 01-May-2025 3:00 PM game session', 'Dear Noah, you are scheduled as Goalkeeper for the game on May 1 at Montreal Stadium'),
(4, '2025-04-27 08:00:00', 2, 2, 'Laval Falcons Sunday 01-May-2025 3:00 PM game session', 'Dear Lina, you are scheduled as Goalkeeper for the game on May 1 at Montreal Stadium'),
(5, '2025-05-04 08:00:00', 4, 6, 'Brossard Stars Sunday 08-May-2025 3:00 PM game session', 'Dear Mia, you are scheduled as Goalkeeper for the game on May 8 at Laval Stadium'),
(6, '2025-05-11 08:00:00', 5, 7, 'Verdun Eagles Sunday 15-May-2025 3:00 PM game session', 'Dear Ethan, you are scheduled as Goalkeeper for the game on May 15 at Longueuil Stadium'),
(7, '2025-05-18 08:00:00', 7, 9, 'West Island Wolves Sunday 22-May-2025 3:00 PM game session', 'Dear Liam, you are scheduled as Goalkeeper for the game on May 22 at Brossard Stadium'),
(8, '2025-05-25 08:00:00', 9, 21, 'Lasalle Warriors Sunday 01-Jun-2025 3:00 PM game session', 'Dear Alex, you are scheduled as Goalkeeper for the game on Jun 1 at Verdun Stadium');


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
(114,10,'2021-02-01',NULL),
(115, 1, '2023-01-01', NULL);

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
(memberNo, familyID, relationship, familyType, startDate, endDate)
VALUES
(1,201,'Father','Primary', '2024-01-01',NULL),
(2,202,'Mother','Primary', '2024-01-02',NULL),
(3,201,'Father','Primary', '2024-01-03',NULL),
(4,202,'Mother','Primary', '2024-01-04',NULL),
(5,203,'Friend','Primary', '2024-01-05',NULL),
(6,204,'Mother','Primary', '2024-01-06',NULL),
(7,205,'Tutor','Primary', '2024-01-07',NULL),
(8,206,'Mother','Primary', '2024-01-08',NULL),
(9,207,'Grandfather','Primary', '2024-01-09',NULL),
(10,208,'Mother','Primary', '2024-01-10',NULL),
(11, 209, 'Partner','Primary', '2024-05-12', NULL),
(12, 210, 'Other','Primary', '2024-01-01', NULL),
(1, 202, 'Mother', 'Secondary', '2024-06-01', NULL),
(3, 202, 'Mother', 'Secondary', '2024-06-01', NULL),
(4, 201, 'Father', 'Secondary', '2024-06-01', NULL),
(6, 205, 'Tutor',  'Secondary', '2024-06-05', NULL),
(9, 208, 'Mother', 'Secondary', '2024-06-09', NULL);

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

INSERT INTO AssignedTo (memberNo, teamID, sessionID, `role`)
VALUES
(1, 401, 601, 'Goalkeeper'), (3, 401, 601, 'Striker'), (13, 401, 601, 'Central Midfielder'),
(2, 402, 601, 'Goalkeeper'), (4, 402, 601, 'Right Fullback'), (14, 402, 601, 'Striker'),
(5, 403, 602, 'Goalkeeper'), (15, 403, 602, 'Striker'),
(6, 404, 602, 'Goalkeeper'), (12, 404, 602, 'Striker'), (16, 404, 602, 'Right Fullback'),
(7, 405, 603, 'Goalkeeper'), (17, 405, 603, 'Striker'),
(8, 406, 603, 'Goalkeeper'), (18, 406, 603, 'Striker'),
(9, 407, 604, 'Goalkeeper'), (19, 407, 604, 'Striker'),
(10, 408, 604, 'Goalkeeper'), (11, 408, 604, 'Striker'), (20, 408, 604, 'Right Fullback'),
(21, 409, 605, 'Goalkeeper'),
(22, 410, 605, 'Goalkeeper'),
(1, 401, 606, 'Goalkeeper'), (3, 401, 606, 'Right Fullback'), (13, 401, 606, 'Striker'),
(5, 403, 606, 'Center Back'), (15, 403, 606, 'Striker'),
(1, 401, 607, 'Goalkeeper'), (3, 401, 607, 'Center Back'), (13, 401, 607, 'Striker'),
(8, 406, 607, 'Defending Midfielder'), (18, 406, 607, 'Goalkeeper'),
(2, 402, 608, 'Goalkeeper'), (4, 402, 608, 'Striker'), (14, 402, 608, 'Right Winger'),
(6, 404, 608, 'Goalkeeper'), (12, 404, 608, 'Striker'), (16, 404, 608, 'Left Winger'),
(5, 403, 609, 'Goalkeeper'), (15, 403, 609, 'Attacking Midfielder'),
(7, 405, 609, 'Central Midfielder'), (17, 405, 609, 'Goalkeeper'),
(9, 407, 610, 'Goalkeeper'), (19, 407, 610, 'Striker'),
(21, 409, 610, 'Goalkeeper');

-- FIFA games (separate from club Sessions), spread 2023-2026
INSERT INTO FIFA_Games (gameID, gameDate, venue, finalScore) VALUES
(701, '2023-06-10', 'National Stadium', '3-1'),
(702, '2023-09-15', 'Regional Arena', '2-2'),
(703, '2024-02-20', 'City Sports Complex', '1-0'),
(704, '2024-07-05', 'Metro Stadium', '4-2'),
(705, '2024-11-12', 'Coastal Field', '0-0'),
(706, '2025-01-18', 'National Stadium', '2-1'),
(707, '2025-04-22', 'Regional Arena', '3-3'),
(708, '2025-08-30', 'City Sports Complex', '1-1'),
(709, '2026-03-14', 'Metro Stadium', '2-0'),
(710, '2026-06-01', 'Coastal Field', '3-2'),
(711, '2023-12-01', 'National Stadium', '1-1'),
(712, '2024-05-09', 'Regional Arena', '2-1'),
(713, '2024-09-01', 'City Sports Complex', '2-2'),
(714, '2025-02-14', 'Metro Stadium', '1-3'),
(715, '2025-10-10', 'Coastal Field', '0-2');

INSERT INTO PlaysIn (teamID, gameID) VALUES
(401, 706), (403, 706),
(402, 707), (404, 707),
(403, 703), (408, 703),
(404, 704), (409, 704),
(405, 705), (410, 705),
(401, 710), (409, 710),
(401, 711), (405, 711),
(401, 712), (407, 712),
(402, 713), (406, 713),
(402, 714), (409, 714),
(402, 715), (410, 715),
(401, 701), (406, 701),
(402, 702), (407, 702);

-- members 1,3,13 (team 401) and 2,4,14 (team 402) each get 5 FIFA games -> item 11
-- members 5,15 and 6,16 each get 1 FIFA game -> item 8 (2+ FIFA players per location)
INSERT INTO ParticipatesIn (memberNo, teamID, gameID) VALUES
(1, 401, 701), (1, 401, 706), (1, 401, 710), (1, 401, 711), (1, 401, 712),
(3, 401, 701), (3, 401, 706), (3, 401, 710), (3, 401, 711), (3, 401, 712),
(13, 401, 701), (13, 401, 706), (13, 401, 710), (13, 401, 711), (13, 401, 712),
(2, 402, 702), (2, 402, 707), (2, 402, 713), (2, 402, 714), (2, 402, 715),
(4, 402, 702), (4, 402, 707), (4, 402, 713), (4, 402, 714), (4, 402, 715),
(14, 402, 702), (14, 402, 707), (14, 402, 713), (14, 402, 714), (14, 402, 715),
(5, 403, 703), (15, 403, 703),
(6, 404, 704), (16, 404, 704);

-- two members active on payments but never assigned to a session -> item 13
INSERT INTO ClubMembers
(firstName, lastName, dob, height, weight, ssn, medicareNo, phone, email, address, city, province, postalCode)
VALUES
('Layla', 'Fares', '1993-08-01', 165.00, 60.00, '900000026', 'LFAR990112', '514-555-0401', 'LaylaFares@gmail.com', '401 Birch St', 'Montreal', 'Quebec', 'H3E 1A1'),
('Samir', 'Attia', '1991-02-17', 180.00, 78.00, '900000027', 'SATT881203', '514-555-0402', 'SamirAttia@gmail.com', '402 Birch St', 'Laval', 'Quebec', 'H7E 1A2');
-- memberNo 23 and 24 (auto-increment)

INSERT INTO Majors (memberNo) VALUES (23), (24);

INSERT INTO MemberAt (memberNo, locationID, startDate, endDate) VALUES
(23, 1, '2024-01-01', NULL),
(24, 2, '2024-01-01', NULL);

INSERT INTO Payments (paymentID, memberNo, paymentDate, amount, method, memYear) VALUES
(534, 23, '2025-01-05', 200.00, 'Credit', 2025),
(535, 24, '2025-01-06', 200.00, 'Debit', 2025);

INSERT INTO ParticipatesIn (memberNo, teamID, gameID) VALUES
(23, 401, 706),
(24, 403, 706);

-- extra club Sessions/TeamFormations so locations 1,2,3 reach 4+ game sessions
-- in 2025 (item 12), and cover the 5 roles from item 16
INSERT INTO Sessions (sessionID, sessionDateTime, address, nature) VALUES
(631, '2025-03-10 15:00:00', 'Montreal Stadium', 'Game'),
(632, '2025-07-20 15:00:00', 'Longueuil Stadium', 'Game'),
(633, '2025-02-01 10:00:00', 'Montreal Practice Field', 'Training'),
(634, '2025-08-01 10:00:00', 'Longueuil Practice Field', 'Training'),
(635, '2025-01-15 15:00:00', 'Brossard Stadium', 'Game'),
(636, '2025-04-01 15:00:00', 'Longueuil Stadium', 'Game'),
(638, '2025-05-05 10:00:00', 'Montreal Practice Field', 'Training'),
(639, '2025-06-06 10:00:00', 'Montreal Practice Field', 'Training');

-- two volunteer coaches who are also family members (same ssn) -> items 17, 19
-- (must exist before the TeamFormations insert below, which makes them head coaches)
INSERT INTO Personnel
(personnelID, firstName, lastName, dob, ssn, medicareNo, phone, email, address, city, province, postalCode, `role`, title, mandate)
VALUES
(117, 'Karim', 'Haddad', '1985-03-15', '333333301', 'KHAD850315', '514-555-0117', 'karim.haddad@gmail.com', '117 Cedar St', 'Montreal', 'Quebec', 'H1K 1C5', 'Coach', 'Volunteer Coach', 'Volunteer'),
(118, 'Sara', 'Iqbal', '1987-07-22', '333333302', 'SIQB870722', '514-555-0118', 'sara.iqbal@gmail.com', '118 Cedar St', 'Montreal', 'Quebec', 'H1K 1C6', 'Coach', 'Volunteer Coach', 'Volunteer');

INSERT INTO WorksAt (personnelID, locationID, startDate, endDate) VALUES
(117, 1, '2023-01-01', NULL),
(118, 1, '2023-01-01', NULL);

INSERT INTO TeamFormations (personnelID, teamID, sessionID, score) VALUES
(115, 401, 631, 2), (106, 402, 631, 1),
(115, 401, 632, 1), (107, 403, 632, 1),
(115, 401, 633, NULL), (106, 402, 633, NULL),
(107, 403, 634, NULL), (115, 401, 634, NULL),
(106, 402, 635, 0), (108, 404, 635, 2),
(107, 403, 636, 3), (106, 402, 636, 0),
(117, 401, 638, NULL), (106, 402, 638, NULL),
(118, 401, 639, NULL), (107, 403, 639, NULL);

INSERT INTO AssignedTo (memberNo, teamID, sessionID, `role`) VALUES
(1, 401, 631, 'Striker'), (2, 402, 631, 'Goalkeeper'),
(3, 401, 632, 'Right Fullback'), (5, 403, 632, 'Goalkeeper'),
(1, 401, 633, 'Goalkeeper'), (2, 402, 633, 'Striker'),
(5, 403, 634, 'Goalkeeper'), (3, 401, 634, 'Striker'),
(4, 402, 635, 'Striker'), (6, 404, 635, 'Goalkeeper'),
(15, 403, 636, 'Striker'), (14, 402, 636, 'Goalkeeper'),
-- members 10 and 19 get the other 4 of the 5 item-16 roles here
-- member 10's session-604 row is 'Goalkeeper' (already have that one), needs Striker too
-- member 19's session-604 row is 'Striker' (already have that one), 4 more below cover the rest
(10, 402, 631, 'Striker'), (10, 403, 632, 'Sweeper'),
(10, 404, 635, 'Right Fullback'), (10, 403, 636, 'Defending'),
(19, 402, 631, 'Goalkeeper'), (19, 403, 632, 'Right Fullback'),
(19, 404, 635, 'Sweeper'), (19, 403, 636, 'Defending');

-- family-member side of personnel 117/118 (same ssn) -> items 17, 19
INSERT INTO FamilyMembers
(familyID, firstName, lastName, dob, ssn, medicareNo, phone, email, address, city, province, postalCode)
VALUES
(214, 'Karim', 'Haddad', '1985-03-15', '333333301', 'KHAD850315', '514-555-0117', 'karim.haddad@gmail.com', '117 Cedar St', 'Montreal', 'Quebec', 'H1K 1C5'),
(215, 'Sara', 'Iqbal', '1987-07-22', '333333302', 'SIQB870722', '514-555-0118', 'sara.iqbal@gmail.com', '118 Cedar St', 'Montreal', 'Quebec', 'H1K 1C6');

INSERT INTO RegistersAt (familyID, locationID, startDate, endDate) VALUES
(214, 1, '2023-01-01', NULL),
(215, 1, '2023-01-01', NULL);

INSERT INTO FamilyOf (memberNo, familyID, relationship, familyType, startDate, endDate) VALUES
(1, 214, 'Tutor', 'Secondary', '2023-01-01', NULL),
(3, 215, 'Tutor', 'Secondary', '2023-01-01', NULL);
-- 117/118 already set as head coaches of sessions 638/639 in the TeamFormations insert above

-- two members registered as minors years ago, now 18+ -> item 14
-- (nobody currently in Minors is 18+ yet without this)
INSERT INTO ClubMembers
(firstName, lastName, dob, height, weight, ssn, medicareNo, phone, email, address, city, province, postalCode)
VALUES
('Ali', 'Haddad', '2007-01-10', 179.00, 74.00, '900000028', 'AHAD070110', '514-555-0403', 'AliHaddad@gmail.com', '403 Birch St', 'Montreal', 'Quebec', 'H3E 1A3'),
('Mona', 'Karim', '2006-05-20', 166.00, 61.00, '900000029', 'MKAR060520', '514-555-0404', 'MonaKarim@gmail.com', '404 Birch St', 'Verdun', 'Quebec', 'H4G 1A4');
-- memberNo 25 and 26

INSERT INTO Minors (memberNo) VALUES (25), (26);

INSERT INTO FamilyOf (memberNo, familyID, relationship, familyType, startDate, endDate) VALUES
(25, 201, 'Father', 'Primary', '2015-01-01', NULL),
(26, 205, 'Grandfather', 'Primary', '2014-01-01', NULL);

INSERT INTO MemberAt (memberNo, locationID, startDate, endDate) VALUES
(25, 1, '2015-01-01', NULL),
(26, 5, '2014-01-01', NULL);

INSERT INTO Payments (paymentID, memberNo, paymentDate, amount, method, memYear) VALUES
(536, 25, '2025-01-10', 200.00, 'Credit', 2025),  -- fully paid -> Active
(537, 26, '2025-01-20', 150.00, 'Debit', 2025);   -- underpaid -> Inactive
