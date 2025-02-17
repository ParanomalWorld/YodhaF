import 'package:flutter/material.dart';
import 'package:yodha_a/models/users.dart';
import 'package:yodha_a/models/wallet.dart';

class UserProvider extends ChangeNotifier {
  User _user = User(
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
    date: '',
    token: '',
    wallet: null, // Initialize as null
    //cart: [],
  );

  User get user => _user;

  void setUser(String user) {
    _user = User.fromJson(user);
    notifyListeners();
  }

  void setUserFromModel(User user) {
    _user = user;
    notifyListeners();
  }

    void setWallet(Wallet wallet) {
    _user = _user.copyWith(wallet: wallet);  // ✅ Fixed property name
    notifyListeners();
  }

}