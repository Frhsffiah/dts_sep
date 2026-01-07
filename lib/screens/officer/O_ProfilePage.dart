import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../ui/common/daie_header.dart';
import '../../ui/common/officer_nav.dart';
import '../../ui/common/dt_theme.dart';
import 'O_EditProfilePage.dart';
import 'O_RegPreacherPage.dart';
import 'O_HomePage.dart';

class OProfilePage extends StatelessWidget {
  final String userId;

  const OProfilePage({super.key, required this.userId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const DaieHeader(),
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection('officers')
            .doc(userId)
            .snapshots(),
        builder: (context, snap) {
          if (snap.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snap.hasData || !snap.data!.exists) {
            return const Center(child: Text("Officer profile not found"));
          }

          final data = snap.data!.data() as Map<String, dynamic>;

          return SingleChildScrollView(
            child: DtTheme.screenCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Center(
                    child: Text(
                      "Profile",
                      style: TextStyle(
                        fontWeight: FontWeight.w900,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  _field("Full Name", (data['fullName'] ?? "-").toString()),
                  _field(
                    "Phone Number",
                    (data['phoneNumber'] ?? "-").toString(),
                  ),
                  _field("Email", (data['email'] ?? "-").toString()),
                  _field("Address", (data['address'] ?? "-").toString()),
                  _field("Role", "MUIP Officer"),

                  const SizedBox(height: 22),

                  Center(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF7DD3FC),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 40,
                          vertical: 12,
                        ),
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => OEditProfilePage(
                              officerId: userId, // ✅ FIXED
                              data: data, // ✅ FIXED
                            ),
                          ),
                        );
                      },
                      child: const Text(
                        "Edit",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),

      // ✅ Make nav work from profile page too (left=list, middle=home, right=profile)
      bottomNavigationBar: OfficerNav(
        currentIndex: 2,
        onTap: (i) {
          if (i == 0) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const ORegPreacherPage()),
            );
          } else if (i == 1) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => OHomePage(officerId: userId)),
            );
          } else {
            // already on profile
          }
        },
      ),
    );
  }

  Widget _field(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black12),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(value),
          ),
        ],
      ),
    );
  }
}
