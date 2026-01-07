import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  final _db = FirebaseFirestore.instance;

  // ✅ store logged in user info here (id, role, fullName, etc.)
  static Map<String, dynamic>? currentUser;

  Future<Map<String, dynamic>?> login(String email, String password) async {
    final q = await _db
        .collection('users')
        .where('email', isEqualTo: email.trim().toLowerCase())
        .where('password', isEqualTo: password.trim())
        .limit(1)
        .get();

    if (q.docs.isEmpty) return null;

    final doc = q.docs.first;
    final data = doc.data();

    // ✅ safe read
    final user = {
      'id': doc.id,
      'role': (data['role'] ?? '').toString().toLowerCase(),
      'fullName': (data['fullName'] ?? '').toString(),
      'email': (data['email'] ?? '').toString(),
      'status': (data['status'] ?? '').toString(),
    };

    // ✅ IMPORTANT: set currentUser so HomePages can show the name
    AuthService.currentUser = user;

    return user;
  }

  static void logout() {
    currentUser = null;
  }
}
