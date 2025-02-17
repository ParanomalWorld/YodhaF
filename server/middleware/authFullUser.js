// server/middleware/authFullUser.js
const jwt = require("jsonwebtoken");
const User = require("../models/user"); // Use the correct file path and case

const authFullUser = async (req, res, next) => {
  try {
    const token = req.header("x-auth-token");
    if (!token)
      return res.status(401).json({ msg: "No auth token, access denied" });

    const verified = jwt.verify(token, process.env.JWT_SECRET || "passwordKey");
    //console.log("DEBUG: verified token payload:", verified);
    if (!verified || !verified.id)
      return res
        .status(401)
        .json({ msg: "Token verification failed, authorization denied." });

    // Fetch the full user document from the database.
    const user = await User.findById(verified.id);
    if (!user)
      return res.status(401).json({ msg: "User not found, authorization denied." });

    req.user = user; // Now req.user is the full user document
    next();
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
};

module.exports = authFullUser;
