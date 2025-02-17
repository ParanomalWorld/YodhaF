const express = require('express');
const categoryEventRouter = express.Router();
//const admin = require("../middleware/admin");
const auth = require("../middleware/auth");
const ruleset = require("../models/Ruleset");
const { Event } = require("../models/event");


//-----------------------------------------------------------------
//FETCH EVENT ALL THE DATA

categoryEventRouter.get('/api/get-eventinfo', auth, async(req, res) => {
    try {
       // console.log(req.query.category);
        //const getEvent = await Event.find({category: req.query.category});
        const getEvent = await Event.find({ category: req.query.category }).populate('ruleset');

        res.json(getEvent);
        
    } catch (e) {
        res.status(500).json({error: e.message});
        
    }
});


categoryEventRouter.get("/api/get-event-slot-info", auth, async (req, res) => {
  try {
    //const event = await Event.findById(req.query.eventId); // Find by MongoDB _id
    const event = await Event.findById(req.query.eventId).populate('ruleset'); // with populate

    if (!event) {
      return res.status(404).json({ message: "Event not found" });
    }
    res.json(event); // Return the event slot details
  } catch (e) {
    console.error(e);
    res.status(500).json({ error: e.message });
  }
});


// In your categoryEventRouter file
// categoryEventRouter.get('/api/booked-slots/:eventId', auth, async (req, res) => {
//   try {
//     // Use lean() to return a plain object
//     const event = await Event.findById(req.params.eventId).lean();
//     if (!event) {
//       return res.status(404).json({ message: "Event not found" });
//     }
//     // Filter out only the booked slots (they should now include userMsg)
//     const bookedSlots = event.slots.filter(slot => slot.isBooked);
//     console.log("Booked Slots from DB:", bookedSlots); // Debug log
//     res.json({
//       bookedSlots,
//       slotCount: event.slotCount,
//       bookedCount: bookedSlots.length,
//     });
//   } catch (error) {
//     res.status(500).json({ error: error.message });
//   }
//});






module.exports = categoryEventRouter;
