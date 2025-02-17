import 'package:flutter/material.dart';
import 'package:yodha_a/features/rule_set/services/ruleset_service.dart';
import 'package:yodha_a/models/ruleset.dart';
import 'package:yodha_a/features/rule_set/screens/widgets/update_ruleset_screen.dart';
import 'widgets/rulset_ui_box.dart';

class ViewRulesetScreen extends StatefulWidget {
  const ViewRulesetScreen({super.key});

  @override
  State<ViewRulesetScreen> createState() => _ViewRulesetScreenState();
}

class _ViewRulesetScreenState extends State<ViewRulesetScreen> {
  final RulesetService _rulesetService = RulesetService();
  List<Ruleset>? _rulesets;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _fetchAllRulesets();
  }

  Future<void> _fetchAllRulesets() async {
    try {
      final rulesets = await _rulesetService.getAllRulesets();
      setState(() {
        _rulesets = rulesets;
        _loading = false;
      });
    } catch (e) {
      setState(() => _loading = false);
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching rulesets: $e')),
      );
    }
  }

  void _navigateToDetail(Ruleset ruleset) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => RulesetDetailScreen(ruleset: ruleset),
      ),
    );
  }

  void _navigateToUpdate(Ruleset ruleset) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => UpdateRulesetScreen(ruleset: ruleset),
      ),
    ).then((_) => _fetchAllRulesets()); // Refresh list after update
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return Scaffold(
        appBar: AppBar(title: const Text('Rulesets')),
        body: const Center(child: CircularProgressIndicator()),
      );
    }
    if (_rulesets == null || _rulesets!.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: const Text('Rulesets')),
        body: const Center(child: Text('No rulesets found')),
      );
    }
    return Scaffold(
      appBar: AppBar(title: const Text('Rulesets')),
      body: ListView.builder(
        itemCount: _rulesets!.length,
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        itemBuilder: (context, index) {
          final ruleset = _rulesets![index];
          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(
                vertical: 12,
                horizontal: 16,
              ),
              leading: CircleAvatar(
                backgroundColor: Colors.blue.shade100,
                child: Text(
                  ruleset.category.substring(0, 1).toUpperCase(),
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                ),
              ),
              title: Text(
                ruleset.category,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Text('Version: ${ruleset.version}'),
              trailing: IconButton(
                icon: const Icon(Icons.edit, color: Colors.blue),
                onPressed: () => _navigateToUpdate(ruleset),
              ),
              onTap: () => _navigateToDetail(ruleset),
            ),
          );
        },
      ),
    );
  }
}
