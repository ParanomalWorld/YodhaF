// lib/screens/cashfree_payment_screen.dart
import 'package:flutter/material.dart';
import 'package:yodha_a/constants/utils.dart';
import 'package:yodha_a/features/services/cashfree_service.dart';
import 'package:yodha_a/models/admin_payment_request.dart';

class CashfreePaymentScreen extends StatefulWidget {
  const CashfreePaymentScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _CashfreePaymentScreenState createState() => _CashfreePaymentScreenState();
}

class _CashfreePaymentScreenState extends State<CashfreePaymentScreen> {
  final CashfreeService _cashfreeService = CashfreeService();
  Future<List<AdminPaymentRequest>?>? _requestsFuture;

  @override
  void initState() {
    super.initState();
    _requestsFuture = _cashfreeService.fetchAdminRequests(context: context);
  }

  /// Initiates the payment process for the selected admin payment request.
  void _payOrder(AdminPaymentRequest request) async {
    // Create a payment order using only the adminPaymentRequestId.
    final orderData = await _cashfreeService.createUserPaymentOrder(
      context: context,
      adminPaymentRequestId: request.id,
    );

    if (orderData == null) {
      // ignore: use_build_context_synchronously
      showSnackBar(context, 'Failed to create user payment order.');
      return;
    }

    // Extract order details from the response.
    final String orderId = orderData['orderId'] ?? orderData['order_id'];
    final String paymentSessionId = orderData['paymentSessionId'] ??
        orderData['payment_session_id'];

    // Initiate Cashfree payment for the created order.
    await _cashfreeService.initiatePaymentForOrder(
      // ignore: use_build_context_synchronously
      context: context,
      orderId: orderId,
      paymentSessionId: paymentSessionId,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Buy Coins'),
        backgroundColor: const Color.fromARGB(255, 143, 33, 190),
      ),
      body: FutureBuilder<List<AdminPaymentRequest>?>(
        future: _requestsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error fetching orders: ${snapshot.error}'),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No orders available.'));
          } else {
            final requests = snapshot.data!;
            return ListView.builder(
              itemCount: requests.length,
              itemBuilder: (context, index) {
                final request = requests[index];
                return GestureDetector(
                  onTap: () => _payOrder(request),
                  child: Card(
                    margin: const EdgeInsets.all(8.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16.0, vertical: 10.0),
                      leading: Image.asset('assets/images/paylogo.png',
                          width: 40),
                      title: const Text(
                        'UPI Pay',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(
                          '${request.amount} INR = ${request.amount} Coins'),
                      trailing: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: Text(
                          '${request.amount} INR',
                          style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
