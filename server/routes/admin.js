const express = require("express");
const adminRouter = express.Router();
const admin = require("../middleware/admin");
const { Event } = require("../models/event");
const User = require("../models/user");
const Wallet = require("../models/wallet");
const auth = require("../middleware/auth");
const Ruleset = require("../models/Ruleset");



//ADD EVENT
adminRouter.post("/admin/add-tournament", admin, async (req, res) => {
    try {
        const {
          eventName,
          eventType,
          pricePool,
          perKill,
          entryFee,
          gameMode,
          category,
          versionSelect, // Fixed typo
          mapType,
          eventDate,
          eventTime,
          images,
          slotCount, // Ensure this matches the schema
        } = req.body;
    
        // Generate slots dynamically if `slotCount` is provided
        const slots = Array.from({ length: slotCount || 0 }, (_, i) => ({
          slotNumber: i + 1,
        }));

          // --- New Code Start: Lookup the matching ruleset based on category ---
    const rulesetDoc = await Ruleset.findOne({ category });
    if (!rulesetDoc) {
      return res
        .status(400)
        .json({ error: `No ruleset found for category ${category}` });
    }
    // --- New Code End ---
    
        const event = new Event({
          eventName,
          eventType,
          pricePool,
          perKill,
          entryFee,
          gameMode,
          category,
          versionSelect,
          mapType,
          eventDate,
          eventTime,
          images,
          slots,
          slotCount: slots.length, // Set slotCount based on the number of generated slots
          ruleset: rulesetDoc._id, // Connect the event with the corresponding ruleset

        });
    
        await event.save();
        res.json(event);
      } catch (e) {
        res.status(500).json({ error: e.message });
      }
    });
    
//-----------------------------------------------------------------
//FETCH EVENT ALL THE DATA

adminRouter.get("/admin/get-eventinfo", admin, async (req, res) => {
  try {
    const getEvent = await Event.find({});
    res.json(getEvent);
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
});

//DELETE EVENT ALL THE DATA
adminRouter.post("/admin/delete-event", admin, async (req, res) => {
  try {
    const { id } = req.body;
    let eventDelete = await Event.findByIdAndDelete(id);

    res.json(eventDelete);
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
});

//-----------------------------------------------------------------
//FETCH USER ALL THE DATA

adminRouter.get("/api/get-userinfoInAdmin", auth, async (req, res) => {
  try {
    // console.log(req.query.category);
    const getUserData = await User.find({});
    res.json(getUserData);
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
});

//-----------------------------------------------------------------
//FETCH USER THE DATA

adminRouter.get("/api/get-userId/search/:email", auth, async (req, res) => {
  try {
    // console.log(req.query.category);
    const getUserEmail = await User.find({
      email: { $regex: req.params.email, $options: "i" },
    });
    res.json(getUserEmail);
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
});
//-----------------------------------------------------------------
//UPDATE EVENT DATA ADMIN


adminRouter.patch('/api/update-event-admin/:eventId', async (req, res) => {
  try {
      const eventId = req.params.eventId;
      let updatedFields = req.body; // Fields to update

      const existingEvent = await Event.findById(eventId);
      if (!existingEvent) {
          return res.status(404).json({ message: "Event not found" });
      }

      // If slotCount is updated, regenerate slots
      if (updatedFields.slotCount !== undefined) {
          const newSlotCount = parseInt(updatedFields.slotCount, 10) || 0;

          // Generate new slots dynamically
          updatedFields.slots = Array.from({ length: newSlotCount }, (_, i) => ({
              slotNumber: i + 1,
          }));
      }

      const updatedEvent = await Event.findByIdAndUpdate(eventId, updatedFields, { new: true });

      res.status(200).json(updatedEvent);
  } catch (error) {
      res.status(500).json({ message: "Error updating event", error });
  }
});
  //-----------------------------------------------------------------
  //FETCH USER DATA FROM DATABASE
  // PATCH /api/update-wallet-admin
// Updates only winningBalance and redeemBalance for a user's wallet incrementally.
adminRouter.patch("/api/update-wallet-admin", auth, admin, async (req, res) => {
  try {
    // Expect userId and optionally increments for winningBalance and redeemBalance in the body
    const { userId, winningBalance, redeemBalance } = req.body;
    if (!userId) {
      return res.status(400).json({ error: "User ID is required" });
    }

    // Validate that the provided increments are numbers, if provided.
    if (winningBalance !== undefined && typeof winningBalance !== "number") {
      return res.status(400).json({ error: "winningBalance must be a number" });
    }
    if (redeemBalance !== undefined && typeof redeemBalance !== "number") {
      return res.status(400).json({ error: "redeemBalance must be a number" });
    }

    // If no increments are provided, there's nothing to update.
    if (winningBalance === undefined && redeemBalance === undefined) {
      return res.status(400).json({ error: "No valid fields to update" });
    }

    // Find the wallet associated with the user.
    const wallet = await Wallet.findOne({ user: userId });
    if (!wallet) {
      return res.status(404).json({ error: "Wallet not found" });
    }

    // Increment the allowed fields instead of replacing them.
    if (winningBalance !== undefined) {
      wallet.winningBalance += winningBalance;
    }
    if (redeemBalance !== undefined) {
      wallet.redeemBalance += redeemBalance;
    }

    // Save the wallet document (the pre-save hook recalculates coinBalance).
    await wallet.save();

    res.json({ message: "Wallet updated successfully", wallet });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});


//---------------
// GET route to fetch a user's wallet balance
// Endpoint: /api/admin/user-wallet-balance/:userId
adminRouter.get("/api/admin/user-wallet-balance/:userId", auth, admin, async (req, res) => {
  try {
    let wallet = await Wallet.findOne({ user: req.params.userId });
    if (!wallet) {
      // Optionally, create a default wallet if one is not found:
      wallet = new Wallet({
        user: req.params.userId,
        mainBalance: 0,
        winningBalance: 0,
        bonusBalance: 0,
        coinBalance: 0,
        redeemBalance: 0,
      });
      await wallet.save();
    }
    res.json(wallet);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

module.exports = adminRouter;
