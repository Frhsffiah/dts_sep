import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../provider/UserProfileController.dart';
import '../../ui/common/daie_header.dart';
import '../../ui/common/officer_nav.dart';
import '../Manage_User_Registration/O_HomePage.dart';
import 'O_EditProfilePage.dart';

class OfficerProfilePage extends StatelessWidget {
  final String userId;
  const OfficerProfilePage({super.key, required this.userId});

  static const Color mainBlue = Color(0xFF7DD3FC);

  @override
  Widget build(BuildContext context) {
    final controller = UserProfileController();

    return Scaffold(
      appBar: const DaieHeader(),
      body: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
        stream: controller.watchOfficer(userId),
        builder: (context, snap) {
          if (!snap.hasData) {
            return const Center(child: CircularProgressIndicator());
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
                  _field("Email", data['email']),
                  _field("Address", data['address']),
                  _field("Role", "Officer"),

                  const SizedBox(height: 20),

                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: mainBlue,
                      foregroundColor: Colors.black,
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
                          builder: (_) =>
                              OEditProfilePage(officerId: userId, data: data),
                        ),
                      );
                    },
                    child: const Text(
                      "Edit",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
      bottomNavigationBar: OfficerNav(
        currentIndex: 2,
        onTap: (i) {
          if (i == 1) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => OHomePage(officerId: userId)),
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
