// lib/models/user_transaction.dart

class UserTransaction {
  final String adminPaymentRequestId;
  final String orderId;
  final double amount;
  final String orderCurrency;
  final Customer customer;
  final String paymentSessionId;
  final String status;
  final DateTime createdAt;

  UserTransaction({
    required this.adminPaymentRequestId,
    required this.orderId,
    required this.amount,
    required this.orderCurrency,
    required this.customer,
    required this.paymentSessionId,
    required this.status,
    required this.createdAt,
  });

  factory UserTransaction.fromJson(Map<String, dynamic> json) {
    return UserTransaction(
      adminPaymentRequestId: json['adminPaymentRequestId'] ??
          json['admin_payment_request_id'] ??
          "",
      orderId: json['orderId'] ?? json['order_id'] ?? "",
      amount: (json['amount'] as num).toDouble(),
      orderCurrency: json['orderCurrency'] ?? json['order_currency'] ?? "INR",
      // Notice we now expect a "customer" object in the JSON.
      customer: Customer.fromJson(json['customer'] ?? {}),
      paymentSessionId: json['paymentSessionId'] ??
          json['payment_session_id'] ??
          "",
      status: json['status'] ?? "created",
      createdAt: DateTime.parse(json['createdAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'adminPaymentRequestId': adminPaymentRequestId,
      'orderId': orderId,
      'amount': amount,
      'orderCurrency': orderCurrency,
      'customer': customer.toJson(),
      'paymentSessionId': paymentSessionId,
      'status': status,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}

class Customer {
  final String id;
  final String firstName;
  final String lastName;
  final int mobileNumber;
  final String email;

  Customer({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.mobileNumber,
    required this.email,
  });

  factory Customer.fromJson(Map<String, dynamic> json) {
    return Customer(
      id: json['_id'] ?? json['id'] ?? "",
      firstName: json['firstName'] ?? "",
      lastName: json['lastName'] ?? "",
      email: json['email'] ?? "",
      mobileNumber: json['mobileNumber'] is int
          ? json['mobileNumber']
          : int.tryParse(json['mobileNumber']?.toString() ?? "0") ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'mobileNumber': mobileNumber,
    };
  }
}
