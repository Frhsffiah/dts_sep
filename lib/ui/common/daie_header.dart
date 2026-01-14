// lib/ui/common/daie_header.dart
import 'package:flutter/material.dart';

// Login page
import '../../pages/Manage_User_Registration/LoginPage.dart';

class DaieHeader extends StatelessWidget implements PreferredSizeWidget {
  const DaieHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0,
      backgroundColor: const Color(0xFFD6EEF9),
      automaticallyImplyLeading: false,

      title: Row(
        children: [
          // ⬅️ BACK BUTTON (ONLY WHEN POSSIBLE)
          if (Navigator.canPop(context))
            IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.black),
              onPressed: () => Navigator.pop(context),
            ),

          // 🕌 MUIP LOGO
          Image.asset('assets/images/muip.png', height: 26),

          const SizedBox(width: 12),

          // 🟦 CENTER TITLE
          const Expanded(
            child: Center(
              child: Text(
                "DaieTrack",
                style: TextStyle(
                  fontWeight: FontWeight.w900,
                  fontSize: 16,
                  color: Colors.black,
                ),
              ),
            ),
          ),

          // 🔴 LOGOUT BUTTON
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.red),
            onPressed: () {
              showDialog(
                context: context,
                builder: (_) => AlertDialog(
                  title: const Text("Logout"),
                  content: const Text("Are you sure you want to logout?"),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text("No"),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const LoginPage(),
                          ),
                          (route) => false,
                        );
                      },
                      child: const Text("Yes"),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(56);
}
