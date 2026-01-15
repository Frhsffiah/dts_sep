import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../ui/common/daie_header.dart';

class O_ViewReportPage extends StatelessWidget {
  final String reportId;
  const O_ViewReportPage({super.key, required this.reportId});

  @override
  Widget build(BuildContext context) {
    final ref = FirebaseFirestore.instance.collection('reports').doc(reportId);

    return Scaffold(
      appBar: const DaieHeader(),
      body: Center(
        child: Container(
          width: 330,
          margin: const EdgeInsets.only(top: 18),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: const Color(0xFFD8ECF7),
            borderRadius: BorderRadius.circular(16),
          ),
          child: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
            stream: ref.snapshots(),
            builder: (context, snap) {
              if (snap.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (!snap.hasData || !snap.data!.exists) {
                return const Center(child: Text("Report not found"));
              }

              final data = snap.data!.data() ?? {};

              final title = _readStr(data, ['title', 'reportTitle']);
              final date = _readStr(data, ['date', 'year']);
              final desc = _readStr(data, ['description']);
              final participants = _readAnyToStr(data, ['participants', 'numberOfParticipants']);
              final evidence = _readStr(data, ['evidence']);

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Report",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900),
                  ),
                  const SizedBox(height: 12),

                  _label("Report Title"),
                  _box(title),

                  const SizedBox(height: 10),
                  _label("Date"),
                  _box(date),

                  const SizedBox(height: 10),
                  _label("Description"),
                  _box(desc, minHeight: 90),

                  const SizedBox(height: 10),
                  _label("Number of participants"),
                  _box(participants),

                  const SizedBox(height: 10),
                  _label("Evidence"),
                  _box(evidence, minHeight: 55),

                  const Spacer(),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _pillBtn("Back", () => Navigator.pop(context)),
                      _pillBtn("Close", () => Navigator.pop(context)),
                    ],
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  // ================= UI helpers =================

  Widget _label(String text) {
    return Padding(
      padding: const EdgeInsets.only(left: 2, bottom: 6),
      child: Text(
        text,
        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w900),
      ),
    );
  }

  Widget _box(String value, {double? minHeight}) {
    return Container(
      width: double.infinity,
      constraints: BoxConstraints(minHeight: minHeight ?? 0),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFFE7E7E7),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        value.isEmpty ? "-" : value,
        style: TextStyle(
          fontSize: 12,
          height: 1.35,
          color: Colors.black.withOpacity(.75),
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _pillBtn(String text, VoidCallback onTap) {
    return SizedBox(
      height: 30,
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFE7E7E7),
          foregroundColor: Colors.black,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        ),
        child: Text(text, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w900)),
      ),
    );
  }

  // ================= Firestore field helpers =================

  String _readStr(Map<String, dynamic> data, List<String> keys) {
    for (final k in keys) {
      final v = data[k];
      if (v != null) return v.toString();
    }
    return "";
  }

  String _readAnyToStr(Map<String, dynamic> data, List<String> keys) {
    for (final k in keys) {
      final v = data[k];
      if (v == null) continue;
      if (v is num) return v.toString();
      return v.toString();
    }
    return "";
  }
}
