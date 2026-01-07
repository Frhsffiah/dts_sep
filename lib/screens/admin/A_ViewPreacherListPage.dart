import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../ui/common/daie_header.dart';
import '../../ui/common/dt_theme.dart';
import '../../ui/common/admin_nav.dart';
import 'A_PendingListPage.dart';
import 'A_ViewOfficerListPage.dart';
import 'A_ViewPreacherProfilePage.dart';

class AViewPreacherListPage extends StatelessWidget {
  const AViewPreacherListPage({super.key});

  void _showProfileMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: const Icon(Icons.people),
            title: const Text("View Preachers"),
            onTap: () => Navigator.pop(context),
          ),
          ListTile(
            leading: const Icon(Icons.badge),
            title: const Text("View Officers"),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const AViewOfficerListPage()),
              );
            },
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const DaieHeader(),

      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('preachers').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final docs = snapshot.data!.docs;

          if (docs.isEmpty) {
            return const Center(child: Text("No registered preachers"));
          }

          return DtTheme.screenCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Center(
                  child: Text(
                    "Registered Preachers",
                    style: TextStyle(fontWeight: FontWeight.w900, fontSize: 16),
                  ),
                ),
                const SizedBox(height: 20),

                ...docs.map((doc) {
                  final data = doc.data() as Map<String, dynamic>;

                  return Padding(
                    padding: const EdgeInsets.only(bottom: 14),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            data['fullName'] ?? "-",
                            style: const TextStyle(fontWeight: FontWeight.w700),
                          ),
                        ),
                        DtTheme.pillButton("View", () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  AViewPreacherProfilePage(data: data),
                            ),
                          );
                        }),
                      ],
                    ),
                  );
                }).toList(),
              ],
            ),
          );
        },
      ),

      bottomNavigationBar: AdminNav(
        currentIndex: 2,
        onTap: (i) {
          if (i == 0) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const APendingListPage()),
            );
          } else if (i == 1) {
            Navigator.popUntil(context, (r) => r.isFirst);
          } else if (i == 2) {
            _showProfileMenu(context); // ✅ FIX
          }
        },
      ),
    );
  }
}
