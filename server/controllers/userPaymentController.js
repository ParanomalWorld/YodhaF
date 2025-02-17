const crypto = require("crypto"); 
const { Cashfree } = require("cashfree-pg");
require("dotenv").config();
const Wallet = require("../models/wallet");
 const Transaction = require("../models/transaction"); // if needed for logging

const AdminPaymentRequest = require("../models/AdminPaymentRequest");
const UserPaymentOrder = require("../models/UserPaymentOrder");

// Set up Cashfree credentials
Cashfree.XClientId = process.env.CLIENT_ID;
Cashfree.XClientSecret = process.env.CLIENT_SECRET;
Cashfree.XEnvironment = Cashfree.Environment.SANDBOX;

// Helper function to generate a random order ID.
function generateOrderId() {
  return crypto.randomBytes(6).toString("hex").toUpperCase();
}

exports.createUserPaymentOrder = async (req, res) => {
  try {
    const { adminPaymentRequestId } = req.body;
    if (!adminPaymentRequestId) {
      return res.status(400).json({ error: "Admin Payment Request ID is required" });
    }

    // Retrieve the admin payment request to get the amount.
    const adminRequest = await AdminPaymentRequest.findById(adminPaymentRequestId);
    if (!adminRequest) {
      return res.status(404).json({ error: "Admin Payment Request not found" });
    }
    const amount = adminRequest.amount;
    if (amount === undefined || amount === null) {
      return res.status(500).json({ error: "Payment amount is not defined" });
    }

    // Retrieve the logged-in user.
    const loggedInUser = req.user;
    if (!loggedInUser) {
      return res.status(401).json({ error: "User not authenticated" });
    }
    
    // Use loggedInUser._id and convert to a string.
    if (!loggedInUser._id) {
      return res.status(500).json({ error: "User ID is missing" });
    }
    const userId = loggedInUser._id.toString();

    // Generate a new order ID.
    const orderId = generateOrderId();

    // Process customer phone: Convert mobile number to string and trim to last 10 digits if needed.
    let customerPhoneRaw = loggedInUser.mobileNumber
      ? loggedInUser.mobileNumber.toString()
      : "0000000000";
    let customerPhone = customerPhoneRaw;
    if (customerPhoneRaw.length > 10) {
      customerPhone = customerPhoneRaw.substring(customerPhoneRaw.length - 10);
    }

    const requestData = {
      order_amount: amount.toString(),
      order_currency: "INR",
      order_id: orderId,
      customer_details: {
        customer_id: userId,
        customer_phone: customerPhone,
        customer_name: `${loggedInUser.firstName} ${loggedInUser.lastName}`,
        customer_email: loggedInUser.email,
      },
    };

    ///console.log("Request Data for Cashfree:", requestData);

    const response = await Cashfree.PGCreateOrder("2023-08-01", requestData);
    if (response && response.data) {
      // Set the initial status to "pending" rather than "created"
      const newUserPaymentOrder = new UserPaymentOrder({
        adminPaymentRequestId,
        orderId,
        amount,
        orderCurrency: "INR",
        customer: userId, // store the user reference
        paymentSessionId: response.data.payment_session_id,
        status: "pending",  // initial status set to pending
      });
      const savedOrder = await newUserPaymentOrder.save();

      // Optionally, mark the admin request as "used"
      adminRequest.status = "used";
      await adminRequest.save();

      return res.json({
        orderId: savedOrder.orderId,
        amount: savedOrder.amount,
        orderCurrency: savedOrder.orderCurrency,
        customer: {
          _id: userId,
          firstName: loggedInUser.firstName,
          lastName: loggedInUser.lastName,
          mobileNumber: loggedInUser.mobileNumber,
          email: loggedInUser.email,
        },
        paymentSessionId: savedOrder.paymentSessionId,
        status: savedOrder.status,
        createdAt: savedOrder.createdAt,
      });
    } else {
      return res.status(500).json({ error: "Empty response from Cashfree" });
    }
  } catch (error) {
    console.error("Error creating user payment order:", error.message);
    return res.status(500).json({ error: error.message });
  }
};

