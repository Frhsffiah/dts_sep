import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../ui/common/daie_header.dart';
import '../../ui/common/officer_nav.dart';
import '../Manage_User_Registration/O_HomePage.dart';
import 'O_ProfilePage.dart';
import 'O_RevPreacherProfilePage.dart';
import '../Manage_Payment/O_MakePaymentPage.dart';

class OfficerRegPreacherPage extends StatelessWidget {
  final String officerId;

  const OfficerRegPreacherPage({super.key, required this.officerId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const DaieHeader(),

      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
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
                final data = doc.data();

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
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.lightBlue.shade200,
                              foregroundColor: Colors.black,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                            ),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => ORevPreacherProfilePage(
                                    preacherId: doc.id,
                                  ),
                                ),
                              );
                            },
                            child: const Text("Review"),
                          ),

                          const SizedBox(height: 8),

                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.yellow.shade600,
                              foregroundColor: Colors.black,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                            ),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => OMakePaymentPage(
                                    preacherId: doc.id,
                                    preacherName: data['fullName'] ?? '',
                                  ),
                                ),
                              );
                            },
                            child: const Text("Make Payment"),
                          ),
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
          if (i == 1) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (_) => OHomePage(officerId: officerId),
              ),
            );
          } else if (i == 2) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (_) => OfficerProfilePage(userId: officerId),
              ),
            );
          }
        },
      ),
    );
  }
}
