const express = require('express');
const asyncHandler = require('../utils/asyncHandler');
const ctrl = require('../controllers/emailController');

const router = express.Router();

router.get('/', asyncHandler(ctrl.listEmailLog));
router.post('/generate', asyncHandler(ctrl.generateWeeklyEmails));

module.exports = router;
