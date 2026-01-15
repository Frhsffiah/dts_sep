import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../ui/common/daie_header.dart';

class P_ViewReportPage extends StatelessWidget {
  final String reportId;
  const P_ViewReportPage({super.key, required this.reportId});

  @override
  Widget build(BuildContext context) {
    final reportRef = FirebaseFirestore.instance.collection('reports').doc(reportId);

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
            stream: reportRef.snapshots(),
            builder: (context, snap) {
              if (!snap.hasData) {
                return const Center(child: CircularProgressIndicator());
              }
              if (!snap.data!.exists) {
                return const Center(child: Text("Report not found"));
              }

              final data = snap.data!.data() ?? {};

              final title = (data['title'] ?? data['reportTitle'] ?? '').toString();
              final date = (data['date'] ?? data['year'] ?? '').toString();
              final desc = (data['description'] ?? '').toString();
              final participants = (data['participants'] ?? data['numberOfParticipants'] ?? '').toString();
              final evidence = (data['evidence'] ?? '').toString();

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Report",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900),
                  ),
                  const SizedBox(height: 10),

                  _label("Report Title"),
                  _readBox(title),

                  const SizedBox(height: 10),
                  _label("Date"),
                  _readBox(date),

                  const SizedBox(height: 10),
                  _label("Description"),
                  _readBox(desc, minLines: 4),

                  const SizedBox(height: 10),
                  _label("Number of participants"),
                  _readBox(participants),

                  const SizedBox(height: 10),
                  _label("Evidence"),
                  _readBox(evidence, minLines: 2),

                  const Spacer(),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _pillButton("Back", () => Navigator.pop(context)),
                      _pillButton("Close", () => Navigator.pop(context)),
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

  Widget _label(String text) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 6),
      child: Text(
        text,
        style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 12),
      ),
    );
  }

  Widget _readBox(String value, {int minLines = 1}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFFE7E7E7),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        value.isEmpty ? "-" : value,
        style: TextStyle(
          color: Colors.black.withOpacity(.75),
          fontSize: 12,
          height: 1.3,
        ),
      ),
    );
  }

  Widget _pillButton(String text, VoidCallback onTap) {
    return SizedBox(
      height: 30,
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFE7E7E7),
          foregroundColor: Colors.black,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 14),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        ),
        child: Text(text, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 12)),
      ),
    );
  }
}