exports.verifyPayment = async (req, res) => {
  try {
    const { orderId } = req.body;
    if (!orderId) {
      return res.status(400).json({ error: "Order ID is required" });
    }

    const apiVersion = "2025-01-01";
    console.log("Fetching payments for Order ID:", orderId);
    const orderResponse = await Cashfree.PGOrderFetchPayments(apiVersion, orderId);
    console.log("Order Fetch Response:", orderResponse);

    if (!orderResponse || !orderResponse.data || orderResponse.data.length === 0) {
      return res.status(500).json({ error: "No payments found for this order" });
    }

    // Use the first payment details from the response.
    const paymentDetails = orderResponse.data[0];
    let newStatus;
    // Map Cashfree payment_status to our order status.
    if (paymentDetails.payment_status === "SUCCESS") {
      newStatus = "paid";
    } else if (paymentDetails.payment_status === "FAILED") {
      newStatus = "failed";
    } else if (paymentDetails.payment_status === "CANCELLED") {
      newStatus = "cancelled";
    } else {
      newStatus = "pending"; // Fallback if no recognized status is found.
    }

    // Update the order status in the database.
    const updatedOrder = await UserPaymentOrder.findOneAndUpdate(
      { orderId: orderId },
      { status: newStatus },
      { new: true }
    );

    if (!updatedOrder) {
      return res.status(404).json({ error: "Order not found" });
    }

    // If payment is successful and the wallet update hasn't been done yet, update the wallet.
    if (newStatus === "paid" && !updatedOrder.walletUpdated) {
      const wallet = await Wallet.findOne({ user: updatedOrder.customer });
      if (!wallet) {
        console.error(`No wallet found for user: ${updatedOrder.customer}`);
        return res.status(404).json({ error: "Wallet not found" });
      }

      // Convert amount to a number and update the mainBalance.
      const paymentAmount = Number(updatedOrder.amount);
      wallet.mainBalance += paymentAmount;
      await wallet.save();

      // Mark the order as wallet-updated to prevent duplicate crediting.
      updatedOrder.walletUpdated = true;
      await updatedOrder.save();

      console.log(`Wallet updated for user ${updatedOrder.customer}: Added ${paymentAmount} to mainBalance.`);
    }

    // -------------------------------
    // Create or update the Transaction record
    // -------------------------------
    try {
      // Fetch the wallet (if not already fetched above)
      const wallet = await Wallet.findOne({ user: updatedOrder.customer });
      if (!wallet) {
        console.error(`No wallet found for user: ${updatedOrder.customer}`);
        return res.status(404).json({ error: "Wallet not found" });
      }

      // Determine the transaction payment status based on our newStatus.
      let transactionPaymentStatus = "";
      if (newStatus === "paid") {
        transactionPaymentStatus = "success";
      } else if (newStatus === "failed" || newStatus === "cancelled") {
        transactionPaymentStatus = "failed";
      } else {
        transactionPaymentStatus = "pending";
      }


// Check if a transaction record already exists for this order.
const existingTransaction = await Transaction.findOne({ orderId: updatedOrder.orderId });
if (!existingTransaction) {
  // Fetch the wallet if not already fetched
  const wallet = await Wallet.findOne({ user: updatedOrder.customer });
  if (!wallet) {
    console.error(`No wallet found for user: ${updatedOrder.customer}`);
    return res.status(404).json({ error: "Wallet not found" });
  }

 // Convert the paymentMethod from paymentDetails to a string if it's an object.
let paymentMethodDetail = paymentDetails.payment_method;
if (typeof paymentMethodDetail === 'object') {
  // Either extract the detail you want or stringify the whole object.
  // For example, to extract the UPI id:
  //paymentMethodDetail = paymentMethodDetail.upi?.upi_id || "N/A";
  // Or simply stringify the object:
  paymentMethodDetail = JSON.stringify(paymentMethodDetail);
}

const paymentAmount = Number(updatedOrder.amount);
const newTransaction = new Transaction({
  user: updatedOrder.customer,
  wallet: wallet._id,
  orderId: updatedOrder.orderId,
  type: "Deposit", // Adjust if needed.
  amount: paymentAmount,
  playCoins: paymentAmount, // Adjust conversion if required.
  paymentType: "Wallet",  // Or derive this from paymentDetails if needed.
  paymentMethod: paymentMethodDetail, // Use the converted string here.
  paymentStatus: transactionPaymentStatus,
  remark: `Add To Wallet`,
});
await newTransaction.save();
console.log("Transaction record created:", newTransaction);

        console.log("Transaction record created:", newTransaction);
      } else {
        console.log("Transaction record already exists for orderId:", updatedOrder.orderId);
      }
    } catch (transactionError) {
      console.error("Error creating transaction record:", transactionError);
      // You might choose to continue (or handle the error) without failing the entire verification.
    }
    // -------------------------------
    // End Transaction Logging
    // -------------------------------

    console.log("Order updated with new status:", newStatus);
    return res.json({
      message: "Payment verified",
      order: updatedOrder,
      paymentDetails: paymentDetails
    });
  } catch (error) {
    console.error("Error verifying payment:", error.response?.data || error.message);
    return res.status(500).json({ error: error.response?.data || error.message });
  }
};



