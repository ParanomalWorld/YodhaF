import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:yodha_a/constants/error_handling.dart';
import 'package:yodha_a/constants/global_variables.dart';
import 'package:yodha_a/constants/utils.dart';
import 'package:yodha_a/models/event.dart';
import 'package:yodha_a/models/users.dart';
import 'package:yodha_a/providers/user_provider.dart';

class HomeServices {

    // Initialize the user object here
User user = User(
    id: '',
    firstName: '',
    lastName: '',
    userName: '',
    email: '',
    mobileNumber: 0,
    password: '',
    address: '',
    type: '',
    userId: '',
    // totalBalance: 0,
    // winningBalance: 0,
    // bonus: 0,
    // addBalance: 0,
    date: '',
    token: '',
  );
 Future<User?> fetchUserProfile({required BuildContext context}) async {
  final userProvider = Provider.of<UserProvider>(context, listen: false);
  User? profile;
  try {
    http.Response res = await http.get(
      Uri.parse('$uri/api/user/profile'),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'x-auth-token': userProvider.user.token,
      },
    );

    httpErrorHandling(
      response: res,
      // ignore: use_build_context_synchronously
      context: context,
      onSuccess: () {
        profile = User.fromJson(res.body);
      },
    );
  } catch (e) {
    // ignore: use_build_context_synchronously
    showSnackBar(context, e.toString());
  }
  return profile;
}

  //----------------------
    //FETCH USER DATA FROM DATABASE

    Future<List<User>> fetchUserInfo(BuildContext context) async {
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      List<User> users = [];
      try {
        http.Response res =
            await http.get(Uri.parse('$uri/api/get-userinfo'), headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': userProvider.user.token,
        });

        httpErrorHandling(
          response: res,
          // ignore: use_build_context_synchronously
          context: context,
          onSuccess: () {
            List<dynamic> data = jsonDecode(res.body); // Decode list of users
            users = data
                .map((userJson) => User.fromJson(jsonEncode(userJson)))
                .toList();
          },
        );
      } catch (e) {
        // ignore: use_build_context_synchronously
        showSnackBar(context, e.toString());
      }
      return users;
    
  }






  // Fetch events by category
  Future<List<Event>> fetchCategoryEvent({
    required BuildContext context,
    required String category,
  }) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    List<Event> eventList = [];

    try {
      // Make HTTP GET request
      http.Response res = await http.get(
        Uri.parse('$uri/api/get-eventinfo?category=$category'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': userProvider.user.token,
        },
      );

      // Handle HTTP response
      httpErrorHandling(
        response: res,
        // ignore: use_build_context_synchronously
        context: context,
        onSuccess: () {
          // Parse the list of events from the response body
          for (var i = 0; i < jsonDecode(res.body).length; i++) {
            eventList.add(
              Event.fromJson(
                jsonEncode(jsonDecode(res.body)[i]),
              ),
            );
          }
        },
      );
    } catch (e) {
      // Display error message
      // ignore: use_build_context_synchronously
      showSnackBar(context, 'Failed to fetch events: $e');
    }

    return eventList; // Return the list of events
  }
}
