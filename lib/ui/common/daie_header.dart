import 'package:flutter/material.dart';
import '../../screens/login/LoginPage.dart';

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
          // 🕌 MUIP LOGO (LEFT)
          Image.asset('assets/images/muip.png', height: 26),

          // ⬅️ spacer so title can be centered
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

          // 🔴 LOGOUT BUTTON (RIGHT)
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.red),
            onPressed: () {
              showDialog(
                context: context,
                builder: (_) => AlertDialog(
                  title: const Text("Logout"),
                  content: const Text("Are you sure want to logout?"),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text("No"),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (_) => const LoginPage()),
                          (_) => false,
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
