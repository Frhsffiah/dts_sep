import 'package:flutter/material.dart';

class AdminNav extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const AdminNav({super.key, required this.currentIndex, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: onTap,
      type: BottomNavigationBarType.fixed,

      // ✅ ONLY CHANGE: background color
      backgroundColor: Colors.grey.shade300,

      // 🎨 KEEP ORIGINAL COLORS
      selectedItemColor: const Color(0xFF5A63F2),
      unselectedItemColor: Colors.grey,

      // 👇 KEEP LABELS HIDDEN
      showSelectedLabels: false,
      showUnselectedLabels: false,

      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.assignment),
          label: "Registration",
        ),
        BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
        BottomNavigationBarItem(icon: Icon(Icons.people), label: "Profiles"),
      ],
    );
  }
}
