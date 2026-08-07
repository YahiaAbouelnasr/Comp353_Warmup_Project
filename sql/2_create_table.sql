USE wfc353_1;

-- since we might run the code several times for demo purposes etc
DROP TABLE IF EXISTS AssignedTo;
DROP TABLE IF EXISTS ParticipatesIn;
DROP TABLE IF EXISTS PlaysIn;
DROP TABLE IF EXISTS TeamFormations;
DROP TABLE IF EXISTS EmailLog;
DROP TABLE IF EXISTS Payments;
DROP TABLE IF EXISTS HasHobby;
DROP TABLE IF EXISTS FamilyOf;
DROP TABLE IF EXISTS MemberAt;
DROP TABLE IF EXISTS RegistersAt;
DROP TABLE IF EXISTS Manages;
DROP TABLE IF EXISTS WorksAt;
DROP TABLE IF EXISTS BelongsTo;
DROP TABLE IF EXISTS Majors;
DROP TABLE IF EXISTS Minors;
DROP TABLE IF EXISTS LocationPhones;
DROP TABLE IF EXISTS FIFA_Games;
DROP TABLE IF EXISTS Sessions;
DROP TABLE IF EXISTS Teams;
DROP TABLE IF EXISTS Hobbies;
DROP TABLE IF EXISTS ClubMembers;
DROP TABLE IF EXISTS FamilyMembers;
DROP TABLE IF EXISTS Personnel;
DROP TABLE IF EXISTS Locations;


-- Entity tables --

CREATE TABLE Locations (
    locationID INT PRIMARY KEY,
    type ENUM('Head', 'Branch') NOT NULL,
    name VARCHAR(100) NOT NULL,
    address VARCHAR(150) NOT NULL,
    city VARCHAR(60) NOT NULL,
    province VARCHAR(60) NOT NULL,
    postalCode VARCHAR(10) NOT NULL,
    webAddress VARCHAR(255) DEFAULT 'https://www.SoccerClub.com',
    capacity INT NOT NULL
);

CREATE TABLE Personnel (
    personnelID INT PRIMARY KEY,
    firstName VARCHAR(50) NOT NULL,
    lastName VARCHAR(50) NOT NULL,
    dob DATE NOT NULL,
    ssn CHAR(9) NOT NULL UNIQUE,
    medicareNo VARCHAR(20) UNIQUE,
    phone VARCHAR(20),
    email VARCHAR(100),
    address VARCHAR(150),
    city VARCHAR(60),
    province VARCHAR(60),
    postalCode VARCHAR(10),
    `role` ENUM(
        'Administrator',
        'Captain',
        'Coach',
        'Assistant Coach',
        'Other'
    ) NOT NULL,
    title VARCHAR(50),
    mandate ENUM('Volunteer', 'Salaried') NOT NULL
);

CREATE TABLE FamilyMembers (
    familyID INT PRIMARY KEY,
    firstName VARCHAR(50) NOT NULL,
    lastName VARCHAR(50) NOT NULL,
    dob DATE NOT NULL,
    ssn CHAR(9) UNIQUE,
    medicareNo VARCHAR(20),
    phone VARCHAR(20) NOT NULL,
    email VARCHAR(100),
    address VARCHAR(150),
    city VARCHAR(60),
    province VARCHAR(60),
    postalCode VARCHAR(10) NOT NULL
);

CREATE TABLE ClubMembers (
    memberNo INT AUTO_INCREMENT PRIMARY KEY,
    firstName VARCHAR(50) NOT NULL,
    lastName VARCHAR(50) NOT NULL,
    dob DATE NOT NULL,
    height DECIMAL(5,2),
    weight DECIMAL(5,2),
    ssn CHAR(9) UNIQUE,
    medicareNo VARCHAR(20),
    phone VARCHAR(20),
    email VARCHAR(100),
    address VARCHAR(150),
    city VARCHAR(60),
    province VARCHAR(60),
    postalCode VARCHAR(10) NOT NULL
);

CREATE TABLE Hobbies (
    hobbyName VARCHAR(50) PRIMARY KEY
);

CREATE TABLE Teams (
    teamID INT PRIMARY KEY,
    teamName VARCHAR(100) NOT NULL,
    gender ENUM('Boys', 'Girls') NOT NULL
);

CREATE TABLE Sessions (
    sessionID INT PRIMARY KEY, 
    sessionDateTime DATETIME NOT NULL,
    address VARCHAR(150) NOT NULL,
    nature ENUM (
        'Training',
        'Game'
    ) NOT NULL
);


CREATE TABLE LocationPhones (
    locationID INT,
    phone VARCHAR(20),

    PRIMARY KEY (locationID, phone),

    FOREIGN KEY (locationID)
        REFERENCES Locations(locationID)
);

CREATE TABLE Minors (
    memberNo INT PRIMARY KEY,

    FOREIGN KEY (memberNo)
        REFERENCES ClubMembers(memberNo)
);

CREATE TABLE Majors (
    memberNo INT PRIMARY KEY,

    FOREIGN KEY (memberNo)
        REFERENCES ClubMembers(memberNo)
);

CREATE TABLE Payments (
    memberNo INT NOT NULL,
    paymentID INT PRIMARY KEY, 
    paymentDate DATE,
    amount DECIMAL(10,2) NOT NULL,
    method ENUM('Cash', 'Debit', 'Credit') NOT NULL,
    memYear YEAR NOT NULL,

    FOREIGN KEY (memberNo)
        REFERENCES ClubMembers(memberNo)
);

