import 'package:cloud_firestore/cloud_firestore.dart';

class RegistrationService {
  final _db = FirebaseFirestore.instance;

  // =========================
  // WATCH PENDING REQUESTS
  // =========================
  Stream<QuerySnapshot<Map<String, dynamic>>> watchPending() {
    return _db
        .collection('registration_requests')
        .where('status', isEqualTo: 'Pending')
        .snapshots();
  }

  // =========================
  // CHECK EMAIL EXISTS
  // =========================
  Future<bool> emailExists(String email) async {
    final e = email.toLowerCase();

    final u = await _db.collection('users').where('email', isEqualTo: e).get();

    final r = await _db
        .collection('registration_requests')
        .where('email', isEqualTo: e)
        .get();

    return u.docs.isNotEmpty || r.docs.isNotEmpty;
  }

  // =========================
  // REGISTER (USED BY RegisterPage) ✅ FIX
  // =========================
  Future<void> register({
    required String fullName,
    required String phone,
    required String address,
    required String email,
    required String password,
    required String role, // 'preacher' or 'officer'
  }) async {
    final e = email.trim().toLowerCase();

    // Optional: prevent duplicate email
    final exists = await emailExists(e);
    if (exists) {
      throw Exception("Email already exists");
    }

    await _db.collection('registration_requests').add({
      'fullName': fullName.trim(),
      'phoneNumber': phone.trim(),
      'address': address.trim(),
      'email': e,
      'password': password,
      'roleRequested': role, // ✅ IMPORTANT (approve() expects this)
      'status': 'Pending',
      'submittedAt': FieldValue.serverTimestamp(),
    });
  }

  // =========================
  // GET REQUEST BY ID
  // =========================
  Future<Map<String, dynamic>?> get(String id) async {
    final d = await _db.collection('registration_requests').doc(id).get();
    return d.data();
  }

  // =========================
  // APPROVE REQUEST ✅ FIXED
  // =========================
  Future<void> approve(String requestId) async {
    final ref = _db.collection('registration_requests').doc(requestId);
    final snap = await ref.get();

    if (!snap.exists) return;

    final d = snap.data()!;
    final email = (d['email'] ?? '').toString().trim().toLowerCase();

    // 🔑 Generate ONE consistent user ID
    final userId = _db.collection('users').doc().id;

    // 1️⃣ USERS
    await _db.collection('users').doc(userId).set({
      'fullName': d['fullName'] ?? '-',
      'email': email,
      'phoneNumber': d['phoneNumber'] ?? '-',
      'password': d['password'] ?? '',
      'role': d['roleRequested'] ?? '',
      'status': 'Active',
      'createdAt': FieldValue.serverTimestamp(),
    });

    // 2️⃣ PROFILE (officers / preachers)
    final profileCol = (d['roleRequested'] == 'officer')
        ? 'officers'
        : 'preachers';

    await _db.collection(profileCol).doc(userId).set({
      'fullName': d['fullName'] ?? '-',
      'email': email,
      'phoneNumber': d['phoneNumber'] ?? '-',
      'address': d['address'] ?? '-', // ✅ SAFE
      'createdAt': FieldValue.serverTimestamp(),
    });

    // 3️⃣ Mark request approved
    await ref.update({'status': 'Approved'});
  }

  // =========================
  // REJECT REQUEST
  // =========================
  Future<void> reject(String id) async {
    await _db.collection('registration_requests').doc(id).update({
      'status': 'Rejected',
    });
  }
}
