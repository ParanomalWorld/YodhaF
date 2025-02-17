const mongoose = require("mongoose");
const Wallet = require("../models/wallet");

/**
 * Update wallet balances based on operation type.
 * @param {String} userId - The ID of the user whose wallet to update.
 * @param {String} updateType - The type of update: "deposit", "win", "bonus", or "redeem".
 * @param {Number} amount - The amount to update.
 * @returns Updated wallet document.
 */
async function updateWallet(userId, updateType, amount) {
  // Start a session for a transaction
  const session = await mongoose.startSession();
  session.startTransaction();
  try {
    // Retrieve the wallet document
    const wallet = await Wallet.findOne({ user: userId }).session(session);
    if (!wallet) throw new Error("Wallet not found");

    // Update the corresponding field based on operation type
    switch (updateType) {
      case "deposit":
        wallet.mainBalance += amount;
        break;
      case "win":
        wallet.winningBalance += amount;
        break;
      case "bonus":
        wallet.bonusBalance += amount;
        break;
      case "redeem":
        // Optionally, check that the user has enough redeemable balance
        if (amount > wallet.coinBalance) {
          throw new Error("Insufficient coin balance for redemption");
        }
        wallet.redeemBalance += amount;
        break;
      default:
        throw new Error("Invalid update type");
    }

    // Saving the wallet document will trigger the pre-save hook to recalc coinBalance
    await wallet.save({ session });

    // Commit the transaction
    await session.commitTransaction();
    session.endSession();
    return wallet;
  } catch (err) {
    // Abort the transaction in case of error
    await session.abortTransaction();
    session.endSession();
    throw err;
  }
}

module.exports = { updateWallet };
