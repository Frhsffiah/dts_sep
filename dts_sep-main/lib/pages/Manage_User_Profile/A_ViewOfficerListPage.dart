import 'package:flutter/material.dart';

import '../../provider/UserProfileController.dart';
import '../../ui/common/daie_header.dart';
import '../../ui/common/dt_theme.dart';
import '../../ui/common/admin_nav.dart';
import '../Manage_User_Registration/A_PendingListPage.dart';
import 'A_ViewPreacherListPage.dart';
import 'A_ViewOfficerProfilePage.dart';
import '../Manage_User_Registration/A_HomePage.dart';

class AViewOfficerListPage extends StatelessWidget {
  const AViewOfficerListPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = UserProfileController();

    return Scaffold(
      appBar: const DaieHeader(),
      body: StreamBuilder(
        stream: controller.watchAllOfficers(),
        builder: (context, snap) {
          if (!snap.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final docs = snap.data!.docs;
          if (docs.isEmpty) {
            return const Center(child: Text("No registered officers"));
          }

          return DtTheme.screenCard(
            child: Column(
              children: [
                const Text(
                  "Registered Officers",
                  style: TextStyle(fontWeight: FontWeight.w900, fontSize: 16),
                ),
                const SizedBox(height: 20),

                ...docs.map((doc) {
                  final data = doc.data();
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 14),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            data['fullName'] ?? '-',
                            style: const TextStyle(fontWeight: FontWeight.w700),
                          ),
                        ),
                        DtTheme.pillButton("View", () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => AdminViewOfficerProfilePage(
                                officerId: doc.id,
                              ),
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

      // ✅ FIXED NAVIGATION
      bottomNavigationBar: AdminNav(
        currentIndex: 2,
        onTap: (i) {
          if (i == 0) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => APendingListPage()),
            );
          } else if (i == 1) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (_) => const AHomePage(adminId: "admin"),
              ),
            );
          } else if (i == 2) {
            // 🔁 SWITCH BACK TO PREACHER LIST
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const AViewPreacherListPage()),
            );
          }
        },
      ),
    );
  }
}
