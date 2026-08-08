const express = require('express');
const asyncHandler = require('../utils/asyncHandler');
const ctrl = require('../controllers/paymentController');

const router = express.Router();

router.get('/', asyncHandler(ctrl.listPayments));
router.get('/summary/:memberNo/:memYear', asyncHandler(ctrl.getPaymentSummary));
router.post('/', asyncHandler(ctrl.createPayment));
router.put('/:id', asyncHandler(ctrl.updatePayment));
router.delete('/:id', asyncHandler(ctrl.deletePayment));

module.exports = router;
