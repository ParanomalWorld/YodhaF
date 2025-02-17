// lib/screens/admin/admin_pay_request_screen.dart
import 'package:flutter/material.dart';
import 'package:yodha_a/features/admin/admin_pay_request_screen/admin_pay_request_service.dart';
import 'package:yodha_a/models/admin_payment_request.dart';

class AdminPayRequestScreen extends StatefulWidget {
  const AdminPayRequestScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _AdminPayRequestScreenState createState() => _AdminPayRequestScreenState();
}

class _AdminPayRequestScreenState extends State<AdminPayRequestScreen> {
  final _amountController = TextEditingController();
  bool _isLoading = false;
  AdminPaymentRequest? _lastRequest;

  Future<void> createOrder() async {
    final amount = double.tryParse(_amountController.text);
    if (amount == null || amount <= 0) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Enter a valid amount')));
      return;
    }

    setState(() => _isLoading = true);

    try {
      // Pass context along with the amount so the service can add authentication headers.
      final adminRequest = await PaymentService.createOrder(context, amount);
      if (adminRequest != null) {
        setState(() {
          _lastRequest = adminRequest;
        });
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Request created: ${adminRequest.id}')),
        );
      } else {
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to create request.')),
        );
      }
    } catch (e) {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Exception: $e')));
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Admin Payment Request'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _amountController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Enter Amount',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            _isLoading
                ? Center(child: CircularProgressIndicator())
                : ElevatedButton(
                    onPressed: createOrder,
                    child: Text('Create Payment Request'),
                  ),
            const SizedBox(height: 20),
            if (_lastRequest != null) ...[
              Text(
                'Last Request Details:',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              Text('ID: ${_lastRequest!.id}'),
              Text('Amount: ₹${_lastRequest!.amount}'),
              Text('Status: ${_lastRequest!.status}'),
              Text('Created At: ${_lastRequest!.createdAt}'),
            ],
          ],
        ),
      ),
    );
  }
}
