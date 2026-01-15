import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../provider/KpiController.dart';
import '../../ui/common/daie_header.dart';
import 'O_EditKpiPage.dart';

class O_KpiListPage extends StatelessWidget {
  const O_KpiListPage({super.key, required String preacherId});

  @override
  Widget build(BuildContext context) {
    final ctrl = context.read<KpiController>();

    return Scaffold(
      appBar: const DaieHeader(),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: ctrl.watchKpis(),
        builder: (context, snap) {
          if (!snap.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final docs = snap.data!.docs;
          if (docs.isEmpty) {
            return const Center(child: Text("No KPI found"));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: docs.length,
            itemBuilder: (context, i) {
              final d = docs[i];
              final data = d.data();

              return Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                child: ListTile(
                  title: Text(
                    data['title'] ?? '',
                    style: const TextStyle(fontWeight: FontWeight.w800),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Year: ${data['year']}"),
                      Text("Preacher: ${data['preacherName']}"),
                    ],
                  ),
                  trailing: Chip(
                    label: Text(
                      data['status'],
                      style: const TextStyle(color: Colors.white),
                    ),
                    backgroundColor:
                        data['status'] == "Achieved" ? Colors.green : Colors.orange,
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => O_EditKpiPage(
                          kpiId: d.id,
                          kpiData: data,
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
