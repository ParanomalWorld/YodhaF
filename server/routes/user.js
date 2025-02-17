const express = require("express");
const mongoose = require("mongoose");
const { Event } = require("../models/event"); // Import the Event model
const User = require("../models/user"); // Import the User model
const auth = require("../middleware/auth"); // Import authentication middleware
const Wallet = require("../models/wallet"); // Require the Wallet model
const userRouter = express.Router();

 //-----------------------------------------------------------------
//FETCH EVENT ALL THE DATA
userRouter.get('/api/get-userinfo', auth, async (req, res) => {

        try {
           // console.log(req.query.category);
            const getUserData = await User.find({ });
            res.json(getUserData);
            
        } catch (e) {
            res.status(500).json({error: e.message});
            
        }
      });


// // Route to lock a slot in an event

userRouter.patch("/update-slot/:eventId/:slotId", auth, async (req, res) => {
  const { eventId, slotId } = req.params;
  const { isBooked, userMsg } = req.body;
  
  // Use req.user (a string) from auth middleware.
  const authenticatedUserId = req.user;
  
  // Validate: if booking, ensure userMsg (extra details) is provided.
  if (isBooked && (!userMsg || userMsg.trim() === "")) {
    return res.status(400).json({ message: "Player details are required when booking a slot." });
  }
  
  const session = await mongoose.startSession();
  session.startTransaction();
  
  try {
    // 1. Retrieve the event document.
    const event = await Event.findById(eventId).session(session);
    if (!event) {
      await session.abortTransaction();
      session.endSession();
      return res.status(404).json({ message: "Event not found" });
    }
  
    // 2. Locate the specific slot using its subdocument id.
    const slot = event.slots.id(slotId);
    if (!slot) {
      await session.abortTransaction();
      session.endSession();
      return res.status(404).json({ message: "Slot not found" });
    }
  
    if (isBooked) {
      // 3. Check if the slot is already booked.
      if (slot.isBooked) {
        await session.abortTransaction();
        session.endSession();
        return res.status(400).json({ message: "Slot already booked" });
      }
  
      // 4. Retrieve the authenticated user's wallet.
      const wallet = await Wallet.findOne({ user: authenticatedUserId }).session(session);
      if (!wallet) {
        await session.abortTransaction();
        session.endSession();
        return res.status(404).json({ message: "Wallet not found" });
      }
  
      // 5. Check if the wallet has sufficient coin balance.
      if (wallet.coinBalance < event.entryFee) {
        await session.abortTransaction();
        session.endSession();
        return res.status(400).json({ message: "Insufficient coin balance. Please add coins to your wallet." });
      }
  
      // 6. Deduct the entry fee by increasing redeemBalance.
      wallet.redeemBalance += event.entryFee;
      await wallet.save({ session });
  
      // 7. Update the slot values.
      slot.isBooked = true;
      slot.userId = new mongoose.Types.ObjectId(authenticatedUserId);
      slot.userMsg = userMsg;
    } else {
      // For unbooking:
      slot.isBooked = false;
      slot.userId = null;
      slot.userMsg = null;
    }
  
    // Mark the 'slots' field as modified and save the event.
    event.markModified("slots");
    await event.save({ session });
  
    // Commit the transaction.
    await session.commitTransaction();
    session.endSession();
  
    return res.status(200).json({ message: "Slot updated successfully", event });
  } catch (error) {
    await session.abortTransaction();
    session.endSession();
    console.error("Error updating slot:", error);
    return res.status(500).json({ message: "Error updating slot", error: error.message });
  }
});

//-------------------
userRouter.get("/api/booked-slots/:eventId", auth, async (req, res) => {
  try {
    const { eventId } = req.params;

    if (!mongoose.Types.ObjectId.isValid(eventId)) {
      return res.status(400).json({ message: "Invalid eventId" });
    }

    const event = await Event.findById(eventId).select("slots");

    if (!event) {
      return res.status(404).json({ message: "Event not found" });
    }

    // Filter booked slots with userMsg
    const bookedSlots = event.slots
      .filter(slot => slot.isBooked && slot.userId)
      .map(slot => ({
        slotNumber: slot.slotNumber,
        userId: slot.userId,
        userMsg: slot.userMsg || "", // ✅ Include userMsg
      }));

    const slotCount = event.slots.length;
    const bookedCount = bookedSlots.length;

    return res.status(200).json({
      bookedSlots,
      slotCount,
      bookedCount
    });

  } catch (error) {
    console.error("Error fetching booked slots:", error);
    return res.status(500).json({ message: "Error fetching booked slots", error: error.message });
  }
});

//-------------------------

// GET route to fetch only the authenticated user's profile
userRouter.get('/api/user/profile', auth, async (req, res) => {
  try {
    // Log the authenticated user (should be the user's ID as a string)
    console.log("Authenticated user from middleware:", req.user);

    // Since req.user is a string (the user's ID), use it directly in findById.
    const user = await User.findById(req.user)
      .select('_id firstName lastName userName mobileNumber')
      .lean();

    console.log("Fetched user from DB:", user);

    if (!user) {
      return res.status(404).json({ message: "User not found" });
    }

    res.json(user);
  } catch (error) {
    console.error("Error in profile route:", error);
    res.status(500).json({ error: error.message });
  }
});


module.exports = userRouter;