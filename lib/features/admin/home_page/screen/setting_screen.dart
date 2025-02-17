import 'package:flutter/material.dart';
import 'package:yodha_a/constants/global_variables.dart';
import 'package:yodha_a/features/admin/home_page/services/home_page_services.dart';
import 'package:yodha_a/features/admin/home_page/widgets/account_button.dart'; // Make sure the import path is correct.

class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  @override
  Widget build(BuildContext context) {
    final HomePageServices homePageServices = HomePageServices();
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(50),
        child: AppBar(
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: GlobalVariables.appBarGradient,
            ),
          ),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                alignment: Alignment.topLeft,
                child: Image.asset(
                  'assets/images/yodha_admin.png',
                  width: 120,
                  height: 45,
                  color: Colors.black,
                ),
              ),
              const Text(
                'Admin',
                style: TextStyle(
                  color: Color.fromARGB(255, 247, 245, 245),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            _buildButton(Icons.account_circle, "My Profile", onTap: () {}),
            _buildButton(Icons.account_balance_wallet, "My Wallet", onTap: () {}),
            _buildButton(Icons.leaderboard, "Top Players", onTap: () {}),
            _buildButton(Icons.notifications, "Notification", onTap: () {}),
            _buildButton(Icons.support_agent, "Contact Us", onTap: () {}),
            _buildButton(Icons.announcement, "Important Notice", onTap: () {}),
            _buildButton(Icons.help_outline, "FAQ", onTap: () {}),
            _buildButton(Icons.info, "About Us", onTap: () {}),
            _buildButton(Icons.privacy_tip, "Privacy Policy", onTap: () {}),
            _buildButton(Icons.rule, "Terms & Conditions", onTap: () {}),
            _buildButton(Icons.share, "Share App", onTap: () {}),
            _buildButton(Icons.logout, "Log Out", onTap: () {
              homePageServices.logOut(context); // Call the logOut method here.
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildButton(IconData icon, String text, {required VoidCallback onTap}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: AccountButton(
        text: text,
        icon: icon,
        onTap: onTap,
      ),
    );
  }
}
