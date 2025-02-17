import 'package:flutter/material.dart';
import 'package:yodha_a/features/home/screens/account_categories_screen/home_contactus_screen.dart';
import 'package:yodha_a/features/home/screens/account_categories_screen/home_profile_screen.dart';
import 'package:yodha_a/features/wallet/screens/wallat_screen.dart';

class AccountCategoriesBox extends StatelessWidget {
  const AccountCategoriesBox({super.key});

  void navigateToHomeProfileScreen(BuildContext context) {
    Navigator.pushNamed(context, HomeProfileScreen.routeName);
  }



  void navigateToHomeContactUs(BuildContext context) {
    Navigator.pushNamed(context, HomeContactusScreen.routeName);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title: Account Details
          const Padding(
            padding: EdgeInsets.only(bottom: 10.0),
            child: Text(
              "Account Details",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          // Categories: Circular buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildCategoryItem(
                icon: Icons.person,
                label: "My Profile",
                onTap: () =>
                    navigateToHomeProfileScreen(context), // Pass context here
              ),
              _buildCategoryItem(
                icon: Icons.account_balance_wallet,
                label: "My Wallet",
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const WalletScreen()),
                  );
                },
                // Navigate or perform action for My Wallet
              ),
              _buildCategoryItem(
                icon: Icons.emoji_events,
                label: "Top Players",
                onTap: () {
                  // Navigate or perform action for Top Players
                },
              ),
              _buildCategoryItem(
                  icon: Icons.headset_mic,
                  label: "Contact Us",
                  onTap: () => navigateToHomeContactUs(context)
                  // Navigate or perform action for Contact Us

                  ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryItem({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return Column(
      children: [
        GestureDetector(
          onTap: onTap,
          child: Container(
            width: 60,
            height: 60,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.red, // Button background color
            ),
            child: Icon(
              icon,
              color: Colors.white,
              size: 30,
            ),
          ),
        ),
        const SizedBox(height: 5),
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            color: Colors.white,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
