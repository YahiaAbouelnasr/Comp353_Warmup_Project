USE wfc353_1;

-- Item 20: triggers

-- Trigger 1: reject an assignment if the member already has another
-- formation on the same day less than 3 hours apart. INSERT + UPDATE.

DROP TRIGGER IF EXISTS trg_assignedto_conflict_ins;
DROP TRIGGER IF EXISTS trg_assignedto_conflict_upd;

DELIMITER $$

CREATE TRIGGER trg_assignedto_conflict_ins
BEFORE INSERT ON AssignedTo
FOR EACH ROW
BEGIN
    DECLARE newSessionTime DATETIME;
    DECLARE conflictCount INT;

    SELECT sessionDateTime INTO newSessionTime
    FROM Sessions WHERE sessionID = NEW.sessionID;

    SELECT COUNT(*) INTO conflictCount
    FROM AssignedTo at
    JOIN Sessions s ON s.sessionID = at.sessionID
    WHERE at.memberNo = NEW.memberNo
      AND at.sessionID <> NEW.sessionID
      AND DATE(s.sessionDateTime) = DATE(newSessionTime)
      AND ABS(TIMESTAMPDIFF(MINUTE, s.sessionDateTime, newSessionTime)) < 180;

    IF conflictCount > 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Assignment conflict: club member is already assigned to a formation session within 3 hours on this day.';
    END IF;
END$$

CREATE TRIGGER trg_assignedto_conflict_upd
BEFORE UPDATE ON AssignedTo
FOR EACH ROW
BEGIN
    DECLARE newSessionTime DATETIME;
    DECLARE conflictCount INT;

    SELECT sessionDateTime INTO newSessionTime
    FROM Sessions WHERE sessionID = NEW.sessionID;

    SELECT COUNT(*) INTO conflictCount
    FROM AssignedTo at
    JOIN Sessions s ON s.sessionID = at.sessionID
    WHERE at.memberNo = NEW.memberNo
      AND at.sessionID <> NEW.sessionID
      AND DATE(s.sessionDateTime) = DATE(newSessionTime)
      AND ABS(TIMESTAMPDIFF(MINUTE, s.sessionDateTime, newSessionTime)) < 180;

    IF conflictCount > 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Assignment conflict: club member is already assigned to a formation session within 3 hours on this day.';
    END IF;
END$$

DELIMITER ;

-- Trigger 2: reject a payment past 4 installments per membership year

DROP TRIGGER IF EXISTS trg_payments_max_installments;

DELIMITER $$

CREATE TRIGGER trg_payments_max_installments
BEFORE INSERT ON Payments
FOR EACH ROW
BEGIN
    DECLARE installmentCount INT;

    SELECT COUNT(*) INTO installmentCount
    FROM Payments
    WHERE memberNo = NEW.memberNo AND memYear = NEW.memYear;

    IF installmentCount >= 4 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Payment rejected: club member already has 4 installments recorded for this membership year.';
    END IF;
END$$

DELIMITER ;

-- Trigger 3: reject a new club member under 4 years old
-- (CURDATE() isn't allowed in a CHECK constraint, so this needs a trigger)

DROP TRIGGER IF EXISTS trg_clubmembers_min_age;

DELIMITER $$

CREATE TRIGGER trg_clubmembers_min_age
BEFORE INSERT ON ClubMembers
FOR EACH ROW
BEGIN
    IF TIMESTAMPDIFF(YEAR, NEW.dob, CURDATE()) < 4 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Registration rejected: a new club member must be at least 4 years old.';
    END IF;
END$$

DELIMITER ;
