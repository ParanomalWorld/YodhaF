import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:yodha_a/features/rule_set/screens/manage_ruleset_screen.dart';
import 'package:yodha_a/features/rule_set/screens/view_ruleset_screen.dart';

class ManageRulesScreens extends StatefulWidget {
  const ManageRulesScreens({super.key});

  @override
  State<ManageRulesScreens> createState() => _ManageRulesScreensState();
}

class _ManageRulesScreensState extends State<ManageRulesScreens> {
  void _navigateToScreen(Widget screen) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => screen),
    );
  }

  Widget _buildGlassyCard({
    required String title,
    required IconData icon,
    required Widget screen,
  }) {
    return GestureDetector(
      onTap: () => _navigateToScreen(screen),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12.0),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            height: 120,
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              // ignore: deprecated_member_use
              color: Colors.white.withOpacity(0.1),
              border: Border.all(
                // ignore: deprecated_member_use
                color: Colors.white.withOpacity(0.2),
                width: 1,
              ),
              boxShadow: [
                BoxShadow(
                  // ignore: deprecated_member_use
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 8,
                  offset: const Offset(4, 4),
                )
              ],
            ),
            child: Row(
              children: [
                Icon(icon, size: 40, color: Colors.white),
                const SizedBox(width: 20),
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                const Icon(Icons.arrow_forward_ios, color: Colors.white)
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Manage Rules"),
        backgroundColor: Colors.blueGrey[900],
      ),
      backgroundColor: Colors.blueGrey[900],
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildGlassyCard(
              title: "Create Rulesets",
              icon: Icons.settings,
              screen: const ManageRulesetScreen(),
            ),
            _buildGlassyCard(
              title: "View Rules",
              icon: Icons.visibility,
              screen: const ViewRulesetScreen(),
            ),
          ],
        ),
      ),
    );
  }
}
