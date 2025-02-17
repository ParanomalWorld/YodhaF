// models/wallet.js
const mongoose = require("mongoose");

const walletSchema = new mongoose.Schema({
  user: {
    type: mongoose.Schema.Types.ObjectId,
    ref: "User", // References the User model
    required: true,
  },
  mainBalance: {
    type: Number,
    required: true,
    default: 0,
  },
  winningBalance: {
    type: Number,
    required: true,
    default: 0,
  },
  bonusBalance: {
    type: Number,
    required: true,
    default: 0,
  },
  coinBalance: {
    type: Number,
    required: true,
    default: 0,
  },
  redeemBalance: {
    type: Number,
    required: true,
    default: 0,
  },
  currency: {
    type: String,
    default: "INR",
  },
  status: {
    type: String,
    enum: ["active", "suspended", "closed"],
    default: "active",
  },
  lastTransaction: {
    type: mongoose.Schema.Types.ObjectId,
    ref: "Transaction",
  },
  createdAt: {
    type: Date,
    default: Date.now,
  },
  updatedAt: {
    type: Date,
    default: Date.now,
  },
});

// Pre-save hook to update coinBalance as an integer
walletSchema.pre("save", function (next) {
  // Compute the coinBalance using your formula and floor the result.
  this.coinBalance = Math.floor(
    this.mainBalance +
      this.winningBalance +
      (this.bonusBalance * 0.5) -
      this.redeemBalance
  );
  next();
});

const Wallet = mongoose.model("Wallet", walletSchema);
module.exports = Wallet;
