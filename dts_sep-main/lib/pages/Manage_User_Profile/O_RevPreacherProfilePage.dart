import 'package:dts_sep/pages/Manage_KPI/O_KpiList.dart' show O_KpiListPage;
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../ui/common/daie_header.dart';
import '../../ui/common/officer_nav.dart';
import '../Manage_Activity/O_ActivityListPage.dart';
import '../Manage_KPI/O_KpiListPage.dart'; // ✅ change path to your actual KPI list file

class ORevPreacherProfilePage extends StatelessWidget {
  final String preacherId;
  const ORevPreacherProfilePage({super.key, required this.preacherId});

  static const Color mainBlue = Color(0xFF7DD3FC);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const DaieHeader(),
      body: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
        stream: FirebaseFirestore.instance.collection('preachers').doc(preacherId).snapshots(),
        builder: (context, snap) {
          if (snap.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snap.hasData || !snap.data!.exists) {
            return const Center(child: Text("Profile not found"));
          }

          final data = snap.data!.data();
          if (data == null) {
            return const Center(child: Text("Profile not found"));
          }

          return Center(
            child: Container(
              width: 320,
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(.12), blurRadius: 8)],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    "Preacher Profile",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900),
                  ),
                  const SizedBox(height: 20),

                  _field("Full Name", (data['fullName'] ?? '').toString()),
                  _field("Phone Number", (data['phoneNumber'] ?? '').toString()),
                  _field("Email", (data['email'] ?? '').toString()),
                  _field("Address", (data['address'] ?? '').toString()),
                  _field("Role", "Preacher"),

                  const SizedBox(height: 20),

                  // ✅ Two separate buttons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _navBtn(
                        text: "Activity",
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              // If your Activity list is filtered by preacherId, pass preacherId.
                              // If it requires officerId, change param accordingly.
                              builder: (_) => O_ActivityList(preacherId: preacherId, officerId: '',),
                            ),
                          );
                        },
                      ),
                      _navBtn(
                        text: "KPI",
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              // Use your actual KPI list page class name
                              builder: (_) => O_KpiListPage(preacherId: preacherId),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
      bottomNavigationBar: OfficerNav(
        currentIndex: 0,
        onTap: (i) {
          if (i == 1) Navigator.pop(context);
        },
      ),
    );
  }

  Widget _navBtn({required String text, required VoidCallback onPressed}) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: mainBlue,
        foregroundColor: Colors.black,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        padding: const EdgeInsets.symmetric(horizontal: 26, vertical: 12),
      ),
      onPressed: onPressed,
      child: Text(text, style: const TextStyle(fontWeight: FontWeight.bold)),
    );
  }

  Widget _field(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700)),
          const SizedBox(height: 4),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(value.isEmpty ? "-" : value),
          ),
        ],
      ),
    );
  }
}
