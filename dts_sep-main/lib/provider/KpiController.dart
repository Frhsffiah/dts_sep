import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class KpiController extends ChangeNotifier {
  final _db = FirebaseFirestore.instance;

  // ================= ADD KPI =================
  Future<void> addKpi({
    required String officerId,
    required String title,
    required String description,
    required String year,
    required int target,
    required int actual,
    required String status,
    required String preacherId,
    required String preacherName,
  }) async {
    await _db.collection('kpis').add({
      'title': title,
      'description': description,
      'year': year,
      'target': target,
      'actual': actual,
      'status': status,
      'preacherId': preacherId,
      'preacherName': preacherName,
      'officerId': officerId,
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  // ================= UPDATE KPI =================
  Future<void> updateKpi({
    required String kpiId,
    required int actual,
  }) async {
    final status = actual >=
            (await _db.collection('kpis').doc(kpiId).get())
                .data()!['target']
        ? "Achieved"
        : "Pending";

    await _db.collection('kpis').doc(kpiId).update({
      'actual': actual,
      'status': status,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  // ================= WATCH KPIs =================
  Stream<QuerySnapshot<Map<String, dynamic>>> watchKpis() {
    return _db
        .collection('kpis')
        .orderBy('createdAt', descending: true)
        .snapshots();
  }

  // ================= WATCH KPIs BY PREACHER =================
  Stream<QuerySnapshot<Map<String, dynamic>>> watchKpisByPreacher(String preacherId) {
    return _db
        .collection('kpis')
        .where('preacherId', isEqualTo: preacherId)
        .snapshots();
  }
}
