import 'package:flutter/material.dart';
import 'package:yodha_a/features/account/services/account_services.dart';
import 'package:yodha_a/features/account/widgets/account_button.dart';
import 'package:yodha_a/features/home/screens/account_categories_screen/home_profile_screen.dart';
import 'package:yodha_a/features/wallet/screens/wallat_screen.dart';

class TopButtons extends StatelessWidget {
  const TopButtons({super.key});

  @override
  Widget build(BuildContext context) {
    final AccountServices accountServices =
        AccountServices(); // Create an instance of AccountServices.

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        children: [
          _buildButton(
            Icons.account_circle,
            "My Profile",
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const HomeProfileScreen()),
              );
            },
          ),


          _buildButton(Icons.account_balance_wallet, "My Wallet",
              onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const WalletScreen()),
              );
            },
          ),
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
            accountServices.logOut(context); // Call the logOut method here.
          }),
        ],
      ),
    );
  }

  Widget _buildButton(IconData icon, String text,
      {required VoidCallback onTap}) {
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
