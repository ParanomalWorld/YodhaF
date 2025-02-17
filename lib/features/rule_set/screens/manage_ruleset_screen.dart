import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yodha_a/features/rule_set/services/ruleset_service.dart';

class ManageRulesetScreen extends StatefulWidget {
  static const routeName = '/manage-ruleset';
  const ManageRulesetScreen({super.key});

  @override
  State<ManageRulesetScreen> createState() => _ManageRulesetScreenState();
}

class _ManageRulesetScreenState extends State<ManageRulesetScreen> {
  // Define the list of available categories.
  final List<String> _categories = [
    'FF SURVIVAL',
    'FF FULL MAP',
    'FF FUL MAP 2',
    'FF CS-OLD',
    'FF CS-NEW',
    'LONE WOLF',
    'BATTLE G.',
    'GTA',
  ];

  // Selected category from dropdown.
  String? _selectedCategory;

  // Controller for content input.
  final TextEditingController _contentController = TextEditingController();

  void _createRuleset(BuildContext context) async {
    try {
      final category = _selectedCategory;
      final content = _contentController.text.trim();
      if (category == null || category.isEmpty || content.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please select a category and enter content.'),
          ),
        );
        return;
      }
      final rulesetService =
          Provider.of<RulesetService>(context, listen: false);
      final created = await rulesetService.createRuleset(category, content);
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Ruleset Created: ${created.id}')),
      );
      setState(() {
        _selectedCategory = null; // Reset dropdown selection.
      });
      _contentController.clear();
    } catch (e) {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  @override
  void dispose() {
    _contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Ruleset'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          elevation: 4,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                // Dropdown for selecting a category.
                DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                    labelText: 'Category',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    filled: true,
                    fillColor: Colors.grey[50],
                  ),
                  value: _selectedCategory,
                  items: _categories.map((String category) {
                    return DropdownMenuItem<String>(
                      value: category,
                      child: Text(category),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedCategory = newValue;
                    });
                  },
                ),
                const SizedBox(height: 16),
                // Multiline text field for rules content.
                TextField(
                  controller: _contentController,
                  decoration: InputDecoration(
                    labelText: 'Content (HTML/Markdown)',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    filled: true,
                    fillColor: Colors.grey[50],
                  ),
                  maxLines: 10,
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => _createRuleset(context),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      'Create Ruleset',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
