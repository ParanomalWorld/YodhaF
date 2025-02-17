// lib/features/screens/wallet_screen.dart
import 'package:flutter/material.dart';
import 'package:yodha_a/features/services/cashfree_payment_screen.dart';
import 'package:yodha_a/features/wallet/widgets/balance_box.dart';
import 'package:yodha_a/features/wallet/widgets/transactions.dart';


class WalletScreen extends StatefulWidget {
  
  const WalletScreen({super.key});

  

  @override
  State<WalletScreen> createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Wallet", style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.indigo,
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: const BoxDecoration(
              color: Color.fromARGB(255, 43, 43, 45),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
            ),
            child: Column(
              children: [
                // Instead of showing a spinner, we display a default value of 0 until data is loaded.
                //_buildCoinBalanceDisplay(),
                const SizedBox(height: 20),
                // The BalanceBox widget displays the other wallet breakdown items.
                const BalanceBox(),
              ],
            ),
          ),
          const SizedBox(height: 20),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text("My Wallet", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: GridView.count(
              crossAxisCount: 3,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              children: [
                _buildWalletOption("Add Coins", Icons.account_balance_wallet, () => _navigateTo(context, const CashfreePaymentScreen())),
                _buildWalletOption("Redeem Coins", Icons.card_giftcard, () => _navigateTo(context, const BalanceBox())),
                _buildWalletOption("Transactions", Icons.history, () => _navigateTo(context, const Transactions())),
              ],
            ),
          ),
        ],
      ),
    );
  }

 

  Widget _buildWalletOption(String title, IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 3,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 40, color: Colors.indigo),
            const SizedBox(height: 8),
            Text(title, textAlign: TextAlign.center, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
          ],
        ),
      ),
    );
  }

  void _navigateTo(BuildContext context, Widget screen) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => screen));
  }
}
