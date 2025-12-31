import 'package:cloud_firestore/cloud_firestore.dart';

class ActivityService {
  final _col = FirebaseFirestore.instance.collection('activities');

  Stream<QuerySnapshot<Map<String, dynamic>>> watchOfficerActivities(String officerId) {
    return _col
        .where('officerId', isEqualTo: officerId)
        .orderBy('dateTime', descending: false)
        .snapshots();
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> watchPreacherActivities(String preacherId) {
    return _col
        .where('preacherId', isEqualTo: preacherId)
        .orderBy('dateTime', descending: false)
        .snapshots();
  }

  Future<void> addActivity({
    required String officerId,
    required String title,
    required String description,
    required String place,
    required DateTime dateTime,
    required String preacherId,
    required String preacherName,
  }) async {
    final now = DateTime.now();
    await _col.add({
      'officerId': officerId,
      'title': title.trim(),
      'description': description.trim(),
      'place': place.trim(),
      'dateTime': Timestamp.fromDate(dateTime),
      'preacherId': preacherId,
      'preacherName': preacherName,
      'createdAt': Timestamp.fromDate(now),
      'updatedAt': Timestamp.fromDate(now),
    });
  }

  Future<void> updateActivity(
    String id, {
    required String title,
    required String description,
    required String place,
    required DateTime dateTime,
    required String preacherId,
    required String preacherName,
  }) async {
    final now = DateTime.now();
    await _col.doc(id).update({
      'title': title.trim(),
      'description': description.trim(),
      'place': place.trim(),
      'dateTime': Timestamp.fromDate(dateTime),
      'preacherId': preacherId,
      'preacherName': preacherName,
      'updatedAt': Timestamp.fromDate(now),
    });
  }

  Future<void> deleteActivity(String id) async {
    await _col.doc(id).delete();
  }
}
