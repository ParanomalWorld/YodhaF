import 'package:flutter/material.dart';
import 'package:yodha_a/features/services/cashfree_service.dart';
import 'package:yodha_a/models/wallet.dart';

class BalanceBox extends StatefulWidget {
  const BalanceBox({super.key});

  @override
  State<BalanceBox> createState() => _BalanceBoxState();
}

class _BalanceBoxState extends State<BalanceBox> {
  late Future<Wallet?> _walletFuture;
  final CashfreeService _walletService = CashfreeService();

  @override
  void initState() {
    super.initState();
    _walletFuture = _walletService.getUserWalletBalance(context: context);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Wallet?>(
      future: _walletFuture,
      builder: (context, snapshot) {
        Wallet wallet = snapshot.hasData && snapshot.data != null
            ? snapshot.data!
            : Wallet(
                mainBalance: 0,
                winningBalance: 0,
                bonusBalance: 0,
                coinBalance: 0,
                redeemBalance: 0,
                createdAt: DateTime.now(),
                updatedAt: DateTime.now(),
              );

        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Coin Icon and Total Balance Display
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.monetization_on,
                    color: Colors.amber, size: 50),
                const SizedBox(width: 8),
                Text(
                  wallet.coinBalance.toString(),
                  style: const TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.deepPurple,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Wallet Breakdown
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _balanceItem('Deposited', wallet.coinBalance),
                _balanceItem('Winning', wallet.winningBalance),
                _balanceItem('Bonus', wallet.bonusBalance),
              ],
            ),
          ],
        );
      },
    );
  }

  Widget _balanceItem(String label, int value) {
    return SizedBox(
      width: 110,
      height: 65,
      child: Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: const [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 6,
              spreadRadius: 1,
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.monetization_on,
                    color: Colors.amber, size: 18),
                const SizedBox(width: 4),
                Text(
                  value.toString(),
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 68, 2, 79),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 5),
            Text(
              label,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
