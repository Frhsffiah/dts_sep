import 'package:cloud_firestore/cloud_firestore.dart';

Future<void> addUser() async {
  await FirebaseFirestore.instance.collection('users').add({
    'name': 'Farah',
    'email': 'farah@gmail.com',
    'role': 'student',
  });
}
