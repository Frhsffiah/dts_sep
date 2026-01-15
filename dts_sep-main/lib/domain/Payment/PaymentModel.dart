// lib/domain/Payment/PaymentModel.dart
import 'package:cloud_firestore/cloud_firestore.dart';

class PaymentModel {
  final String paymentId;
  final String preacherId;
  final String officerId;
  final String activityId;
  final String activityTitle;
  final double amount;
  final String paymentType;
  final String bank;
  final String accountNumber;
  final String receiptUrl;
  final String status;
  final Timestamp createdAt;

  const PaymentModel({
    required this.paymentId,
    required this.preacherId,
    required this.officerId,
    required this.activityId,
    required this.activityTitle,
    required this.amount,
    required this.paymentType,
    required this.bank,
    required this.accountNumber,
    required this.receiptUrl,
    required this.status,
    required this.createdAt,
  });

  factory PaymentModel.fromDoc(
    DocumentSnapshot<Map<String, dynamic>> doc,
  ) {
    final d = doc.data() ?? {};
    return PaymentModel(
      paymentId: doc.id,
      preacherId: (d['preacherId'] ?? '').toString(),
      officerId: (d['officerId'] ?? '').toString(),
      activityId: (d['activityId'] ?? '').toString(),
      activityTitle: (d['activityTitle'] ?? '').toString(),
      amount: (d['amount'] as num).toDouble(),
      paymentType: (d['paymentType'] ?? '').toString(),
      bank: (d['bank'] ?? '').toString(),
      accountNumber: (d['accountNumber'] ?? '').toString(),
      receiptUrl: (d['receiptUrl'] ?? '').toString(),
      status: (d['status'] ?? '').toString(),
      createdAt: d['createdAt'] as Timestamp,
    );
  }

  Map<String, dynamic> toMap() => {
        'preacherId': preacherId,
        'officerId': officerId,
        'activityId': activityId,
        'activityTitle': activityTitle,
        'amount': amount,
        'paymentType': paymentType,
        'bank': bank,
        'accountNumber': accountNumber,
        'receiptUrl': receiptUrl,
        'status': status,
        'createdAt': createdAt,
      };
}
