const express = require('express');
const asyncHandler = require('../utils/asyncHandler');
const ctrl = require('../controllers/personnelController');

const router = express.Router();

router.get('/', asyncHandler(ctrl.listPersonnel));
router.get('/:id', asyncHandler(ctrl.getPersonnel));
router.post('/', asyncHandler(ctrl.createPersonnel));
router.put('/:id', asyncHandler(ctrl.updatePersonnel));
router.post('/:id/transfer', asyncHandler(ctrl.transferPersonnel));
router.delete('/:id', asyncHandler(ctrl.deletePersonnel));

module.exports = router;
