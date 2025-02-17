import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:yodha_a/constants/error_handling.dart';
import 'package:yodha_a/constants/global_variables.dart';
import 'package:yodha_a/constants/utils.dart';
import 'package:yodha_a/models/users.dart';
import 'package:yodha_a/providers/user_provider.dart';

class SearchServices {
  
Future<List<User>> fetchUserId({
  required BuildContext context,
  required String searchQuery
  
  }) async{
  final userProvider = Provider.of<UserProvider>(context, listen: false);
  List<User> emaillList = [];
  try {

    http.Response res = 

    await http.get(Uri.parse('$uri/api/get-userId/search/$searchQuery'), 
    headers: {
    'Content-Type': 'application/json; charset=UTF-8',
    'x-auth-token': userProvider.user.token,
  });

  httpErrorHandling(
    response: res, 
    // ignore: use_build_context_synchronously
    context: context, 
    onSuccess: (){
      for (var i = 0; i < jsonDecode(res.body).length; i++) {
        emaillList.add(
          User.fromJson(jsonEncode(jsonDecode(res.body)[i],
          ),
          ),
        );
        
      }
    }
    ); 
    
  } catch (e) {
    // ignore: use_build_context_synchronously
    showSnackBar(context, e.toString());
    
  }
  return emaillList;

}}