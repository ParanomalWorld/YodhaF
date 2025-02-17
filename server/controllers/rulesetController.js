// controllers/rulesetController.js
const rulesetService = require('../services/rulesetService');

exports.createRuleset = async (req, res) => {
  try {
    const ruleset = await rulesetService.createRuleset(req.body);
    return res.status(201).json(ruleset);
  } catch (error) {
    return res.status(400).json({ error: error.message });
  }
};

exports.updateRuleset = async (req, res) => {
  try {
    const { rulesetId } = req.params;
    const updated = await rulesetService.updateRuleset(rulesetId, req.body);
    if (!updated) {
      return res.status(404).json({ message: 'Ruleset not found' });
    }
    return res.json(updated);
  } catch (error) {
    return res.status(400).json({ error: error.message });
  }
};

exports.getAllRulesets = async (req, res) => {
  try {
    const rulesets = await rulesetService.getAllRulesets();
    return res.json(rulesets);
  } catch (error) {
    return res.status(400).json({ error: error.message });
  }
};

exports.getRulesetById = async (req, res) => {
  try {
    const { rulesetId } = req.params;
    const ruleset = await rulesetService.getRulesetById(rulesetId);
    if (!ruleset) {
      return res.status(404).json({ message: 'Ruleset not found' });
    }
    return res.json(ruleset);
  } catch (error) {
    return res.status(400).json({ error: error.message });
  }
};

// New Controller: Get ruleset by category
exports.getRulesetByCategory = async (req, res) => {
  try {
    const { category } = req.params;
    const ruleset = await rulesetService.getRulesetByCategory(category);
    if (!ruleset) {
      return res.status(404).json({ message: 'Ruleset not found' });
    }
    return res.json(ruleset);
  } catch (error) {
    return res.status(400).json({ error: error.message });
  }
};
