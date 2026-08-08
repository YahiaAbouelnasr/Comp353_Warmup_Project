const express = require('express');
const asyncHandler = require('../utils/asyncHandler');
const ctrl = require('../controllers/teamFormationController');

const router = express.Router();

// Sessions (a session = one training/game event with two TeamFormations)
router.get('/sessions', asyncHandler(ctrl.listSessions));
router.get('/sessions/:sessionID', asyncHandler(ctrl.getSession));
router.post('/sessions', asyncHandler(ctrl.createSession));
router.put('/sessions/:sessionID', asyncHandler(ctrl.updateSession));
router.delete('/sessions/:sessionID', asyncHandler(ctrl.deleteSession));

// One team's formation within a session
router.put('/formations/:teamID/:sessionID', asyncHandler(ctrl.updateFormation));

// Item 6: assign/edit/delete a club member on a formation
router.post('/formations/:teamID/:sessionID/assign', asyncHandler(ctrl.assignMember));
router.put('/formations/:teamID/:sessionID/assign/:memberNo', asyncHandler(ctrl.updateAssignment));
router.delete('/formations/:teamID/:sessionID/assign/:memberNo', asyncHandler(ctrl.deleteAssignment));

module.exports = router;
