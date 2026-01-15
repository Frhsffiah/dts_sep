import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class ReportController extends ChangeNotifier {
  final FirebaseFirestore _db;

  ReportController({FirebaseFirestore? db}) : _db = db ?? FirebaseFirestore.instance;

  // =========================
  // Streams (reports collection)
  // =========================

  Stream<QuerySnapshot<Map<String, dynamic>>> watchReports() {
    return _db.collection('reports').orderBy('createdAt', descending: true).snapshots();
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> watchReportsByYear(String year) {
    return _db
        .collection('reports')
        .where('year', isEqualTo: year)
        .orderBy('createdAt', descending: true)
        .snapshots();
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> watchReportsByPreacher(String preacherId) {
    return _db
        .collection('reports')
        .where('preacherId', isEqualTo: preacherId)
        .orderBy('createdAt', descending: true)
        .snapshots();
  }

  Future<Map<String, dynamic>> computeKpiSummary({
    required String year,
    String? preacherId,
  }) async {
    Query<Map<String, dynamic>> q = _db.collection('kpis').where('year', isEqualTo: year);

    if (preacherId != null && preacherId.isNotEmpty) {
      q = q.where('preacherId', isEqualTo: preacherId);
    }

    final snap = await q.get();
    final docs = snap.docs;

    int kpiCount = docs.length;
    int achievedCount = 0;

    double totalTarget = 0;
    double totalActual = 0;

    // for simple "avg completion" / "overall completion"
    for (final d in docs) {
      final data = d.data();
      final status = (data['status'] ?? '').toString();
      final target = _toNum(data['target']);
      final actual = _toNum(data['actual']);

      totalTarget += target;
      totalActual += actual;

      if (status.toLowerCase() == 'achieved') achievedCount++;
    }

    final completionRate = totalTarget <= 0 ? 0.0 : (totalActual / totalTarget);
    final achievedRate = kpiCount == 0 ? 0.0 : (achievedCount / kpiCount);

    return {
      'year': year,
      'preacherId': preacherId,
      'kpiCount': kpiCount,
      'achievedCount': achievedCount,
      'pendingCount': (kpiCount - achievedCount),
      'totalTarget': totalTarget,
      'totalActual': totalActual,
      'completionRate': completionRate, // 0.0 - 1.0
      'achievedRate': achievedRate, // 0.0 - 1.0
      'computedAt': DateTime.now().toIso8601String(),
    };
  }

  // =========================
  // Create/Update a stored report doc
  // =========================

  Future<void> generateReport({
    required String officerId,
    required String year,
    String? preacherId,
    String? preacherName,
    String? reportId,
  }) async {
    final summary = await computeKpiSummary(year: year, preacherId: preacherId);

    final id = (reportId != null && reportId.isNotEmpty)
        ? reportId
        : _defaultReportId(year: year, preacherId: preacherId);

    final ref = _db.collection('reports').doc(id);

    await ref.set({
      // identity
      'reportId': id,
      'year': year,
      'preacherId': preacherId,
      'preacherName': preacherName,
      'officerId': officerId,

      // numbers
      'kpiCount': summary['kpiCount'],
      'achievedCount': summary['achievedCount'],
      'pendingCount': summary['pendingCount'],
      'totalTarget': summary['totalTarget'],
      'totalActual': summary['totalActual'],
      'completionRate': summary['completionRate'],
      'achievedRate': summary['achievedRate'],

      // meta
      'updatedAt': FieldValue.serverTimestamp(),
      'createdAt': FieldValue.serverTimestamp(), // will overwrite if exists; adjust below if you want preserve
    }, SetOptions(merge: true));
  }

  /// Delete a generated report doc.
  Future<void> deleteReport(String reportId) async {
    await _db.collection('reports').doc(reportId).delete();
  }

  Future<List<Map<String, dynamic>>> computePreacherYearBreakdown({
    required String preacherId,
  }) async {
    final snap = await _db.collection('kpis').where('preacherId', isEqualTo: preacherId).get();

    // group by year
    final Map<String, List<Map<String, dynamic>>> byYear = {};
    for (final d in snap.docs) {
      final data = d.data();
      final year = (data['year'] ?? '').toString();
      byYear.putIfAbsent(year, () => []).add(data);
    }

    final results = <Map<String, dynamic>>[];
    for (final entry in byYear.entries) {
      final year = entry.key;
      final docs = entry.value;

      double totalTarget = 0;
      double totalActual = 0;
      int achievedCount = 0;

      for (final k in docs) {
        totalTarget += _toNum(k['target']);
        totalActual += _toNum(k['actual']);
        if ((k['status'] ?? '').toString().toLowerCase() == 'achieved') achievedCount++;
      }

      results.add({
        'year': year,
        'kpiCount': docs.length,
        'achievedCount': achievedCount,
        'pendingCount': docs.length - achievedCount,
        'totalTarget': totalTarget,
        'totalActual': totalActual,
        'completionRate': totalTarget <= 0 ? 0.0 : (totalActual / totalTarget),
      });
    }

    // sort by year ascending (string years)
    results.sort((a, b) => (a['year'] as String).compareTo(b['year'] as String));
    return results;
  }

  // =========================
  // Utilities
  // =========================

  String _defaultReportId({required String year, String? preacherId}) {
    if (preacherId == null || preacherId.isEmpty) return 'year_$year';
    return 'year_${year}_preacher_$preacherId';
  }

  double _toNum(dynamic v) {
    if (v == null) return 0;
    if (v is int) return v.toDouble();
    if (v is double) return v;
    return double.tryParse(v.toString()) ?? 0;
  }
}
