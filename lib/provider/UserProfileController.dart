import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserProfileController extends ChangeNotifier {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // =========================
  // ADMIN – LIST
  // =========================

  Stream<QuerySnapshot<Map<String, dynamic>>> watchAllPreachers() {
    return _db.collection('preachers').snapshots();
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> watchAllOfficers() {
    return _db.collection('officers').snapshots();
  }

  // =========================
  // SINGLE PROFILE
  // =========================

  Stream<DocumentSnapshot<Map<String, dynamic>>> watchPreacher(String userId) {
    return _db.collection('preachers').doc(userId).snapshots();
  }

  Stream<DocumentSnapshot<Map<String, dynamic>>> watchOfficer(String userId) {
    return _db.collection('officers').doc(userId).snapshots();
  }

  // =========================
  // UPDATE
  // =========================

  Future<void> updatePreacherProfile({
    required String userId,
    required String fullName,
    required String phoneNumber,
    required String address,
  }) async {
    final now = FieldValue.serverTimestamp();

    await _db.collection('preachers').doc(userId).update({
      'fullName': fullName.trim(),
      'phoneNumber': phoneNumber.trim(),
      'address': address.trim(),
      'updatedAt': now,
    });

    await _db.collection('users').doc(userId).update({
      'fullName': fullName.trim(),
      'phoneNumber': phoneNumber.trim(),
      'updatedAt': now,
    });
  }

  Future<void> updateOfficerProfile({
    required String userId,
    required String fullName,
    required String phoneNumber,
    required String address,
  }) async {
    final now = FieldValue.serverTimestamp();

    await _db.collection('officers').doc(userId).update({
      'fullName': fullName.trim(),
      'phoneNumber': phoneNumber.trim(),
      'address': address.trim(),
      'updatedAt': now,
    });

    await _db.collection('users').doc(userId).update({
      'fullName': fullName.trim(),
      'phoneNumber': phoneNumber.trim(),
      'updatedAt': now,
    });
  }
}
