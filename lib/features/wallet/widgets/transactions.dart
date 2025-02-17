// lib/features/screens/transactions.dart
import 'package:flutter/material.dart';
import 'package:yodha_a/features/services/cashfree_service.dart';
import 'package:yodha_a/features/wallet/widgets/transactions_details.dart';

class Transactions extends StatefulWidget {
  const Transactions({super.key});

  @override
  State<Transactions> createState() => _TransactionsState();
}

class _TransactionsState extends State<Transactions> {
  late Future<List<dynamic>?> _transactionsFuture;
  final CashfreeService _cashfreeService = CashfreeService();

  @override
  void initState() {
    super.initState();
    // Fetch the transactions when the widget is initialized.
    _transactionsFuture =
        _cashfreeService.getUserTransactions(context: context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
   appBar: AppBar(
        title: const Text(
          'Transaction Zone',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Color.fromARGB(255, 230, 229, 229), // Changed text color to black
          ),
        ),
        backgroundColor: Colors.indigo, // Changed AppBar background to white
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.black), // Back icon color
        elevation: 0,
      ),
      body: FutureBuilder<List<dynamic>?>(
        future: _transactionsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // While waiting for the API call, show a loading indicator.
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            // If there was an error, display an error message.
            return const Center(child: Text('Error fetching transactions'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            // If no transactions were returned, display a friendly message.
            return const Center(child: Text('No transactions found'));
          }

          final List<dynamic> transactions = snapshot.data!;
          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: transactions.length,
            itemBuilder: (context, index) {
              final transaction = transactions[index];

              return GestureDetector(
                onTap: () {
                  _openTransactionDetails(context, transaction);
                },
                child: Container(
                  margin: const EdgeInsets.symmetric(vertical: 6),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Colors.black87, Colors.black54],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black,
                        blurRadius: 6,
                        spreadRadius: 2,
                        offset: const Offset(2, 3),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _formatDate(transaction['createdAt']),
                        style: const TextStyle(color: Colors.white70),
                      ),
                      const SizedBox(height: 6),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              transaction['remark']
                                  .toString()
                                  .toUpperCase(),
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          Row(
                            children: [
                              Text(
                                "+${transaction['playCoins']}",
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.amber,
                                ),
                              ),
                              const Icon(Icons.monetization_on,
                                  color: Colors.amber, size: 20),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "#id: ${transaction['orderId']}",
                        style: const TextStyle(color: Colors.white70),
                      ),
                      const SizedBox(height: 8),
                      Align(
                        alignment: Alignment.bottomRight,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 4),
                          decoration: BoxDecoration(
                            color: transaction['paymentStatus'] == "success"
                                ? Colors.green
                                : Colors.red,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            transaction['paymentStatus']
                                .toString()
                                .toUpperCase(),
                            style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  /// Navigate to the TransactionDetails screen
  void _openTransactionDetails(BuildContext context, dynamic transaction) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TransactionDetails(transaction: transaction),
      ),
    );
  }

  /// Format the date as DD-MM-YYYY
  String _formatDate(String dateTime) {
    DateTime parsedDate = DateTime.parse(dateTime);
    return "${parsedDate.day}-${parsedDate.month}-${parsedDate.year}";
  }
}
