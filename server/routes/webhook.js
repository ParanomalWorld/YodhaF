const express = require("express");
const router = express.Router();
const crypto = require("crypto");

// Import your models
const UserPaymentOrder = require("../models/UserPaymentOrder");
const Wallet = require("../models/wallet");
const Transaction = require("../models/transaction"); // Optional: for logging transactions

// Set your Cashfree webhook secret (update as per your environment)
const CASHFREE_SECRET = process.env.CLIENT_SECRET || "your_secret_here";

/**
 * Verify the webhook signature if Cashfree sends one.
 * (Adjust this function based on Cashfree's documentation)
 */
function verifySignature(req) {
    const receivedSignature = req.headers["x-webhook-signature"];
    const webhookTimestamp = req.headers["x-webhook-timestamp"];
    // Use the raw body captured by middleware
    const rawPayload = req.rawBody; 
    
    // Concatenate the timestamp and raw payload as required by Cashfree
    const dataToSign = webhookTimestamp + rawPayload;

    const calculatedSignature = crypto
      .createHmac("sha256", CASHFREE_SECRET)
      .update(dataToSign)
      .digest("base64");

    // console.log("Received Signature:", receivedSignature);
    // console.log("Calculated Signature:", calculatedSignature);
    // console.log("Data to Sign:", dataToSign);

    return receivedSignature === calculatedSignature;
}

  

router.post("/webhook", async (req, res) => {
  try {
    // Verify webhook signature for security
    if (!verifySignature(req)) {
      return res.status(401).json({ error: "Invalid webhook signature" });
    }

    const payload = req.body;
   /// console.log("Received Cashfree webhook payload:", payload);

    // Process the payload only if the payment is successful.
    if (payload && payload.payment_status === "SUCCESS") {
      const orderId = payload.order_id;
      const paymentAmount = Number(payload.order_amount) || 0;

      // Find the corresponding payment order in your database.
      const paymentOrder = await UserPaymentOrder.findOne({ orderId });
      if (!paymentOrder) {
        console.error(`No order found with Order ID: ${orderId}`);
        return res.status(404).json({ error: "Order not found" });
      }

      // Update order status if not already set to paid.
      if (paymentOrder.status !== "paid") {
        paymentOrder.status = "paid";
        await paymentOrder.save();
      }

      // Update the user's wallet.
      const userId = paymentOrder.customer; // User's ObjectId.
      const wallet = await Wallet.findOne({ user: userId });
      if (!wallet) {
        console.error(`No wallet found for user: ${userId}`);
        return res.status(404).json({ error: "Wallet not found" });
      }

      // Update the mainBalance (deposit the payment amount as coins).
      wallet.mainBalance += paymentAmount;
      await wallet.save();

      // Optionally, create a transaction log for auditing purposes.
      const transaction = new Transaction({
        user: userId,
        wallet: wallet._id,
        orderId: orderId,
        type: "deposit", // Or "addCoin" based on your business logic.
        amount: paymentAmount,
        playCoins: paymentAmount, // Assuming a 1:1 conversion.
        paymentType: "Cashfree",
        paymentMethod: "Online",
        paymentStatus: "success",
        remark: "Payment successful via Cashfree webhook",
        adminAction: false,
        fraudCheck: false,
      });
      await transaction.save();

      console.log(`Wallet updated for user ${userId}: Added ${paymentAmount} to mainBalance.`);
    } else {
      console.log("Payment not successful. Webhook received but no action taken.");
    }

    // Respond to Cashfree to confirm receipt of the webhook.
    return res.status(200).json({ message: "Webhook processed successfully" });
  } catch (error) {
    console.error("Error processing webhook:", error.message);
    return res.status(500).json({ error: "Internal server error" });
  }
});

module.exports = router;
