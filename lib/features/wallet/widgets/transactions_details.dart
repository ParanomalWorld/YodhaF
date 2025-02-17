import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:yodha_a/constants/global_variables.dart';

class TransactionDetails extends StatelessWidget {
  final dynamic transaction;

  const TransactionDetails({super.key, required this.transaction});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:GlobalVariables.backgroundColor, // Changed background to white
      // appBar: AppBar(
      //   title: const Text(
      //     'Transaction Details',
      //     style: TextStyle(
      //       fontWeight: FontWeight.bold,
      //       color: Colors.black, // Changed text color to black
      //     ),
      //   ),
      //   backgroundColor: Colors.white, // Changed AppBar background to white
      //   centerTitle: true,
      //   iconTheme: const IconThemeData(color: Colors.black), // Back icon color
      //   elevation: 0,
      // ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Card(
            color: Colors.white, // Changed Card color to white
            elevation: 10,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Header text inside the card
                  const Center(
                    child: Text(
                      'Transaction Details',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black, // Changed text color to black
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  _detailRow(
                      "Requested On",
                      _formatDate(transaction['createdAt']),
                      Icons.calendar_today),
                  _detailRow("Play Coins", "+${transaction['playCoins']} Coins",
                      Icons.monetization_on, Colors.amber),
                  _detailRow("Amount", "${transaction['amount']}",
                      Icons.currency_rupee, Colors.green),
                  _detailRow(
                    "Payment Status",
                    transaction['paymentStatus'].toString().toUpperCase(),
                    transaction['paymentStatus'] == "success"
                        ? Icons.check_circle
                        : Icons.cancel,
                    transaction['paymentStatus'] == "success"
                        ? Colors.green
                        : Colors.red,
                  ),
                  _copyableRow("Order ID", transaction['orderId'], Icons.copy),
                  _detailRow("Payment Type", transaction['type'], Icons.payment),
                  _detailRow("Remark", transaction['remark'], Icons.note),
                  const SizedBox(height: 20),
                  Center(
                    child: _actionButton(
                        context, "OK", Colors.green, () => Navigator.pop(context)),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _detailRow(String title, String value, IconData icon, [Color? color]) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, color: color ?? Colors.black54, size: 24),
          const SizedBox(width: 12),
          Text(
            title,
            style: const TextStyle(fontSize: 16, color: Colors.black54),
          ),
          const Spacer(),
          Text(
            value,
            style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: color ?? Colors.black),
          ),
        ],
      ),
    );
  }

  Widget _copyableRow(String title, String value, IconData icon) {
    return Builder(
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            children: [
              Icon(icon, color: Colors.blueAccent, size: 24),
              const SizedBox(width: 12),
              Text(
                title,
                style: const TextStyle(fontSize: 16, color: Colors.black54),
              ),
              const Spacer(),
              GestureDetector(
                onTap: () {
                  Clipboard.setData(ClipboardData(text: value));
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text('Order ID copied!'),
                        duration: Duration(seconds: 1)),
                  );
                },
                child: Row(
                  children: [
                    Text(
                      value,
                      style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black),
                    ),
                    const SizedBox(width: 8),
                    const Icon(Icons.content_copy,
                        color: Colors.black54, size: 18),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _actionButton(
      BuildContext context, String text, Color color, VoidCallback onPressed) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        padding:
            const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8)),
      ),
      onPressed: onPressed,
      child: Text(
        text,
        style: const TextStyle(
            fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),
      ),
    );
  }

  String _formatDate(String dateTime) {
    DateTime parsedDate = DateTime.parse(dateTime);
    return "${parsedDate.day}-${parsedDate.month}-${parsedDate.year}";
  }
}
