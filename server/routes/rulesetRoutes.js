const express = require('express');
const router = express.Router();
const rulesetController = require('../controllers/rulesetController');
router.get('/category/:category', rulesetController.getRulesetByCategory);

// Create a new ruleset
router.post('/create', rulesetController.createRuleset);

// Update an existing ruleset
router.put('/:rulesetId', rulesetController.updateRuleset);

// Get all rulesets
router.get('/', rulesetController.getAllRulesets);

// Get a single ruleset by ID
router.get('/:rulesetId', rulesetController.getRulesetById);

// New Route: Get ruleset by category

module.exports = router;
