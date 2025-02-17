import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:yodha_a/constants/error_handling.dart';
import 'package:yodha_a/constants/global_variables.dart';
import 'package:yodha_a/constants/utils.dart';
import 'package:yodha_a/models/event.dart';
import 'package:yodha_a/providers/user_provider.dart';

class EventCategoriesServices {
  // Fetch events by category
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

    //DELETE EVENT DATA IN 
  void deleteEvent(
      {required BuildContext context,
      required Event eventBox,
      required VoidCallback onSuccess}) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    try {
      http.Response res = await http.post(
        Uri.parse('$uri/admin/delete-event'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': userProvider.user.token,
        },
        body: jsonEncode({
          'id': eventBox.id,
        }),
      );

      httpErrorHandling(
          response: res,
          // ignore: use_build_context_synchronously
          context: context,
          onSuccess: () {
            onSuccess();
          });
    } catch (e) {
      // ignore: use_build_context_synchronously
      showSnackBar(context, e.toString());
    }
  }

  //UPDATE EVENT
  Future<void> updateEvent({
    required BuildContext context,
    required String eventId,
    required Map<String, dynamic> updatedFields, // Only the fields to update
  }) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    try {
      http.Response res = await http.patch(
        Uri.parse('$uri/api/update-event-admin/$eventId'), // API endpoint
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': userProvider.user.token, // Auth Token
        },
        body: jsonEncode(updatedFields), // Send only the fields that need updating
      );

      if (res.statusCode == 200) {
        // ignore: use_build_context_synchronously
        showSnackBar(context, "Event updated successfully!");
      } else {
        // ignore: use_build_context_synchronously
        showSnackBar(context, "Failed to update event: ${res.body}");
      }
    } catch (e) {
      // ignore: use_build_context_synchronously
      showSnackBar(context, "Error: $e");
    }
  }


}