exports.cancelPaymentOrder = async (req, res) => {
  try {
    const { orderId } = req.body;
    if (!orderId) {
      return res.status(400).json({ error: "Order ID is required" });
    }

    const updatedOrder = await UserPaymentOrder.findOneAndUpdate(
      { orderId: orderId },
      { status: "cancelled" },
      { new: true }
    );
    if (!updatedOrder) {
      return res.status(404).json({ error: "Order not found" });
    }

    return res.json({
      message: "Order cancelled successfully",
      order: updatedOrder
    });
  } catch (error) {
    console.error("Error cancelling order:", error.message);
    return res.status(500).json({ error: error.message });
  }
};

exports.getOrders = async (req, res) => {
  try {
    // Retrieve all payment orders, sorted by creation date, and populate the "customer" field.
    const orders = await UserPaymentOrder.find({}).sort({ createdAt: -1 }).populate("customer");
    return res.json(orders);
  } catch (error) {
    console.error("Error fetching orders:", error.message);
    return res.status(500).json({ error: error.message });
  }
};

exports.getUserTransactions = async (req, res) => {
  try {
    // Assuming authentication middleware sets req.user with the user's data
    const userId = req.user._id;
    if (!userId) {
      return res.status(401).json({ error: "User not authenticated" });
    }

    // Fetch transactions for the user, sorted with the latest first.
    const transactions = await Transaction.find({ user: userId })
      .sort({ createdAt: -1 })
      .lean(); // lean() returns plain JavaScript objects (optional)

    return res.status(200).json({ transactions });
  } catch (error) {
    console.error("Error fetching transactions:", error);
    return res.status(500).json({ error: "Error fetching transactions" });
  }
};

exports.getUserWallatBalance = async (req, res) => {
  try {
    // Ensure the user is authenticated.
    const userId = req.user._id;
    if (!userId) {
      return res.status(401).json({ error: 'User not authenticated' });
    }

    // Find the wallet for the authenticated user.
    const wallet = await Wallet.findOne({ user: userId }).lean();
    if (!wallet) {
      return res.status(404).json({ error: 'Wallet not found' });
    }

    // Return only the relevant fields.
    return res.status(200).json({
      mainBalance: wallet.mainBalance,
      winningBalance: wallet.winningBalance,
      bonusBalance: wallet.bonusBalance,
      coinBalance: wallet.coinBalance,
      redeemBalance: wallet.redeemBalance,
      currency: wallet.currency,
      status: wallet.status,
      lastTransaction: wallet.lastTransaction,
      updatedAt: wallet.updatedAt
    });
  } catch (error) {
    console.error('Error fetching wallet balance:', error);
    return res.status(500).json({ error: 'Error fetching wallet balance' });
  }
};
