// lib/provider/RegisterController.dart
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RegisterController extends ChangeNotifier {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  bool loading = false;
  String? error;

  // SDD: createRequest(), approveRequest(), rejectRequest(), getPendingRequests()
  // :contentReference[oaicite:3]{index=3}

  Future<bool> emailExists(String email) async {
    final e = email.trim().toLowerCase();

    final u = await _db.collection('users').where('email', isEqualTo: e).get();
    if (u.docs.isNotEmpty) return true;

    final r = await _db
        .collection('registration_requests')
        .where('email', isEqualTo: e)
        .get();
    return r.docs.isNotEmpty;
  }

  Future<void> createRequest({
    required String fullName,
    required String phoneNumber,
    required String address,
    required String email,
    required String password,
    required String roleRequested, // preacher/officer
  }) async {
    loading = true;
    error = null;
    notifyListeners();

    try {
      if (fullName.trim().isEmpty ||
          phoneNumber.trim().isEmpty ||
          email.trim().isEmpty) {
        throw Exception("Error: Missing Required Fields");
      }

      final e = email.trim().toLowerCase();
      final exists = await emailExists(e);
      if (exists) throw Exception("Error: Email Already Exists");

      await _db.collection('registration_requests').add({
        'fullName': fullName.trim(),
        'phoneNumber': phoneNumber.trim(),
        'address': address.trim(),
        'email': e,
        'password': password, // (your current approach)
        'roleRequested': roleRequested.trim().toLowerCase(),
        'status': 'Pending',
        'submittedAt': FieldValue.serverTimestamp(),
      });

      loading = false;
      notifyListeners();
    } catch (e) {
      error = e.toString().replaceAll('Exception: ', '');
      loading = false;
      notifyListeners();
      rethrow;
    }
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getPendingRequests() {
    return _db
        .collection('registration_requests')
        .where('status', isEqualTo: 'Pending')
        .snapshots();
  }

  Future<Map<String, dynamic>?> getRequestById(String requestId) async {
    final d = await _db
        .collection('registration_requests')
        .doc(requestId)
        .get();
    return d.data();
  }

  Future<void> approveRequest(String requestId) async {
    loading = true;
    error = null;
    notifyListeners();

    try {
      final ref = _db.collection('registration_requests').doc(requestId);
      final snap = await ref.get();
      if (!snap.exists) throw Exception("Error: Request Not Found");

      final d = snap.data()!;
      final roleRequested = (d['roleRequested'] ?? '').toString().toLowerCase();
      final email = (d['email'] ?? '').toString().trim().toLowerCase();

      // One consistent userId for users + profile
      final userId = _db.collection('users').doc().id;

      // USERS
      await _db.collection('users').doc(userId).set({
        'fullName': d['fullName'] ?? '-',
        'email': email,
        'phoneNumber': d['phoneNumber'] ?? '-',
        'password': d['password'] ?? '',
        'role': roleRequested,
        'status': 'Active',
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      });

      // PROFILE TABLE
      final profileCol = (roleRequested == 'officer')
          ? 'officers'
          : 'preachers';
      await _db.collection(profileCol).doc(userId).set({
        'fullName': d['fullName'] ?? '-',
        'email': email,
        'phoneNumber': d['phoneNumber'] ?? '-',
        'address': d['address'] ?? '-',
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      });

      // Mark Approved
      await ref.update({'status': 'Approved'});

      loading = false;
      notifyListeners();
    } catch (e) {
      error = e.toString().replaceAll('Exception: ', '');
      loading = false;
      notifyListeners();
      rethrow;
    }
  }

  Future<void> rejectRequest(String requestId) async {
    loading = true;
    error = null;
    notifyListeners();

    try {
      await _db.collection('registration_requests').doc(requestId).update({
        'status': 'Rejected',
      });

      loading = false;
      notifyListeners();
    } catch (e) {
      error = e.toString().replaceAll('Exception: ', '');
      loading = false;
      notifyListeners();
      rethrow;
    }
  }
}
