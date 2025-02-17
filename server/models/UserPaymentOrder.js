const mongoose = require("mongoose");

const UserPaymentOrderSchema = new mongoose.Schema({
  adminPaymentRequestId: { 
    type: mongoose.Schema.Types.ObjectId, 
    ref: "AdminPaymentRequest",
    required: true 
  },
  orderId: { 
    type: String, 
    required: true ,
    unique: true,
  },
  amount: { 
    type: Number, 
    required: true 
  },
  orderCurrency: { 
    type: String, 
    default: "INR" 
  },
  // Direct reference to the User schema
  customer: {
    type: mongoose.Schema.Types.ObjectId,
    ref: "User",
    required: true
  },
  paymentSessionId: { 
    type: String, 
    required: true 
  },
  status: { 
    type: String, 
    default: "created" 
  },
  // New field to ensure wallet is updated only once.
  walletUpdated: { 
    type: Boolean,
    default: false 
  },
}, { 
  timestamps: true 
});

module.exports = mongoose.model("UserPaymentOrder", UserPaymentOrderSchema);
