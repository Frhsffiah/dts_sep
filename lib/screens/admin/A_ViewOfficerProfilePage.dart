import 'package:flutter/material.dart';

import '../../ui/common/daie_header.dart';
import '../../ui/common/dt_theme.dart';
import '../../ui/common/admin_nav.dart';
import 'A_ViewOfficerListPage.dart';
import 'A_HomePage.dart';
import 'A_PendingListPage.dart';

class AdminViewOfficerProfilePage extends StatelessWidget {
  final Map<String, dynamic> data;

  const AdminViewOfficerProfilePage({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const DaieHeader(),
      body: SingleChildScrollView(
        child: DtTheme.screenCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Center(
                child: Text(
                  "Profile Officer",
                  style: TextStyle(fontWeight: FontWeight.w900, fontSize: 16),
                ),
              ),
              const SizedBox(height: 20),

              _field("Full Name", (data['fullName'] ?? "-").toString()),
              _field("Phone Number", (data['phoneNumber'] ?? "-").toString()),
              _field("Email", (data['email'] ?? "-").toString()),
              _field("Address", (data['address'] ?? "-").toString()),

              const SizedBox(height: 22),

              Center(
                child: DtTheme.pillButton("Back", () => Navigator.pop(context)),
              ),
            ],
          ),
        ),
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
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (_) => const AHomePage(adminId: "admin_001"),
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
