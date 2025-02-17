// server/controllers/adminPaymentController.js
const AdminPaymentRequest = require("../models/AdminPaymentRequest");

exports.createAdminPaymentRequest = async (req, res) => {
  try {
    const { amount } = req.body;
    if (!amount) {
      return res.status(400).json({ error: "Amount is required" });
    }
    const adminRequest = new AdminPaymentRequest({ amount });
    const savedRequest = await adminRequest.save();
    res.json(savedRequest);
  } catch (error) {
    console.error("Error creating admin payment request:", error.message);
    res.status(500).json({ error: error.message });
  }
};

exports.getAdminPaymentRequests = async (req, res) => {
  try {
    // Fetch all admin payment requests, sorted by created date (newest first)
    const requests = await AdminPaymentRequest.find({}).sort({ createdAt: -1 });
    res.json(requests);
  } catch (error) {
    console.error("Error fetching admin payment requests:", error.message);
    res.status(500).json({ error: error.message });
  }
};
