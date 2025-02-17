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

class SlotServices {
  //FETCH USER DATA FROM DATABASE

  Future<List<User>> fetchUserInfoAdmin(BuildContext context) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    List<User> users = [];
    try {
      http.Response res =
          await http.get(Uri.parse('$uri/api/get-userinfoInAdmin'), headers: {
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

//FETCH EVENT SLOT in SLOT SCREEN DART

  Future<Event> fetchEventById(BuildContext context, String eventId) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    try {
      http.Response res = await http.get(
        Uri.parse('$uri/api/get-event-slot-info?eventId=$eventId'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': userProvider.user.token,
        },
      );

      if (res.statusCode == 200) {
        final eventData = json.decode(res.body);
        return Event.fromMap(eventData);
      } else {
        debugPrint('Response status: ${res.statusCode}');
        debugPrint('Response body: ${res.body}');
        throw Exception('Failed to fetch event details');
      }
    } catch (e) {
      debugPrint('Error: $e');
      throw Exception('Error fetching event: $e');
    }
  }

//------------------------------------------------------------
//UPDATE SLOT DATA TO DB

  // /// Updates a specific slot's `isBooked` and `userId` values
  // Future<void> bookSlot({
  //   required BuildContext context,
  //   required String eventId,
  //   required String slotId,
  //   required bool isBooked,
  //   required String userMsg,
  // }) async {
  //   final userProvider = Provider.of<UserProvider>(context, listen: false);
  //   // print('Submitting userId: $userId, eventId: $eventId, slotId: $slotId, isBooked: $isBooked');
    

  //   try {

  //      // Validation: Ensure `userId` is provided when `isBooked` is true
  //     if (isBooked && userMsg.trim().isEmpty) {
  //       showSnackBar(context, 'User ID is required when booking a slot.');
  //       return;
  //     }


  //     // API call to update the slot
  //     http.Response res = await http.patch(
  //       Uri.parse('$uri/update-slot/$eventId/$slotId'),
  //       headers: {
  //         'Content-Type': 'application/json; charset=UTF-8',
  //         'x-auth-token': userProvider.user.token,
  //       },
  //       body: jsonEncode({
  //         'isBooked': isBooked,
  //         'userId': userMsg,
  //       }),
  //     );

  //   // Handle response
  //     httpErrorHandling(
  //       response: res,
  //       // ignore: use_build_context_synchronously
  //       context: context,
  //       onSuccess: () {
  //         showSnackBar(context, 'Slot updated successfully!');
  //       },
  //     );
  //   } catch (e) {
  //     // ignore: use_build_context_synchronously
  //     showSnackBar(context, e.toString());
  //   }
  // }
Future<void> bookSlot({
  required BuildContext context,
  required String eventId,
  required String slotId,
  required bool isBooked,
  required String userMsg, 
  //required String userId,// Extra details from the user
}) async {
  final userProvider = Provider.of<UserProvider>(context, listen: false);
  
  try {
    // Validate that extra details are provided when booking.
    if (isBooked && userMsg.trim().isEmpty) {
      showSnackBar(context, 'Player details are required when booking a slot.');
      return;
    }

    // API call to update the slot.
    http.Response res = await http.patch(
      Uri.parse('$uri/update-slot/$eventId/$slotId'),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'x-auth-token': userProvider.user.token,
      },
      body: jsonEncode({
        'isBooked': isBooked,
        'userMsg': userMsg, // Send the extra details.
      }),
    );

    httpErrorHandling(
      response: res,
      // ignore: use_build_context_synchronously
      context: context,
      onSuccess: () {
        showSnackBar(context, 'Slot updated successfully!');
      },
    );
  } catch (e) {
    // ignore: use_build_context_synchronously
    showSnackBar(context, e.toString());
  }
}



}