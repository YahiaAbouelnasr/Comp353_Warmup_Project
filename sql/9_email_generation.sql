USE wfc353_1;

-- Item 22: generate session reminder emails, log them in EmailLog

DROP PROCEDURE IF EXISTS sp_generate_weekly_session_emails;

DELIMITER $$

CREATE PROCEDURE sp_generate_weekly_session_emails(IN refSunday DATE)
BEGIN
    DECLARE weekStart DATE;
    DECLARE weekEnd DATE;
    SET weekStart = DATE_ADD(refSunday, INTERVAL 1 DAY);
    SET weekEnd = DATE_ADD(refSunday, INTERVAL 7 DAY);

    INSERT INTO EmailLog (emailDate, sender, receiver, subject, bodyPreview)
    SELECT
        NOW(),
        bt.locationID,
        at.memberNo,
        CONCAT(t.teamName, ' ', DATE_FORMAT(s.sessionDateTime, '%W %d-%M-%Y %l:%i %p'), ' ', LOWER(s.nature), ' session'),
        LEFT(
            CONCAT('Dear ', cm.firstName, ' ', cm.lastName, ', you are scheduled as ', at.`role`,
                   ' for the ', LOWER(s.nature), ' session on ', DATE_FORMAT(s.sessionDateTime, '%b %d, %Y at %l:%i %p'),
                   ' at ', s.address, '. Head coach: ', p.firstName, ' ', p.lastName, ' (', p.email, ').'),
            100
        )
    FROM AssignedTo at
    JOIN TeamFormations tf ON tf.teamID = at.teamID AND tf.sessionID = at.sessionID
    JOIN Sessions s ON s.sessionID = at.sessionID
    JOIN Teams t ON t.teamID = at.teamID
    JOIN BelongsTo bt ON bt.teamID = at.teamID
    JOIN ClubMembers cm ON cm.memberNo = at.memberNo
    JOIN Personnel p ON p.personnelID = tf.personnelID
    WHERE DATE(s.sessionDateTime) BETWEEN weekStart AND weekEnd;
END$$

DELIMITER ;

-- optional: real weekly automation (needs event_scheduler = ON), not required for demo
DROP EVENT IF EXISTS ev_weekly_session_emails;
DELIMITER $$
CREATE EVENT ev_weekly_session_emails
ON SCHEDULE EVERY 1 WEEK STARTS '2026-08-09 06:00:00'
DO
BEGIN
    CALL sp_generate_weekly_session_emails(CURDATE());
END$$
DELIMITER ;

-- demo: pretend today is Sunday 2025-04-19, then Sunday 2025-04-27
CALL sp_generate_weekly_session_emails('2025-04-19');
CALL sp_generate_weekly_session_emails('2025-04-27');

-- display the log, newest first
SELECT
    e.emailID, e.emailDate,
    l.name AS senderLocation,
    CONCAT(cm.firstName, ' ', cm.lastName) AS receiverName,
    e.subject, e.bodyPreview
FROM EmailLog e
JOIN Locations l ON l.locationID = e.sender
JOIN ClubMembers cm ON cm.memberNo = e.receiver
ORDER BY e.emailID DESC;
