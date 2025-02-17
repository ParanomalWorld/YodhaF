// server/controllers/cashfreeController.js
const crypto = require("crypto");
const { Cashfree } = require("cashfree-pg");
require("dotenv").config();
const PaymentRequest = require("../models/PaymentRequest");

// Set up Cashfree credentials and environment
Cashfree.XClientId = process.env.CLIENT_ID;
Cashfree.XClientSecret = process.env.CLIENT_SECRET;
Cashfree.XEnvironment = Cashfree.Environment.SANDBOX;

// Utility function to generate a unique order id
function generateOrderId() {
  return crypto.randomBytes(6).toString("hex").toUpperCase();
}

// Create Order Endpoint
exports.createOrder = async (req, res) => {
  try {
    const { amount, customerDetails } = req.body;
    if (!amount) {
      return res.status(400).json({ error: "Amount is required" });
    }

    const orderId = generateOrderId();
    const requestData = {
      order_amount: amount.toString(),
      order_currency: "INR",
      order_id: orderId,
      customer_details: {
        customer_id: customerDetails?.customer_id || "default_id",
        customer_phone: customerDetails?.customer_phone || "9999999999",
        customer_name: customerDetails?.customer_name || "Test User",
        customer_email: customerDetails?.customer_email || "test@example.com",
      },
    };

    const response = await Cashfree.PGCreateOrder("2023-08-01", requestData);
    if (response && response.data) {
      const newPaymentRequest = new PaymentRequest({
        orderId,
        amount,
        customerDetails: requestData.customer_details,
        paymentSessionId: response.data.payment_session_id,
        status: "created",
      });
      
      const savedRequest = await newPaymentRequest.save();
      res.json({
        orderId: savedRequest.orderId,
        amount: savedRequest.amount,
        orderCurrency: savedRequest.orderCurrency,
        customerDetails: savedRequest.customerDetails,
        paymentSessionId: savedRequest.paymentSessionId,
        status: savedRequest.status,
        createdAt: savedRequest.createdAt,
      });
    } else {
      res.status(500).json({ error: "Empty response from Cashfree" });
    }
  } catch (error) {
    console.error("Error creating order:", error.message);
    res.status(500).json({ error: error.message });
  }
};

// New: Get Orders Endpoint
exports.getOrders = async (req, res) => {
  try {
    // Retrieve all PaymentRequest documents sorted by creation date (newest first)
    const orders = await PaymentRequest.find({}).sort({ createdAt: -1 });
    res.json(orders);
  } catch (error) {
    console.error("Error fetching orders:", error.message);
    res.status(500).json({ error: error.message });
  }
};

// Verify Payment Endpoint (unchanged)
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

    const paymentDetails = orderResponse.data[0];
    console.log("Extracted payment details:", paymentDetails);
    return res.json(paymentDetails);
  } catch (error) {
    console.error("Error verifying payment:", error.response?.data || error.message);
    res.status(500).json({ error: error.response?.data || error.message });
  }
};
