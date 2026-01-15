import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../provider/UserProfileController.dart';
import '../../ui/common/daie_header.dart';
import '../../ui/common/dt_theme.dart';
import '../../ui/common/admin_nav.dart';
import 'A_ViewOfficerListPage.dart';
import '../Manage_User_Registration/A_HomePage.dart';

class AdminViewOfficerProfilePage extends StatelessWidget {
  final String officerId;
  const AdminViewOfficerProfilePage({super.key, required this.officerId});

  @override
  Widget build(BuildContext context) {
    final controller = UserProfileController();

    return Scaffold(
      appBar: const DaieHeader(),
      body: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
        stream: controller.watchOfficer(officerId),
        builder: (context, snap) {
          if (!snap.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final data = snap.data!.data();
          if (data == null) {
            return const Center(child: Text("Profile not found"));
          }

          return DtTheme.screenCard(
            child: Column(
              children: [
                const Text(
                  "Profile Officer",
                  style: TextStyle(fontWeight: FontWeight.w900, fontSize: 16),
                ),
                const SizedBox(height: 20),

                _field("Full Name", data['fullName']),
                _field("Phone Number", data['phoneNumber']),
                _field("Email", data['email']),
                _field("Address", data['address']),
                _field("Role", "Officer"),

                const SizedBox(height: 20),
                DtTheme.pillButton("Back", () => Navigator.pop(context)),
              ],
            ),
          );
        },
      ),

      bottomNavigationBar: AdminNav(
        currentIndex: 2,
        onTap: (i) {
          if (i == 1) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (_) => const AHomePage(adminId: "admin"),
              ),
            );
          } else if (i == 2) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const AViewOfficerListPage()),
            );
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
