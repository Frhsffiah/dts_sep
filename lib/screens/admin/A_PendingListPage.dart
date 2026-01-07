import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../services/registration_service.dart';
import '../../ui/common/daie_header.dart';
import '../../ui/common/dt_theme.dart';
import '../../ui/common/admin_nav.dart';
import 'A_ReviewRegPage.dart';
import 'A_HomePage.dart';
import 'A_ViewPreacherListPage.dart';

class APendingListPage extends StatelessWidget {
  const APendingListPage({super.key});

  void _onNavTap(BuildContext context, int index) {
    if (index == 1) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => const AHomePage(adminId: "admin_001"),
        ),
      );
    } else if (index == 2) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const AViewPreacherListPage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final reg = RegistrationService();

    return Scaffold(
      appBar: const DaieHeader(),
      body: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          children: [
            Row(
              children: [
                DtTheme.pillButton("Back", () => Navigator.pop(context)),
                const Spacer(),
                const Text(
                  "Registration List",
                  style: TextStyle(fontWeight: FontWeight.w900),
                ),
                const Spacer(),
              ],
            ),
            const SizedBox(height: 14),

            Expanded(
              child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                stream: reg.watchPending(),
                builder: (context, snap) {
                  if (!snap.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  final docs = snap.data!.docs;
                  if (docs.isEmpty) {
                    return const Center(child: Text("No pending registration"));
                  }

                  return ListView.separated(
                    itemCount: docs.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 10),
                    itemBuilder: (_, i) {
                      final doc = docs[i];

                      return Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: DtTheme.headerBlue,
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                doc['fullName'],
                                style: const TextStyle(
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ),
                            DtTheme.pillButton("Review", () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) =>
                                      AReviewRegPage(requestId: doc.id),
                                ),
                              );
                            }),
                          ],
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: AdminNav(
        currentIndex: 0,
        onTap: (i) => _onNavTap(context, i),
      ),
    );
  }
}
