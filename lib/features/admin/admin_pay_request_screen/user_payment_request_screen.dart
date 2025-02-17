// import 'package:flutter/material.dart';
// import 'package:qr_flutter/qr_flutter.dart';
// import '../services/payment_service.dart';

// class UserPaymentRequestPage extends StatefulWidget {
//   @override
//   _UserPaymentRequestPageState createState() => _UserPaymentRequestPageState();
// }

// class _UserPaymentRequestPageState extends State<UserPaymentRequestPage> {
//   bool isLoading = true;
//   String? upiString;
//   double? amount; // Store amount for Cashfree payment
//   String message = '';

//   @override
//   void initState() {
//     super.initState();
//     fetchPaymentRequest();
//   }

//   Future<void> fetchPaymentRequest() async {
//     try {
//       final data = await PaymentService.fetchActivePaymentRequest(context);
//       if (data['data'] != null) {
//         setState(() {
//           upiString = data['data']['upiString'];
//           amount = double.tryParse(data['data']['amount'].toString());
//           isLoading = false;
//         });
//       } else {
//         setState(() {
//           message = 'No active payment request available.';
//           isLoading = false;
//         });
//       }
//     } catch (e) {
//       setState(() {
//         message = e.toString();
//         isLoading = false;
//       });
//     }
//   }

//   Future<void> _startCashfreePayment() async {
//     if (amount != null) {
//       await PaymentService().initiatePayment(context, amount!);
//     } else {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text("Invalid payment amount!")),
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Payment Request')),
//       body: Center(
//         child: isLoading
//             ? const CircularProgressIndicator()
//             : Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: <Widget>[
//                   if (upiString != null) ...[
//                     const Text(
//                       'Scan this QR code to pay:',
//                       style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//                     ),
//                     const SizedBox(height: 20),
//                     QrImageView(
//                       data: upiString!,
//                       version: QrVersions.auto,
//                       size: 200.0,
//                     ),
//                     const SizedBox(height: 20),
//                     const Text(
//                       'UPI Payment Link:',
//                       style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
//                     ),
//                     Padding(
//                       padding: const EdgeInsets.all(8.0),
//                       child: SelectableText(
//                         upiString!,
//                         textAlign: TextAlign.center,
//                         style: const TextStyle(fontSize: 14, color: Colors.blue),
//                       ),
//                     ),
//                     const SizedBox(height: 20),
//                     const Text(
//                       "OR Use Cashfree Payment",
//                       style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//                     ),
//                     const SizedBox(height: 10),
//                   ],
//                   ElevatedButton(
//                     onPressed: _startCashfreePayment,
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: Colors.green,
//                       padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
//                     ),
//                     child: const Text(
//                       "Pay with Cashfree",
//                       style: TextStyle(fontSize: 16, color: Colors.white),
//                     ),
//                   ),
//                   if (upiString == null) ...[
//                     const SizedBox(height: 20),
//                     Text(
//                       message,
//                       style: const TextStyle(fontSize: 16, color: Colors.red),
//                     ),
//                   ],
//                 ],
//               ),
//       ),
//     );
//   }
// }
