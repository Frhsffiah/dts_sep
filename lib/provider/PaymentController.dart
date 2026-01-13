// lib/provider/PaymentController.dart
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../domain/Payment/PaymentModel.dart';
import 'LoginController.dart';

class PaymentController extends ChangeNotifier {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  bool loading = false;
  String? error;

  /// ==================================
  /// Load activities for dropdown
  /// ==================================
  Future<List<QueryDocumentSnapshot<Map<String, dynamic>>>>
      getActivitiesByPreacher(String preacherId) async {
    final snap = await _db
        .collection('activities')
        .where('preacherId', isEqualTo: preacherId)
        .get();

    return snap.docs;
  }

  /// ===============================
  /// Officer: Make payment to preacher
  /// ===============================
  Future<bool> makePayment({
    required String preacherId,
    required String activityId,
    required String activityTitle,
    required double amount,
    required String paymentType,
    required String bank,
    required String accountNumber,
  }) async {
    loading = true;
    error = null;
    notifyListeners();

    try {
      final officer = LoginController.currentUser;
      if (officer == null) {
        error = "Officer not logged in";
        loading = false;
        notifyListeners();
        return false;
      }

      if (amount <= 0) {
        error = "Invalid amount";
        loading = false;
        notifyListeners();
        return false;
      }

      // 🔒 Prevent duplicate payment for same activity
      final existing = await _db
          .collection('payments')
          .where('activityId', isEqualTo: activityId)
          .limit(1)
          .get();

      if (existing.docs.isNotEmpty) {
        error = "Payment already exists for this activity";
        loading = false;
        notifyListeners();
        return false;
      }

      await _db.collection('payments').add({
        'preacherId': preacherId,
        'officerId': officer.userId,
        'activityId': activityId,
        'activityTitle': activityTitle,
        'amount': amount,
        'paymentType': paymentType,
        'bank': bank,
        'accountNumber': accountNumber,
        'status': 'Approved',
        'createdAt': Timestamp.now(),
      });

      loading = false;
      notifyListeners();
      return true;
    } catch (e) {
      error = e.toString();
      loading = false;
      notifyListeners();
      return false;
    }
  }

  /// ==================================
  /// Preacher: View all payment records
  /// ==================================
  Stream<List<PaymentModel>> getPaymentsByPreacher(String preacherId) {
    return _db
        .collection('payments')
        .where('preacherId', isEqualTo: preacherId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map(
                (doc) => PaymentModel.fromDoc(
                  doc as DocumentSnapshot<Map<String, dynamic>>,
                ),
              )
              .toList(),
        );
  }

  /// ==================================
  /// Get payment for ONE activity
  /// (1 activity = 1 receipt)
  /// ==================================
  Future<PaymentModel?> getPaymentByActivity(String activityId) async {
    try {
      final q = await _db
          .collection('payments')
          .where('activityId', isEqualTo: activityId)
          .limit(1)
          .get();

      if (q.docs.isEmpty) return null;

      return PaymentModel.fromDoc(
        q.docs.first as DocumentSnapshot<Map<String, dynamic>>,
      );
    } catch (e) {
      error = e.toString();
      notifyListeners();
      return null;
    }
  }
}
