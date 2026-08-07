USE wfc353_1;

SELECT 'Locations' AS tableName, COUNT(*) AS Count FROM Locations
UNION ALL SELECT 'LocationPhones', COUNT(*) FROM LocationPhones
UNION ALL SELECT 'Personnel', COUNT(*) FROM Personnel
UNION ALL SELECT 'FamilyMembers', COUNT(*) FROM FamilyMembers
UNION ALL SELECT 'ClubMembers', COUNT(*) FROM ClubMembers
UNION ALL SELECT 'Hobbies', COUNT(*) FROM Hobbies
UNION ALL SELECT 'Teams', COUNT(*) FROM Teams
UNION ALL SELECT 'Sessions', COUNT(*) FROM Sessions
UNION ALL SELECT 'Minors', COUNT(*) FROM Minors
UNION ALL SELECT 'Majors', COUNT(*) FROM Majors
UNION ALL SELECT 'Payments', COUNT(*) FROM Payments
UNION ALL SELECT 'TeamFormations', COUNT(*) FROM TeamFormations
UNION ALL SELECT 'EmailLog', COUNT(*) FROM EmailLog
UNION ALL SELECT 'FIFA_Games', COUNT(*) FROM FIFA_Games
UNION ALL SELECT 'PlaysIn', COUNT(*) FROM PlaysIn
UNION ALL SELECT 'ParticipatesIn', COUNT(*) FROM ParticipatesIn
UNION ALL SELECT 'WorksAt', COUNT(*) FROM WorksAt
UNION ALL SELECT 'Manages', COUNT(*) FROM Manages
UNION ALL SELECT 'RegistersAt', COUNT(*) FROM RegistersAt
UNION ALL SELECT 'MemberAt', COUNT(*) FROM MemberAt
UNION ALL SELECT 'FamilyOf', COUNT(*) FROM FamilyOf
UNION ALL SELECT 'HasHobby', COUNT(*) FROM HasHobby
UNION ALL SELECT 'BelongsTo', COUNT(*) FROM BelongsTo
UNION ALL SELECT 'AssignedTo', COUNT(*) FROM AssignedTo;
