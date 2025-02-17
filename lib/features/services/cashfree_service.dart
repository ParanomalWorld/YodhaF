// lib/features/services/cashfree_service.dart
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_cashfree_pg_sdk/api/cferrorresponse/cferrorresponse.dart';
import 'package:flutter_cashfree_pg_sdk/api/cfpayment/cfwebcheckoutpayment.dart';
import 'package:flutter_cashfree_pg_sdk/api/cfpaymentgateway/cfpaymentgatewayservice.dart';
import 'package:flutter_cashfree_pg_sdk/api/cfsession/cfsession.dart';
import 'package:flutter_cashfree_pg_sdk/utils/cfenums.dart';
import 'package:flutter_cashfree_pg_sdk/utils/cfexceptions.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:yodha_a/constants/global_variables.dart'; // Contains your backend URL (uri)
import 'package:yodha_a/constants/utils.dart';
import 'package:yodha_a/models/admin_payment_request.dart';
import 'package:yodha_a/models/wallet.dart';
import 'package:yodha_a/providers/user_provider.dart';

class CashfreeService {
  /// Fetches the list of admin payment requests from the backend.
  Future<List<AdminPaymentRequest>?> fetchAdminRequests({
    required BuildContext context,
  }) async {
    try {
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      final url = Uri.parse('$uri/api/cashfree/admin-payment-request');
      final response = await http.get(url, headers: {
        'Content-Type': 'application/json',
        'x-auth-token': userProvider.user.token,
      });

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data
            .map((json) => AdminPaymentRequest.fromJson(json))
            .toList();
      } else {
        debugPrint(
            "Fetch admin requests error: ${response.statusCode} ${response.body}");
        showSnackBar(
            // ignore: use_build_context_synchronously
            context, 'Failed to fetch admin payment requests. Try again.');
        return null;
      }
    } catch (e) {
      debugPrint("Fetch admin requests exception: $e");
      // ignore: use_build_context_synchronously
      showSnackBar(context, e.toString());
      return null;
    }
  }

  /// Creates a new user payment order based on an admin payment request.
  Future<Map<String, dynamic>?> createUserPaymentOrder({
    required BuildContext context,
    required String adminPaymentRequestId,
  }) async {
    try {
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      final url = Uri.parse('$uri/api/cashfree/user-payment-order');
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'x-auth-token': userProvider.user.token,
        },
        body: jsonEncode({
          'adminPaymentRequestId': adminPaymentRequestId,
        }),
      );
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        debugPrint(
            "Create user payment order error: ${response.statusCode} ${response.body}");
        // ignore: use_build_context_synchronously
        showSnackBar(context, 'Failed to create user payment order.');
        return null;
      }
    } catch (e) {
      debugPrint("Create user payment order exception: $e");
      // ignore: use_build_context_synchronously
      showSnackBar(context, e.toString());
      return null;
    }
  }

  /// Initiates the Cashfree payment process for an order using its details.
  Future<void> initiatePaymentForOrder({
    required BuildContext context,
    required String orderId,
    required String paymentSessionId,
  }) async {
    CFSession? session;
    try {
      session = CFSessionBuilder()
          .setEnvironment(CFEnvironment.SANDBOX) // Change to PRODUCTION for live mode.
          .setOrderId(orderId)
          .setPaymentSessionId(paymentSessionId)
          .build();
    } on CFException catch (e) {
      showSnackBar(context, 'Error creating session: ${e.message}');
      return;
    }

    final CFWebCheckoutPayment cfPayment = CFWebCheckoutPaymentBuilder()
        .setSession(session)
        .build();

    final CFPaymentGatewayService cfPaymentGatewayService =
        CFPaymentGatewayService();
    cfPaymentGatewayService.setCallback(
      (String orderId) async {
        await verifyPayment(context, orderId);
      },
      (CFErrorResponse errorResponse, String orderId) {
        showSnackBar(context, 'Payment error: ${errorResponse.getMessage()}');
      },
    );

    try {
      cfPaymentGatewayService.doPayment(cfPayment);
    } on CFException catch (e) {
      showSnackBar(context, 'Payment initiation error: ${e.message}');
    }
  }

  /// Verifies the payment by calling the backend verification endpoint.
  Future<void> verifyPayment(BuildContext context, String orderId) async {
    try {
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      final url = Uri.parse('$uri/api/cashfree/verify');
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'x-auth-token': userProvider.user.token,
        },
        body: jsonEncode({'orderId': orderId}),
      );
      if (response.statusCode == 200) {
        // ignore: use_build_context_synchronously
        showSnackBar(context, 'Payment verified successfully');
      } else {
        // ignore: use_build_context_synchronously
        showSnackBar(context, 'Payment verification failed');
      }
    } catch (e) {
      // ignore: use_build_context_synchronously
      showSnackBar(context, e.toString());
    }
  }

   /// Fetches the authenticated user's transaction details.
  Future<List<dynamic>?> getUserTransactions({
    required BuildContext context,
  }) async {
    try {
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      final url = Uri.parse('$uri/api/cashfree/user-transactions');
      final response = await http.get(url, headers: {
        'Content-Type': 'application/json',
        'x-auth-token': userProvider.user.token,
      });

      if (response.statusCode == 200) {
        // Assuming the backend returns a JSON object with a "transactions" array:
        final Map<String, dynamic> resBody = jsonDecode(response.body);
        final List<dynamic> transactions = resBody['transactions'] ?? [];
        return transactions;
      } else {
        debugPrint(
            "Fetch transactions error: ${response.statusCode} ${response.body}");
        // ignore: use_build_context_synchronously
        showSnackBar(context, 'Failed to fetch transactions.');
        return null;
      }
    } catch (e) {
      debugPrint("Fetch transactions exception: $e");
      // ignore: use_build_context_synchronously
      showSnackBar(context, e.toString());
      return null;
    }
  }

   /// Fetches the authenticated user's wallet balance details.
  Future<Wallet?> getUserWalletBalance({required BuildContext context}) async {
    try {
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      final url = Uri.parse('$uri/api/cashfree/user-wallat-balance');
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'x-auth-token': userProvider.user.token,
        },
      );

      if (response.statusCode == 200) {
        // Parse the returned JSON object into a Wallet model.
        final Map<String, dynamic> resBody = jsonDecode(response.body);
        final wallet = Wallet.fromMap(resBody);
        return wallet;
      } else {
        debugPrint(
            "Fetch wallet balance error: ${response.statusCode} ${response.body}");
        // ignore: use_build_context_synchronously
        showSnackBar(context, 'Failed to fetch wallet balance.');
        return null;
      }
    } catch (e) {
      debugPrint("Fetch wallet balance exception: $e");
      // ignore: use_build_context_synchronously
      showSnackBar(context, e.toString());
      return null;
    }
  }
}
