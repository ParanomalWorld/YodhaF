// server/routes/adminPaymentRoutes.js
const express = require("express");
const router = express.Router();
const adminPaymentController = require("../controllers/adminPaymentController");
const auth = require("../middleware/auth"); // Authentication middleware

// GET route for fetching all admin payment requests
router.get("/admin-payment-request",auth, adminPaymentController.getAdminPaymentRequests);

// POST route for creating a new admin payment request
router.post("/admin-payment-request",auth, adminPaymentController.createAdminPaymentRequest);

module.exports = router;
