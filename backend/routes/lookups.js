const express = require('express');
const asyncHandler = require('../utils/asyncHandler');
const ctrl = require('../controllers/lookupController');

const router = express.Router();

router.get('/teams', asyncHandler(ctrl.listTeams));
router.get('/hobbies', asyncHandler(ctrl.listHobbies));
router.get('/minors', asyncHandler(ctrl.listMinors));

module.exports = router;
