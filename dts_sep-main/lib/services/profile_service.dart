import 'package:cloud_firestore/cloud_firestore.dart';

class ProfileService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // =========================
  // GET PROFILES
  // =========================

  Stream<DocumentSnapshot<Map<String, dynamic>>> preacher(String id) {
    return _db.collection('preachers').doc(id).snapshots();
  }

  Stream<DocumentSnapshot<Map<String, dynamic>>> officer(String id) {
    return _db.collection('officers').doc(id).snapshots();
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> allPreachers() {
    return _db.collection('preachers').snapshots();
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> allOfficers() {
    return _db.collection('officers').snapshots();
  }

  // =========================
  // UPDATE HELPERS (WRAPPERS)
  // =========================

  Future<void> updatePreacher(String id, Map<String, dynamic> data) async {
    await _updateProfile('preacher', id, data);
  }

  Future<void> updateOfficer(String id, Map<String, dynamic> data) async {
    await _updateProfile('officer', id, data);
  }

  // =========================
  // INTERNAL UPDATE METHOD
  // =========================

  Future<void> _updateProfile(
    String role,
    String id,
    Map<String, dynamic> data,
  ) async {
    final collection = role == 'officer' ? 'officers' : 'preachers';

    await _db.collection(collection).doc(id).update(data);

    // Optional: sync common fields to users table
    await _db.collection('users').doc(id).update({
      'fullName': data['fullName'],
      'phoneNumber': data['phoneNumber'],
      'updatedAt': data['updatedAt'],
    });
  }
}
