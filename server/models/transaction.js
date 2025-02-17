const mongoose = require("mongoose");

const TransactionSchema = new mongoose.Schema({
  user: {
    type: mongoose.Schema.Types.ObjectId,
    ref: "User",
    required: true,
  },
  wallet: {
    type: mongoose.Schema.Types.ObjectId,
    ref: "Wallet",
    required: true,
  },
  orderId: {
    type: String,
    required: true,
    unique: true, // Ensuring no duplicate transactions
  },
  type: {
    type: String,
    enum: ["Deposit", "win", "bonus", "addCoin", "redeem", "withdraw"],
    required: true,
  },
  amount: {
    type: Number,
    required: true,
    min: 0, // Ensuring amount is never negative
  },
  playCoins: {
    type: Number,
    default: 0,
    min: 0,
  },
  paymentType: {
    type: String,
    enum: ["UPI", "Card", "Bank Transfer", "Crypto", "Wallet"],
    default: "Wallet",
  },
  paymentMethod: {
    type: String,
    default: "N/A",
  },
  paymentStatus: {
    type: String,
    enum: ["pending", "success", "failed"],
    default: "pending",
  },
  remark: {
    type: String,
    default: "",
    trim: true,
  },
  adminAction: {
    type: Boolean,
    default: false,
  },
  fraudCheck: {
    type: Boolean,
    default: false,
  },
}, { 
  timestamps: true // Automatically creates createdAt and updatedAt
});

module.exports = mongoose.model("Transaction", TransactionSchema);
