import 'dart:convert';
import 'dart:io';

import 'package:cloudinary_public/cloudinary_public.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yodha_a/constants/error_handling.dart';
import 'package:yodha_a/constants/global_variables.dart';
import 'package:yodha_a/constants/utils.dart';
import 'package:yodha_a/models/event.dart';
import 'package:http/http.dart' as http;
import 'package:yodha_a/models/users.dart';
import 'package:yodha_a/models/wallet.dart';
import 'package:yodha_a/providers/user_provider.dart';

class AdminServices {
  void addEvent({
    required BuildContext context,
    required String eventName,
    required String eventType,
    required int pricePool,
    required int entryFee,
    required String category,
    required List<File> images,
    required int perKill,
    required String gameMode,
    required String verisonselect,
    required String mapType,
    required String eventDate,
    required String eventTime,
    required int slotCount,
  }) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    try {
      // Upload images to Cloudinary
      final cloudinary = CloudinaryPublic('denfgaxvg', 'uszbstnu');
      List<String> imageUrls = [];

      for (var image in images) {
        CloudinaryResponse res = await cloudinary.uploadFile(
          CloudinaryFile.fromFile(image.path, folder: eventName),
        );
        imageUrls.add(res.secureUrl);
      }

      // Create an Event instance
      Event event = Event(
        id:"",
        eventName: eventName,
        eventType: eventType,
        pricePool: pricePool,
        entryFee: entryFee,
        category: category,
        images: imageUrls,
        perKill: perKill,
        gameMode: gameMode,
        versionSelect: verisonselect,
        mapType: mapType,
        eventDate: eventDate,
        eventTime: eventTime,
        slotCount: slotCount,
        slots: [],
      );

      // API call to add the event
      http.Response res = await http.post(
        Uri.parse('$uri/admin/add-tournament'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': userProvider.user.token,
        },
        body: event.toJson(),
      );

      // Handle response
      httpErrorHandling(
        response: res,
        // ignore: use_build_context_synchronously
        context: context,
        onSuccess: () {
          showSnackBar(context, 'Event Added Successfully!');
          Navigator.pop(context);
        },
      );
    } catch (e) {
      // ignore: use_build_context_synchronously
      showSnackBar(context, e.toString());
    }
  }

//-----------------------------------------------------------------
//FETCH EVENT DATA IN POST SCREEN DART

  Future<List<Event>> fetchAllEventBox(BuildContext context) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    List<Event> eventList = [];
    try {
      http.Response res =
          await http.get(Uri.parse('$uri/admin/get-eventinfo'), headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'x-auth-token': userProvider.user.token,
      });

      httpErrorHandling(
          response: res,
          // ignore: use_build_context_synchronously
          context: context,
          onSuccess: () {
            for (var i = 0; i < jsonDecode(res.body).length; i++) {
              eventList.add(
                Event.fromJson(
                  jsonEncode(
                    jsonDecode(res.body)[i],
                  ),
                ),
              );
            }
          });
    } catch (e) {
      // ignore: use_build_context_synchronously
      showSnackBar(context, e.toString());
    }
    return eventList;
  }

  //DELETE EVENT DATA IN POST SCREEN DART
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

  //-----------------------------------------------------------------
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

    //-----------------------------------------------------------------
  // UPDATE USER DATA BY ADMIN
  /// Updates a user's wallet (only winningBalance and redeemBalance can be updated).
  Future<void> updateUserWalletAdmin(
      BuildContext context, String userId, Map<String, dynamic> updateData) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    try {
      // Use the key "userId" to match the backend expectations.
      updateData['userId'] = userId;

      final response = await http.patch(
        Uri.parse('$uri/api/update-wallet-admin'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': userProvider.user.token,
        },
        body: jsonEncode(updateData),
      );

      httpErrorHandling(
        response: response,
        // ignore: use_build_context_synchronously
        context: context,
        onSuccess: () {
          showSnackBar(context, "Wallet updated successfully!");
        },
      );
    } catch (e) {
      // ignore: use_build_context_synchronously
      showSnackBar(context, e.toString());
    }
  }


  //---------------
Future<Wallet?> getUserWalletBalance({required BuildContext context, required String userId}) async {
  try {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    // Updated URL to match the server route with userId parameter
    final url = Uri.parse('$uri/api/admin/user-wallet-balance/$userId');
    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'x-auth-token': userProvider.user.token,
      },
    );
   // debugPrint("Fetch wallet balance response: ${response.body}");
    if (response.statusCode == 200) {
      final Map<String, dynamic> resBody = jsonDecode(response.body);
      return Wallet.fromMap(resBody);
    } else {
    //  debugPrint("Fetch wallet balance error: ${response.statusCode} ${response.body}");
      // ignore: use_build_context_synchronously
      showSnackBar(context, 'Failed to fetch wallet balance.');
      return null;
    }
  } catch (e) {
   // debugPrint("Fetch wallet balance exception: $e");
    // ignore: use_build_context_synchronously
    showSnackBar(context, e.toString());
    return null;
  }
}

}