// lib/features/admin/admin_pay_request_screen/admin_pay_request_service.dart
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:yodha_a/constants/global_variables.dart';
import 'package:yodha_a/models/admin_payment_request.dart';
import 'package:yodha_a/providers/user_provider.dart';

class PaymentService {
  // static const String _baseUrl =
  //     'https://d8b4-205-254-174-6.ngrok-free.app/api';

  /// Create a new admin payment request (only amount is stored)
  static Future<AdminPaymentRequest?> createOrder(
      BuildContext context, double amount) async {
    try {
      // Retrieve the authentication token from the provider.
      final token =
          Provider.of<UserProvider>(context, listen: false).user.token;

      final response = await http.post(
        Uri.parse('$uri/api/cashfree/admin-payment-request'),
        headers: {
          'Content-Type': 'application/json',
          'x-auth-token': token, // Add the token to headers
        },
        body: jsonEncode({
          'amount': amount,
        }),
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        return AdminPaymentRequest.fromJson(responseData);
      } else {
      //  print("Error: ${response.body}");
        return null;
      }
    } catch (e) {
     // print("Exception: $e");
      return null;
    }
  }
}
