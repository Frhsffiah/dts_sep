import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../provider/RegisterController.dart';
import '../../ui/common/daie_header.dart';
import '../../ui/common/dt_theme.dart';
import '../../ui/common/admin_nav.dart';
import 'A_HomePage.dart';

class AReviewRegPage extends StatelessWidget {
  final String requestId;
  const AReviewRegPage({super.key, required this.requestId});

  @override
  Widget build(BuildContext context) {
    final reg = context.read<RegisterController>();

    return Scaffold(
      appBar: const DaieHeader(),
      body: FutureBuilder<Map<String, dynamic>?>(
        future: reg.getRequestById(requestId),
        builder: (_, snap) {
          if (!snap.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final data = snap.data!;
          return DtTheme.screenCard(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  "Registration Detail",
                  style: TextStyle(fontWeight: FontWeight.w900),
                ),
                const SizedBox(height: 14),
                _field("Full Name", data['fullName']),
                _field("Phone Number", data['phoneNumber']),
                _field("Email", data['email']),
                _field("Role", data['roleRequested']),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () async {
                          await reg.approveRequest(requestId);
                          if (!context.mounted) return;
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const AHomePage(adminId: "admin"),
                            ),
                            (_) => false,
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                        ),
                        child: const Text("Approve"),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () async {
                          await reg.rejectRequest(requestId);
                          if (!context.mounted) return;
                          Navigator.pop(context);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                        ),
                        child: const Text("Reject"),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
      bottomNavigationBar: AdminNav(currentIndex: 0, onTap: (_) {}),
    );
  }

  Widget _field(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.w700)),
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
