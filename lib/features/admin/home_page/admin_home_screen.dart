import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:yodha_a/constants/ruleset_provider.dart';
import 'package:yodha_a/features/admin/home_page/screen/add_event_screen.dart';
import 'package:yodha_a/features/admin/home_page/screen/event_category_screen/screen/home_category_screen.dart';
import 'package:yodha_a/features/admin/home_page/screen/rule_set/screens/manage_rules_screens.dart';
import 'package:yodha_a/features/admin/home_page/screen/user_search_screen/screen/search_userId_screen.dart';
import 'package:yodha_a/features/admin/home_page/screen/setting_screen.dart';
import 'package:yodha_a/features/rule_set/screens/manage_ruleset_screen.dart';
import 'package:provider/provider.dart';

class AdminHomeScreen extends StatefulWidget {
  const AdminHomeScreen({super.key});

  @override
  State<AdminHomeScreen> createState() => _AdminHomeScreenState();
}

class _AdminHomeScreenState extends State<AdminHomeScreen> {
  void _navigateToScreen(BuildContext context, Widget screen) {
    if (screen is ManageRulesetScreen) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ChangeNotifierProvider(
            create: (_) => RulesetProvider(), // Ensure RulesetProvider is defined
            child: screen,
          ),
        ),
      );
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => screen),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Admin Home')),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              _buildTile(context, 'Create Event', Icons.create, const AddEventScreen(), Colors.pinkAccent),
              _buildTile(context, 'Published Events', Icons.publish, const HomeCategoryScreen(), Colors.blueAccent),
              _buildTile(context, 'Search User', Icons.search, const SearchUseridScreen(), Colors.redAccent),
              _buildTile(context, 'Manage Rules', Icons.rule, const ManageRulesScreens(), Colors.orangeAccent),
              _buildTile(context, 'Settings', Icons.settings, const SettingScreen(), Colors.greenAccent),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTile(BuildContext context, String title, IconData icon, Widget screen, Color color) {
    return GestureDetector(
      onTap: () => _navigateToScreen(context, screen),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12.0),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 8.0),
            height: 100,
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
              // ignore: deprecated_member_use
              color: Colors.white.withOpacity(0.1),
              boxShadow: [
                BoxShadow(
                  // ignore: deprecated_member_use
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 10,
                  offset: const Offset(4, 4),
                ),
              ],
            ),
            child: Row(
              children: [
                Icon(icon, color: Colors.white, size: 30),
                const SizedBox(width: 16),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
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
