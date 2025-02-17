// IMPORT PACKAGES
require('dotenv').config(); // Load environment variables
const express = require("express");
const mongoose = require("mongoose");
const bodyParser = require("body-parser");

const PORT = process.env.PORT || 8000;
const DB = process.env.MONGO_URI; // MongoDB connection string

// Check if MONGO_URI is properly loaded
if (!DB) {
    console.error("MONGO_URI is not defined in the environment variables.");
    process.exit(1); // Stop execution if the database URI is missing
}

// INITIALIZE APP
const app = express();

// IMPORT ROUTES
const authRouter = require("./routes/auth");
const adminRouter = require("./routes/admin");
const categoryEventRouter = require("./routes/event");
const userRouter = require("./routes/user");
const adminPaymentRoutes = require("./routes/adminPaymentRoutes");
const userPaymentRoutes = require("./routes/userPaymentRoutes");
//const cashfreeRouter = require("./routes/cashfreeRoutes");


const walletRoutes = require("./routes/walletRoutes");
const webhookRoutes = require("./routes/webhook");
//const paymentRoutes = require("./routes/paymentRoutes");
const rulesetRoutes = require('./routes/rulesetRoutes');// MIDDLEWARES
//app.use(express.json()); // Parse JSON requests
app.use(express.json({
    verify: (req, res, buf) => {
      req.rawBody = buf.toString('utf8');
    }
  }));
app.use(bodyParser.json()); // Body parser middleware
app.use(authRouter);
app.use(userRouter);
app.use(adminRouter);
app.use(categoryEventRouter);
app.use("/api/cashfree", adminPaymentRoutes);
app.use("/api/cashfree", userPaymentRoutes);
// Mount the webhook routes
app.use("/cashfree", webhookRoutes);
//app.use('/api/cashfree', cashfreeRouter); // Cashfree routes mounted here

app.use(walletRoutes);
app.use('/rulesets', rulesetRoutes);

//app.use(paymentRoutes);


// DATABASE CONNECTION
mongoose
    .connect(DB) // No need for extra options in Mongoose 6+
    .then(() => {
        console.log("Mongoose Connection Successful");
    })
    .catch((e) => {
        console.error("Mongoose Connection Error:", e);
    });


// START SERVER
app.listen(PORT, "0.0.0.0", () => {
    console.log(`Connected at port ${PORT}`);
});