CREATE TABLE TeamFormations (
    personnelID INT NOT NULL,
    teamID INT NOT NULL,
    sessionID INT NOT NULL,
    score INT,

    PRIMARY KEY (teamID, sessionID),

    FOREIGN KEY (personnelID)
        REFERENCES Personnel(personnelID),

    FOREIGN KEY (teamID)
        REFERENCES Teams(teamID),

    FOREIGN KEY (sessionID)
        REFERENCES Sessions(sessionID)
);



CREATE TABLE EmailLog (
    emailID INT AUTO_INCREMENT PRIMARY KEY,
    emailDate DATETIME NOT NULL,
    sender INT NOT NULL,
    receiver INT NOT NULL,
    subject VARCHAR(200) NOT NULL,
    bodyPreview VARCHAR(100),

    FOREIGN KEY (sender)
        REFERENCES Locations(locationID),

    FOREIGN KEY (receiver)
        REFERENCES ClubMembers(memberNo)
);

-- FIFA games: representative/tournament games a club member played in,
-- distinct from the club's own scheduled Sessions/TeamFormations.
CREATE TABLE FIFA_Games (
    gameID INT PRIMARY KEY,
    gameDate DATE NOT NULL,
    venue VARCHAR(150) NOT NULL,
    finalScore VARCHAR(20)
);

CREATE TABLE PlaysIn (
    teamID INT,
    gameID INT,

    PRIMARY KEY (teamID, gameID),

    FOREIGN KEY (teamID)
        REFERENCES Teams(teamID),

    FOREIGN KEY (gameID)
        REFERENCES FIFA_Games(gameID)
);

CREATE TABLE ParticipatesIn (
    memberNo INT,
    teamID INT,
    gameID INT,

    PRIMARY KEY (memberNo, teamID, gameID),

    FOREIGN KEY (memberNo)
        REFERENCES ClubMembers(memberNo),

    FOREIGN KEY (teamID, gameID)
        REFERENCES PlaysIn(teamID, gameID)
);

-- Relationship tables

CREATE TABLE WorksAt ( 
    personnelID INT,
    locationID INT,
    startDate DATE,
    endDate DATE,

    PRIMARY KEY (personnelID, locationID, startDate),

    FOREIGN KEY (personnelID)
        REFERENCES Personnel(personnelID),

    FOREIGN KEY (locationID)
        REFERENCES Locations(locationID)
);

CREATE TABLE Manages (
    personnelID INT UNIQUE NOT NULL,
    locationID INT PRIMARY KEY,

    FOREIGN KEY (personnelID)
        REFERENCES Personnel(personnelID),

    FOREIGN KEY (locationID)
        REFERENCES Locations(locationID)
);

CREATE TABLE RegistersAt ( 
    familyID INT,
    locationID INT,
    startDate DATE,
    endDate DATE,

    PRIMARY KEY (familyID, locationID, startDate),

    FOREIGN KEY (familyID)
        REFERENCES FamilyMembers(familyID),

    FOREIGN KEY (locationID)
        REFERENCES Locations(locationID)
);

CREATE TABLE MemberAt ( 
    memberNo INT,
    locationID INT,
    startDate DATE,
    endDate DATE,

    PRIMARY KEY (memberNo, locationID, startDate),

    FOREIGN KEY (memberNo)
        REFERENCES ClubMembers(memberNo),

    FOREIGN KEY (locationID)
        REFERENCES Locations(locationID)
);

CREATE TABLE FamilyOf ( 
    memberNo INT,
    familyID INT,
    familyType ENUM(
        'Primary',
        'Secondary'
    ),
    relationship ENUM(
        'Father',
        'Mother',
        'Grandfather',
        'Grandmother',
        'Tutor',
        'Partner',
        'Friend',
        'Other'
    ) NOT NULL,
    startDate DATE,
    endDate DATE,

    PRIMARY KEY (memberNo, familyID, startDate),

    FOREIGN KEY (memberNo)
        REFERENCES Minors(memberNo),

    FOREIGN KEY (familyID)
        REFERENCES FamilyMembers(familyID)
);

CREATE TABLE HasHobby (
    memberNo INT,
    hobbyName VARCHAR(50),

    PRIMARY KEY (memberNo, hobbyName),

    FOREIGN KEY (memberNo)
        REFERENCES ClubMembers(memberNo),

    FOREIGN KEY (hobbyName)
        REFERENCES Hobbies(hobbyName)
);

CREATE TABLE BelongsTo (
    teamID INT PRIMARY KEY,
    locationID INT NOT NULL,

    FOREIGN KEY (teamID)
        REFERENCES Teams(teamID),

    FOREIGN KEY (locationID)
        REFERENCES Locations(locationID)
);

CREATE TABLE AssignedTo (
    memberNo INT NOT NULL,
    teamID INT NOT NULL,
    sessionID INT NOT NULL,
    `role` VARCHAR(30) NOT NULL,

    PRIMARY KEY (memberNo, teamID, sessionID),

    FOREIGN KEY (memberNo)
        REFERENCES ClubMembers(memberNo),

    FOREIGN KEY (teamID, sessionID)
        REFERENCES TeamFormations(teamID, sessionID)

);
