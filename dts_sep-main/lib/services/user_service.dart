import 'package:cloud_firestore/cloud_firestore.dart';

class UserService {
  final _users = FirebaseFirestore.instance.collection('users');

  Stream<QuerySnapshot<Map<String, dynamic>>> watchPreachers() {
    return _users.where('role', isEqualTo: 'preacher').orderBy('fullName').snapshots();
  }
}
