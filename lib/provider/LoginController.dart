// lib/provider/LoginController.dart
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../domain/LoginAndProfile/UserModel.dart';

class LoginController extends ChangeNotifier {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  static UserModel? currentUser; // like your AuthService.currentUser

  bool loading = false;
  String? error;

  Future<UserModel?> login({
    required String email,
    required String password,
    required String selectedRole, // admin/officer/preacher
  }) async {
    loading = true;
    error = null;
    notifyListeners();

    try {
      final e = email.trim().toLowerCase();
      final role = selectedRole.trim().toLowerCase();

      final q = await _db
          .collection('users')
          .where('email', isEqualTo: e)
          .where('password', isEqualTo: password.trim())
          .limit(1)
          .get();

      if (q.docs.isEmpty) {
        error = "Invalid email or password";
        loading = false;
        notifyListeners();
        return null;
      }

      final doc = q.docs.first;
      final user = UserModel.fromDoc(
        doc as DocumentSnapshot<Map<String, dynamic>>,
      );

      if (user.role.toLowerCase() != role) {
        error = "You selected the wrong role for this account";
        loading = false;
        notifyListeners();
        return null;
      }

      currentUser = user;
      loading = false;
      notifyListeners();
      return user;
    } catch (e) {
      error = e.toString();
      loading = false;
      notifyListeners();
      return null;
    }
  }

  void logout() {
    currentUser = null;
    notifyListeners();
  }
}
