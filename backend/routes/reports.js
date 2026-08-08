const express = require('express');
const asyncHandler = require('../utils/asyncHandler');
const ctrl = require('../controllers/reportController');

const router = express.Router();

router.get('/locations-fifa-players', asyncHandler(ctrl.locationsWithFifaPlayers)); // item 8
router.get('/primary-family-fifa', asyncHandler(ctrl.primaryFamilyWithFifaKids)); // item 9
router.get('/team-formations', asyncHandler(ctrl.teamFormationsForLocation)); // item 10 ?locationID=&start=&end=
router.get('/frequent-fifa-players', asyncHandler(ctrl.frequentFifaPlayers)); // item 11
router.get('/formations-summary', asyncHandler(ctrl.formationsSummaryByLocation)); // item 12 ?start=&end=
router.get('/never-assigned-fifa', asyncHandler(ctrl.activeNeverAssignedButFifa)); // item 13
router.get('/majors-since-minors', asyncHandler(ctrl.majorsSinceMinors)); // item 14
router.get('/goalkeeper-only', asyncHandler(ctrl.goalkeeperOnlyMembers)); // item 15
router.get('/all-five-roles', asyncHandler(ctrl.allFiveRolesMembers)); // item 16
router.get('/head-coach-family', asyncHandler(ctrl.familyMembersWhoAreHeadCoaches)); // item 17 ?locationID=
router.get('/never-won', asyncHandler(ctrl.neverWonMembers)); // item 18
router.get('/volunteer-family-fifa', asyncHandler(ctrl.volunteerFamilyWithFifaKids)); // item 19

module.exports = router;
