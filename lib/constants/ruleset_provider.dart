// providers/ruleset_provider.dart
import 'package:flutter/material.dart';

class RulesetProvider extends ChangeNotifier {
  // Define any properties and methods you need for managing rulesets.
  // For example:
  String _exampleData = "Initial Data";

  String get exampleData => _exampleData;

  void updateData(String newData) {
    _exampleData = newData;
    notifyListeners();
  }
}
