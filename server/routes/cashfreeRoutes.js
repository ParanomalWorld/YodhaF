// server/routes/cashfreeRoutes.js
const express = require("express");
const router = express.Router();
const cashfreeController = require("../controllers/cashfreeController");

// Create Order Endpoint
//router.post("/create-order", cashfreeController.createOrder);

// Get Orders Endpoint
router.get("/orders", cashfreeController.getOrders);

// Payment Verification Endpoint
router.post("/verify", cashfreeController.verifyPayment);

module.exports = router;
