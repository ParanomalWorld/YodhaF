import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:yodha_a/constants/error_handling.dart';
import 'package:yodha_a/constants/global_variables.dart';
import 'package:yodha_a/constants/utils.dart';
import 'package:yodha_a/models/event.dart';
import 'package:yodha_a/providers/user_provider.dart';

class EntryServices {
  /// Fetches booked slots (including userMsg and slotNumber) for a given event.
 Future<Map<String, dynamic>> fetchBookedSlots(
    BuildContext context, String eventId) async {
  final userProvider = Provider.of<UserProvider>(context, listen: false);

  try {
    final response = await http.get(
      Uri.parse('$uri/api/booked-slots/$eventId'),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'x-auth-token': userProvider.user.token,
      },
    );

    List<Slot> bookedSlots = [];
    int slotCount = 0;
    int bookedCount = 0;

    httpErrorHandling(
      response: response,
      // ignore: use_build_context_synchronously
      context: context,
      onSuccess: () {
        final Map<String, dynamic> data = json.decode(response.body);
        //print("Raw API Response: $data"); // ✅ Debugging log

        bookedSlots = (data['bookedSlots'] as List)
            .map((slot) => Slot.fromMap(slot))
            .toList();
        slotCount = data['slotCount'];
        bookedCount = data['bookedCount'];
      },
    );

    return {
      "bookedSlots": bookedSlots,
      "slotCount": slotCount,
      "bookedCount": bookedCount,
    };
  } catch (e) {
    // ignore: use_build_context_synchronously
    showSnackBar(context, e.toString());
    return {
      "bookedSlots": [],
      "slotCount": 0,
      "bookedCount": 0,
    };
  }
}

}