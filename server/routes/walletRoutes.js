// routes/walletRoutes.js
const express = require("express");
const router = express.Router();
const { createWalletTransaction } = require("../services/walletService");

// Endpoint to process a wallet transaction (deposit, win, bonus, addCoin, redeem, withdraw)
router.post("/wallet/transaction", async (req, res) => {
  try {
    const {
      userId,
      amount,
      transactionType, // e.g. "deposit", "win", "bonus", "addCoin", "redeem", "withdraw"
      paymentType,     // e.g. "Credit" or "Debit"
      paymentMethod,   // e.g. "UPI", "Card", "Bank Transfer", "Crypto"
      remark,
      adminAction,
    } = req.body;

    const result = await createWalletTransaction({
      userId,
      amount,
      transactionType,
      paymentType,
      paymentMethod,
      remark,
      adminAction,
    });

    res.status(200).json({
      message: "Transaction processed successfully",
      result,
    });
  } catch (error) {
    res.status(400).json({ message: error.message });
  }
});

module.exports = router;
