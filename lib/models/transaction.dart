class Transaction {
  final String id;
  final String userId;
  final String walletId;
  final String orderId;
  final String type;
  final double amount;
  final int playCoins;
  final String paymentType;
  final String paymentMethod;
  final String paymentStatus;
  final String remark;
  final bool adminAction;
  final bool fraudCheck;
  final DateTime createdAt;
  final DateTime updatedAt;

  Transaction({
    required this.id,
    required this.userId,
    required this.walletId,
    required this.orderId,
    required this.type,
    required this.amount,
    required this.playCoins,
    required this.paymentType,
    required this.paymentMethod,
    required this.paymentStatus,
    required this.remark,
    required this.adminAction,
    required this.fraudCheck,
    required this.createdAt,
    required this.updatedAt,
  });

  // Factory constructor to create an instance from JSON
  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      id: json['_id'],
      userId: json['user'],
      walletId: json['wallet'],
      orderId: json['orderId'],
      type: json['type'],
      amount: (json['amount'] as num).toDouble(),
      playCoins: json['playCoins'] ?? 0,
      paymentType: json['paymentType'] ?? "Wallet",
      paymentMethod: json['paymentMethod'] ?? "N/A",
      paymentStatus: json['paymentStatus'] ?? "pending",
      remark: json['remark'] ?? "",
      adminAction: json['adminAction'] ?? false,
      fraudCheck: json['fraudCheck'] ?? false,
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }

  // Convert instance to JSON
  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'user': userId,
      'wallet': walletId,
      'orderId': orderId,
      'type': type,
      'amount': amount,
      'playCoins': playCoins,
      'paymentType': paymentType,
      'paymentMethod': paymentMethod,
      'paymentStatus': paymentStatus,
      'remark': remark,
      'adminAction': adminAction,
      'fraudCheck': fraudCheck,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}
