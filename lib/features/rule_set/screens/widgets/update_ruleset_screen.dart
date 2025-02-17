import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yodha_a/features/rule_set/services/ruleset_service.dart';
import 'package:yodha_a/models/ruleset.dart';

class UpdateRulesetScreen extends StatefulWidget {
  final Ruleset ruleset;
  const UpdateRulesetScreen({super.key, required this.ruleset});

  @override
  State<UpdateRulesetScreen> createState() => _UpdateRulesetScreenState();
}

class _UpdateRulesetScreenState extends State<UpdateRulesetScreen> {
  late TextEditingController _categoryController;
  late TextEditingController _contentController;
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    _categoryController = TextEditingController(text: widget.ruleset.category);
    _contentController = TextEditingController(text: widget.ruleset.content);
  }

  void _updateRuleset() async {
    setState(() => _loading = true);
    try {
      // Create the updated ruleset with incremented version
      final updatedRuleset = Ruleset(
        id: widget.ruleset.id,
        category: _categoryController.text.trim(),
        content: _contentController.text.trim(),
        version: widget.ruleset.version + 1, // Increment version
      );
      final rulesetService =
          Provider.of<RulesetService>(context, listen: false);
      await rulesetService.updateRuleset(updatedRuleset);

      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Ruleset Updated Successfully')),
      );
      // ignore: use_build_context_synchronously
      Navigator.pop(context, true); // Return to previous screen
    } catch (e) {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    } finally {
      setState(() => _loading = false);
    }
  }

  @override
  void dispose() {
    _categoryController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Update Ruleset')),
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
                // Category text field.
                TextField(
                  controller: _categoryController,
                  decoration: InputDecoration(
                    labelText: 'Category',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    filled: true,
                    fillColor: Colors.grey[50],
                  ),
                ),
                const SizedBox(height: 16),
                // Content text field.
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
                // Update button.
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _loading ? null : _updateRuleset,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: _loading
                        ? const CircularProgressIndicator(
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.white),
                          )
                        : const Text(
                            'Update Ruleset',
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
