const express = require("express");
const router = express.Router();
const userPaymentController = require("../controllers/userPaymentController");
const authFullUser = require("../middleware/authFullUser"); // Use full-user auth

// Create a payment order (initial status "pending")
router.post("/user-payment-order", authFullUser, userPaymentController.createUserPaymentOrder);

// Verify payment and update the order status accordingly
router.post("/verify", authFullUser, userPaymentController.verifyPayment);

// Cancel payment order (if user cancels)
router.post("/cancel", authFullUser, userPaymentController.cancelPaymentOrder);

// Retrieve orders (optional)
router.get("/orders", authFullUser, userPaymentController.getOrders);

router.get("/user-transactions", authFullUser, userPaymentController.getUserTransactions);

router.get("/user-wallat-balance", authFullUser, userPaymentController.getUserWallatBalance);


module.exports = router;
