// lib/domain/Activity/Activity.dart
import 'package:cloud_firestore/cloud_firestore.dart';

class ActivityModel {
  final String activityId;

  final String officerId;
  final String title;
  final String description;
  final String place;

  final Timestamp dateTime;

  final String preacherId;
  final String preacherName;

  final Timestamp? createdAt;
  final Timestamp? updatedAt;

  const ActivityModel({
    required this.activityId,
    required this.officerId,
    required this.title,
    required this.description,
    required this.place,
    required this.dateTime,
    required this.preacherId,
    required this.preacherName,
    this.createdAt,
    this.updatedAt,
  });

  /// Build model from Firestore document
  factory ActivityModel.fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    final d = doc.data() ?? {};
    return ActivityModel(
      activityId: doc.id,
      officerId: (d['officerId'] ?? '').toString(),
      title: (d['title'] ?? '').toString(),
      description: (d['description'] ?? '').toString(),
      place: (d['place'] ?? '').toString(),
      dateTime: (d['dateTime'] as Timestamp?) ?? Timestamp.now(),
      preacherId: (d['preacherId'] ?? '').toString(),
      preacherName: (d['preacherName'] ?? '').toString(),
      createdAt: d['createdAt'] as Timestamp?,
      updatedAt: d['updatedAt'] as Timestamp?,
    );
  }

  /// Convert model to Firestore map (for add/update)
  Map<String, dynamic> toMap() => {
        'officerId': officerId,
        'title': title,
        'description': description,
        'place': place,
        'dateTime': dateTime,
        'preacherId': preacherId,
        'preacherName': preacherName,
        'createdAt': createdAt,
        'updatedAt': updatedAt,
      };
}
