import 'package:flutter/material.dart';
import 'package:yodha_a/features/rule_set/screens/fetch_update_rulset_screen.dart';

class RulesetDropdownScreen extends StatefulWidget {
  const RulesetDropdownScreen({super.key});

  @override
  State<RulesetDropdownScreen> createState() => _RulesetDropdownScreenState();
}

class _RulesetDropdownScreenState extends State<RulesetDropdownScreen> {
  // Default category is set to 'FF SURVIVAL'
  String selectedCategory = 'FF SURVIVAL';

  // List of available categories.
  final List<String> eventCategories = [
    'FF SURVIVAL',
    'FF FULL MAP',
    'FF FUL MAP 2',
    'FF CS-OLD',
    'FF CS-NEW',
    'LONE WOLF',
    'BATTLE G.',
    'GTA'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Select Rules Category")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Dropdown for selecting a category.
            DropdownButton<String>(
              value: selectedCategory,
              icon: const Icon(Icons.keyboard_arrow_down, color: Colors.grey),
              items: eventCategories.map((String item) {
                return DropdownMenuItem<String>(
                  value: item,
                  child: Text(item, style: TextStyle(color: Colors.grey.shade400)),
                );
              }).toList(),
              onChanged: (String? newVal) {
                if (newVal != null) {
                  setState(() {
                    selectedCategory = newVal;
                  });
                }
              },
            ),
            const SizedBox(height: 20),
            // Button to view rules for the selected category.
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => FetchRulesetByCategoryScreen(category: selectedCategory),
                  ),
                );
              },
              child: const Text("View Rules"),
            ),
          ],
        ),
      ),
    );
  }
}
