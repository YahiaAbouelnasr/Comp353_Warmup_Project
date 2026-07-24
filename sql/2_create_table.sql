USE wfc353_1;

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

CREATE TABLE FIFA_Games ( 
    gameID INT PRIMARY KEY,
    gameDate DATE NOT NULL,
    venue VARCHAR(150) NOT NULL,
    finalScore VARCHAR(20) NOT NULL
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
    memberNo INT,
    paymentDate DATE,
    amount DECIMAL(10,2) NOT NULL,
    method ENUM('Cash', 'Debit', 'Credit') NOT NULL,
    memYear YEAR NOT NULL,

    PRIMARY KEY (memberNo, paymentDate),

    FOREIGN KEY (memberNo)
        REFERENCES ClubMembers(memberNo)
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