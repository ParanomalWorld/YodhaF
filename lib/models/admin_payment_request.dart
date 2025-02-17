class AdminPaymentRequest {
  final String id;
  final double amount;
  final String status;
  final DateTime createdAt;

  AdminPaymentRequest({
    required this.id,
    required this.amount,
    required this.status,
    required this.createdAt,
  });

  factory AdminPaymentRequest.fromJson(Map<String, dynamic> json) {
    return AdminPaymentRequest(
      id: json['_id'] ?? "",
      amount: (json['amount'] as num).toDouble(),
      status: json['status'] ?? "open",
      createdAt: DateTime.parse(json['createdAt']),
    );
  }
}
