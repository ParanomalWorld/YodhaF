import 'dart:convert';

import 'package:yodha_a/models/wallet.dart';

class User {
  final String id;
  final String firstName;
  final String lastName;
  final String userName;
  final String email;
  final int mobileNumber;
  final String password;
  final String address;
  final String type;
  final String userId;
  final String date;
  final String token;
  final Wallet? wallet; // Optional wallet object

  User({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.userName,
    required this.email,
    required this.mobileNumber,
    required this.password,
    required this.address,
    required this.type,
    required this.userId,
    required this.date,
    required this.token,
    this.wallet,
  });

  // Converts a User object to a Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'firstName': firstName,
      'lastName': lastName,
      'userName': userName,
      'email': email,
      'mobileNumber': mobileNumber,
      'password': password,
      'address': address,
      'type': type,
      'userId': userId,
      'date': date,
      'token': token,
      'wallet': wallet?.toMap(),

    };
  }

  // Converts a Map to a User object
  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['_id'] ?? '',
      firstName: map['firstName'] ?? '',
      lastName: map['lastName'] ?? '',
      userName: map['userName'] ?? '',
      email: map['email'] ?? '',
      mobileNumber: map['mobileNumber'] is int
          ? map['mobileNumber']
          : int.tryParse(map['mobileNumber'].toString()) ?? 0,
      password: map['password'] ?? '',
      address: map['address'] ?? '',
      type: map['type'] ?? '',
      userId: map['userId'] ?? '',
      date: map['date'] ?? '',
      token: map['token'] ?? '',
      wallet: map['wallet'] != null ? Wallet.fromMap(map['wallet']) : null,

    );
  }

  // Converts a User object to JSON string
  String toJson() => json.encode(toMap());

  // Converts JSON string to a User object
  factory User.fromJson(String source) {
    final Map<String, dynamic> map = json.decode(source);
    return User.fromMap(map);
  }

  // Creates a new User object by copying the existing one with modified properties
  User copyWith({
    String? id,
    String? firstName,
    String? lastName,
    String? userName,
    String? email,
    int? mobileNumber,
    String? password,
    String? address,
    String? type,
    String? userId,
    String? date,
    String? token,
    Wallet? wallet, // Correct: explicitly type as Wallet? // ✅ Update only wallet if provided
  }) {
    return User(
      id: id ?? this.id,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      userName: userName ?? this.userName,
      email: email ?? this.email,
      mobileNumber: mobileNumber ?? this.mobileNumber,
      password: password ?? this.password,
      address: address ?? this.address,
      type: type ?? this.type,
      userId: userId ?? this.userId,
      date: date ?? this.date,
      token: token ?? this.token,
      wallet: wallet ?? this.wallet,
    );
  }
}
