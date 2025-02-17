// services/rulesetService.js
const Ruleset = require('../models/Ruleset');

async function createRuleset(data) {
  const { category, content, version } = data;
  const ruleset = new Ruleset({ category, content, version });
  return await ruleset.save();
}

async function updateRuleset(rulesetId, data) {
  const { category, content, version } = data;
  return await Ruleset.findByIdAndUpdate(
    rulesetId,
    { category, content, version, updatedAt: Date.now() },
    { new: true }
  );
}

async function getAllRulesets() {
  return await Ruleset.find({});
}

async function getRulesetById(rulesetId) {
  return await Ruleset.findById(rulesetId);
}

// New function: get a ruleset by category.
async function getRulesetByCategory(category) {
  return await Ruleset.findOne({ category });
}

module.exports = {
  createRuleset,
  updateRuleset,
  getAllRulesets,
  getRulesetById,
  getRulesetByCategory, // Export the new function
};
