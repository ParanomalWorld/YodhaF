const mongoose = require("mongoose");

const eventSchema = mongoose.Schema({
  eventName: {
    type: String,
    required: true,
    trim: true,
  },
  eventType: {
    type: String,
    required: true,
    trim: true,
  },
  pricePool: {
    type: Number,
    required: true,
  },
  perKill: {
    type: Number,
    required: true,
  },
  entryFee: {
    type: Number,
    required: true,
  },
  gameMode: {
    type: String,
    required: true,
  },
  versionSelect: {
    // Fixed typo
    type: String,
    required: true,
  },
  mapType: {
    type: String,
    required: true,
  },
  eventDate: {
    type: String,
    required: true,
  },
  eventTime: {
    type: String,
    required: true,
  },
  category: {
    type: String,
    required: true,
  },
   // Here's the new reference to the Ruleset
   ruleset: {
    type: mongoose.Schema.Types.ObjectId,
    ref: "Ruleset", // must match the model name
    required: false, // or 'true' if you always must have a ruleset
  },
  images: [
    {
      type: String,
      required: true,
    },
  ],
  slots: [
    {
      slotNumber: {
        type: Number,
        required: true,
      },
      isBooked: {
        type: Boolean,
        default: false,
      },
      userId: {
        type: mongoose.Schema.Types.ObjectId,
        ref: "User",
        validate: {
          validator: function (value) {
            return this.isBooked ? !!value : true;
          },
          message: 'UserId is required if slot is booked',
        },
      },
      
      
      
       // New field for extra details entered by the user
       userMsg: {
        type: String,
        trim: true,
        // Optionally, you can require this when booking:
        // required: function() { return this.isBooked; },
      },
      userObjectId: {
        type: String,
        trim: true,
        // Optionally, you can require this when booking:
        // required: function() { return this.isBooked; },
      },
    },
  ],
  
  slotCount: {
    // Corrected name for consistency
    type: Number,
    required: true,
    default: 0, // Default to 0, updated dynamically
  },
});

const Event = mongoose.model("Event", eventSchema);
module.exports = { Event, eventSchema };