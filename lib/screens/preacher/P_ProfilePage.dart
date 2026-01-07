import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../ui/common/daie_header.dart';
import '../../ui/common/preacher_nav.dart';
import 'P_EditProfilePage.dart';
import 'P_HomePage.dart';

class PProfilePage extends StatelessWidget {
  final String userId;

  const PProfilePage({super.key, required this.userId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const DaieHeader(),
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection('preachers')
            .doc(userId)
            .snapshots(),
        builder: (context, snap) {
          if (snap.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snap.hasData || !snap.data!.exists) {
            return const Center(child: Text("Profile not found"));
          }

          final data = snap.data!.data() as Map<String, dynamic>;

          return Center(
            child: Container(
              width: 320,
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(.12),
                    blurRadius: 8,
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    "Profile",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900),
                  ),
                  const SizedBox(height: 20),

                  _field("Full Name", data['fullName']),
                  _field("Phone Number", data['phoneNumber']),
                  _field("Email", data['email']), // ✅ ADDED
                  _field("Address", data['address']),
                  _field("Role", "Preacher"),

                  const SizedBox(height: 18),

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
                          builder: (_) =>
                              PEditProfilePage(userId: userId, existing: data),
                        ),
                      );
                    },
                    child: const Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 30,
                        vertical: 10,
                      ),
                      child: Text(
                        "Edit",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
      bottomNavigationBar: PreacherNav(
        currentIndex: 2,
        onTap: (i) {
          if (i == 1) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => PHomePage(preacherId: userId)),
            );
          }
        },
      ),
    );
  }

  Widget _field(String label, String? value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 4),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(value ?? "-"),
          ),
        ],
      ),
    );
  }
}
