const mongoose = require("mongoose");

const AdminPaymentRequestSchema = new mongoose.Schema({
  amount: { type: Number, required: true },
  // You may add other admin-only fields (like a title, description, or expiry)
  status: { type: String, default: "open" }, // For example: open, used, etc.
  createdAt: { type: Date, default: Date.now },
});

module.exports = mongoose.model("AdminPaymentRequest", AdminPaymentRequestSchema);
