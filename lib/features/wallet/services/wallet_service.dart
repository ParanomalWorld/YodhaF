// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:provider/provider.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:yodha_a/constants/error_handling.dart';
// import 'package:yodha_a/constants/global_variables.dart';
// import 'package:yodha_a/constants/utils.dart';
// import 'package:yodha_a/models/wallet.dart';
// import 'package:yodha_a/providers/user_provider.dart';

// class WalletService {
//   Future<void> getWallet(BuildContext context) async {
//     try {
//       SharedPreferences prefs = await SharedPreferences.getInstance();
//       String? token = prefs.getString('x-auth-token');

//       if (token == null) return;

//       http.Response res = await http.get(
//         Uri.parse('$uri/api/wallet'),
//         headers: {
//           'Content-Type': 'application/json; charset=UTF-8',
//           'x-auth-token': token,
//         },
//       );

//       httpErrorHandling(
//         response: res,
//         context: context,
//         onSuccess: () {
//           var walletData = jsonDecode(res.body);
//           Wallet wallet = Wallet.fromMap(walletData);

//           var userProvider = Provider.of<UserProvider>(context, listen: false);
//           userProvider.setWallet(wallet); // Update the entire Wallet object
//         },
//       );
//     } catch (e) {
//       showSnackBar(context, e.toString());
//     }
//   }

//   Future<void> addFunds(BuildContext context, double amount) async {
//     try {
//       SharedPreferences prefs = await SharedPreferences.getInstance();
//       String? token = prefs.getString('x-auth-token');

//       if (token == null) return;

//       http.Response res = await http.post(
//         Uri.parse('$uri/api/wallet/addFunds'),
//         body: jsonEncode({'amount': amount}),
//         headers: {
//           'Content-Type': 'application/json; charset=UTF-8',
//           'x-auth-token': token,
//         },
//       );

//       httpErrorHandling(
//         response: res,
//         context: context,
//         onSuccess: () {
//           getWallet(context); // Refresh wallet data after adding funds
//         },
//       );
//     } catch (e) {
//       showSnackBar(context, e.toString());
//     }
//   }
// }
