const express = require('express');
const asyncHandler = require('../utils/asyncHandler');
const ctrl = require('../controllers/clubMemberController');

const router = express.Router();

router.get('/', asyncHandler(ctrl.listClubMembers));
router.get('/:id', asyncHandler(ctrl.getClubMember));
router.post('/', asyncHandler(ctrl.createClubMember));
router.put('/:id', asyncHandler(ctrl.updateClubMember));
router.post('/:id/transfer', asyncHandler(ctrl.transferClubMember));
router.delete('/:id', asyncHandler(ctrl.deleteClubMember));

module.exports = router;
