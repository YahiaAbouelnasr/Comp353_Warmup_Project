const express = require('express');
const asyncHandler = require('../utils/asyncHandler');
const ctrl = require('../controllers/locationController');

const router = express.Router();

router.get('/', asyncHandler(ctrl.listLocations));
router.get('/:id', asyncHandler(ctrl.getLocation));
router.post('/', asyncHandler(ctrl.createLocation));
router.put('/:id', asyncHandler(ctrl.updateLocation));
router.delete('/:id', asyncHandler(ctrl.deleteLocation));

module.exports = router;
