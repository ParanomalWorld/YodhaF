const mongoose = require("mongoose");

const userSchema = mongoose.Schema({
  firstName: {
    required: true,
    type: String,
    trim: true,
  },
  lastName: {
    required: true,
    type: String,
    trim: true,
  },
  userName: {
    required: true,
    type: String,
    trim: true,
  },
  mobileNumber: {
    required: true,
    type: Number,
    trim: true,
  },
  email: {
    required: true,
    type: String,
    trim: true,
    unique: true, 
    validate: {
      validator: (value) => {
        const re =
          /^(([^<>()[\]\.,;:\s@\"]+(\.[^<>()[\]\.,;:\s@\"]+)*)|(\".+\"))@(([^<>()[\]\.,;:\s@\"]+\.)+[^<>()[\]\.,;:\s@\"]{2,})$/i;
        return value.match(re);
      },
     // message: "Please enter a valid email address",
     message: (props) => `${props.value} is not a valid email address!`,

    },
  },
  password: {
    required: true,
    type: String,
  },
  address: {
    type: String,
    default: "",
  },  
  userId: {
    type: String,
    default: "",
  },
  type: {
    type: String,
    default: "user",
  },
  wallet: {
    type: mongoose.Schema.Types.ObjectId,
    ref: "Wallet", // Connects to the Wallet schema
  },
 
}, { 
  timestamps: true // Automatically creates createdAt and updatedAt
});

const User = mongoose.model("User", userSchema);
module.exports = User;