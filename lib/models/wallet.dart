// // wallet.dart
// import 'dart:convert';

// class Wallet {
//   final int mainBalance;
//   final int winningBalance;
//   late final int bonusBalance;
//   late final int coinBalance;
//   final int redeemBalance;
//   final DateTime createdAt;
//   final DateTime updatedAt;

//   Wallet({
//     required this.mainBalance,
//     required this.winningBalance,
//     required this.bonusBalance,
//     required this.coinBalance,
//     required this.redeemBalance,
//     required this.createdAt,
//     required this.updatedAt,
//   });

//   /// Creates a Wallet object from a Map.
//   factory Wallet.fromMap(Map<String, dynamic> map) {
//     return Wallet(
//       mainBalance: map['mainBalance'] ?? 0,
//       winningBalance: map['winningBalance'] ?? 0,
//       bonusBalance: map['bonusBalance'] ?? 0,
//       coinBalance: map['coinBalance'] ?? 0,
//       redeemBalance: map['redeemBalance'] ?? 0,
//       createdAt: map['createdAt'] != null 
//           ? DateTime.parse(map['createdAt'])
//           : DateTime.now(),
//       updatedAt: map['updatedAt'] != null 
//           ? DateTime.parse(map['updatedAt'])
//           : DateTime.now(),
//     );
//   }

//   /// Converts the Wallet object to a Map.
//   Map<String, dynamic> toMap() {
//     return {
//       'mainBalance': mainBalance,
//       'winningBalance': winningBalance,
//       'bonusBalance': bonusBalance,
//       'coinBalance': coinBalance,
//       'redeemBalance': redeemBalance,
//       'createdAt': createdAt.toIso8601String(),
//       'updatedAt': updatedAt.toIso8601String(),
//     };
//   }

//   /// Converts the Wallet object to a JSON string.
//   String toJson() => json.encode(toMap());

//   /// Creates a Wallet object from a JSON string.
//   factory Wallet.fromJson(String source) =>
//       Wallet.fromMap(json.decode(source));
// }
import 'dart:convert';

class Wallet {
  final int mainBalance;
  late  int winningBalance;
  final int bonusBalance;
  final int coinBalance;
  late  int redeemBalance;
  final DateTime createdAt;
  final DateTime updatedAt;

  Wallet({
    required this.mainBalance,
    required this.winningBalance,
    required this.bonusBalance,
    required this.coinBalance,
    required this.redeemBalance,
    required this.createdAt,
    required this.updatedAt,
  });

  /// Creates a Wallet object from a Map.
  factory Wallet.fromMap(Map<String, dynamic> map) {
    return Wallet(
      mainBalance: map['mainBalance'] is int
          ? map['mainBalance']
          : (map['mainBalance'] as num?)?.toInt() ?? 0,
      winningBalance: map['winningBalance'] is int
          ? map['winningBalance']
          : (map['winningBalance'] as num?)?.toInt() ?? 0,
      bonusBalance: map['bonusBalance'] is int
          ? map['bonusBalance']
          : (map['bonusBalance'] as num?)?.toInt() ?? 0,
      coinBalance: map['coinBalance'] is int
          ? map['coinBalance']
          : (map['coinBalance'] as num?)?.toInt() ?? 0,
      redeemBalance: map['redeemBalance'] is int
          ? map['redeemBalance']
          : (map['redeemBalance'] as num?)?.toInt() ?? 0,
      createdAt: map['createdAt'] != null 
          ? DateTime.parse(map['createdAt'])
          : DateTime.now(),
      updatedAt: map['updatedAt'] != null 
          ? DateTime.parse(map['updatedAt'])
          : DateTime.now(),
    );
  }

  /// Converts the Wallet object to a Map.
  Map<String, dynamic> toMap() {
    return {
      'mainBalance': mainBalance,
      'winningBalance': winningBalance,
      'bonusBalance': bonusBalance,
      'coinBalance': coinBalance,
      'redeemBalance': redeemBalance,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  /// Converts the Wallet object to a JSON string.
  String toJson() => json.encode(toMap());

  /// Creates a Wallet object from a JSON string.
  factory Wallet.fromJson(String source) =>
      Wallet.fromMap(json.decode(source));
}
