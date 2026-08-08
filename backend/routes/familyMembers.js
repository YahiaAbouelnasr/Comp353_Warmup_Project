const express = require('express');
const asyncHandler = require('../utils/asyncHandler');
const ctrl = require('../controllers/familyMemberController');

const router = express.Router();

router.get('/', asyncHandler(ctrl.listFamilyMembers));
router.get('/:id', asyncHandler(ctrl.getFamilyMember));
router.post('/', asyncHandler(ctrl.createFamilyMember));
router.put('/:id', asyncHandler(ctrl.updateFamilyMember));
router.post('/:id/link', asyncHandler(ctrl.linkToMember));
router.delete('/:id/link/:memberNo', asyncHandler(ctrl.unlinkFromMember));
router.delete('/:id', asyncHandler(ctrl.deleteFamilyMember));

module.exports = router;
