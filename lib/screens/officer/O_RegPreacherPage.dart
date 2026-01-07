import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../ui/common/daie_header.dart';
import '../../ui/common/officer_nav.dart';
import 'O_RevPreacherProfilePage.dart';

class ORegPreacherPage extends StatelessWidget {
  const ORegPreacherPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const DaieHeader(),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('preachers').snapshots(),
        builder: (context, snap) {
          if (snap.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snap.hasData || snap.data!.docs.isEmpty) {
            return const Center(child: Text("No registered preachers"));
          }

          final docs = snap.data!.docs;

          return ListView(
            padding: const EdgeInsets.all(16),
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

                return Container(
                  margin: const EdgeInsets.only(bottom: 14),
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(.08),
                        blurRadius: 6,
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          data['fullName'] ?? "-",
                          style: const TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 14,
                          ),
                        ),
                      ),
                      Column(
                        children: [
                          _blueBtn("Review", () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) =>
                                    ORevPreacherProfilePage(preacherId: doc.id),
                              ),
                            );
                          }),
                          const SizedBox(height: 8),
                          _blueBtn("Make Payment", () {
                            // future feature
                          }),
                        ],
                      ),
                    ],
                  ),
                );
              }).toList(),
            ],
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

  Widget _blueBtn(String text, VoidCallback onTap) {
    return SizedBox(
      width: 120,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.lightBlue.shade200,
          foregroundColor: Colors.black,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          padding: const EdgeInsets.symmetric(vertical: 10),
        ),
        onPressed: onTap,
        child: Text(
          text,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
        ),
      ),
    );
  }
}
