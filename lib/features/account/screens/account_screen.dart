import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yodha_a/constants/global_variables.dart';
import 'package:yodha_a/features/services/cashfree_service.dart';
import 'package:yodha_a/features/wallet/screens/wallat_screen.dart';
import 'package:yodha_a/providers/user_provider.dart';
import 'package:yodha_a/features/account/widgets/top_buttons.dart';
import 'package:yodha_a/models/wallet.dart';

class AccountScreen extends StatelessWidget {
  const AccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context).user;

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: AppBar(
          backgroundColor: const Color(0xFF2B3A42),
          elevation: 0,
          title: Stack(
            alignment: Alignment.center, // Center the Welcome Message
            children: [
              // Centered Welcome Message
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(
                    "Welcome Back To,",
                    style: TextStyle(color: Colors.white70, fontSize: 14),
                  ),
                  Text(
                    "YodhaX",
                    style: const TextStyle(
                      color: Color.fromARGB(255, 246, 149, 46),
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
              // Left: Profile Image (Logo)
              Align(
                alignment: Alignment.centerLeft,
                child: CircleAvatar(
                  backgroundImage: AssetImage('assets/images/logo.jpg'),
                  radius: 20,
                ),
              ),
              // Right: Headset & Wallet
              Align(
                alignment: Alignment.centerRight,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.headset, color: Colors.purpleAccent),
                      onPressed: () {},
                    ),
                    // Wrap the wallet container with InkWell to make it tappable.
                    FutureBuilder<Wallet?>(
                      future: CashfreeService().getUserWalletBalance(context: context),
                      builder: (context, snapshot) {
                        int coinBalance = 0;
                        if (snapshot.hasData && snapshot.data != null) {
                          coinBalance = snapshot.data!.coinBalance;
                        }
                        return InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const WalletScreen()),
                            );
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.green,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 6),
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.account_balance_wallet,
                                  color: Colors.white,
                                  size: 20,
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  '$coinBalance +',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      body: Column(
        children: [
          Container(
            color: GlobalVariables.backgroundColor,
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Column(
              children: [
                const CircleAvatar(
                  radius: 40,
                  backgroundImage: AssetImage('assets/images/profile.png'),
                ),
                const SizedBox(height: 10),
                Text(
                  user.userName,
                  style: const TextStyle(
                    fontSize: 22,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: TopButtons(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
