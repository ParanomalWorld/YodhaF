// Example usage in Flutter:
import 'package:flutter/material.dart';
import 'package:yodha_a/features/rule_set/services/ruleset_service.dart';
import 'package:yodha_a/models/ruleset.dart';

class FetchRulesetByCategoryScreen extends StatefulWidget {
  final String category;
  const FetchRulesetByCategoryScreen({super.key, required this.category});

  @override
  // ignore: library_private_types_in_public_api
  _FetchRulesetByCategoryScreenState createState() => _FetchRulesetByCategoryScreenState();
}

class _FetchRulesetByCategoryScreenState extends State<FetchRulesetByCategoryScreen> {
  final RulesetService _rulesetService = RulesetService();
  Ruleset? _ruleset;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _fetchRuleset();
  }

  void _fetchRuleset() async {
    try {
      final ruleset = await _rulesetService.getRulesetByCategory(widget.category);
      setState(() {
        _ruleset = ruleset;
        _loading = false;
      });
    } catch (e) {
      setState(() {
        _loading = false;
      });
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading ruleset: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return Scaffold(
        appBar: AppBar(title: Text('Rules for ${widget.category}')),
        body: Center(child: CircularProgressIndicator()),
      );
    }
    if (_ruleset == null) {
      return Scaffold(
        appBar: AppBar(title: Text('Rules for ${widget.category}')),
        body: Center(child: Text('No rules found for ${widget.category}')),
      );
    }
    return Scaffold(
      appBar: AppBar(title: Text(_ruleset!.category)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Text(_ruleset!.content),
      ),
    );
  }
}
