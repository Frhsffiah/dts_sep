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

      // 🎨 Colors
      selectedItemColor: const Color(0xFF5A63F2),
      unselectedItemColor: Colors.grey,

      // 👇 HIDE TEXT LABELS (THIS IS THE KEY)
      showSelectedLabels: false,
      showUnselectedLabels: false,

      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.assignment),
          label: "Registration", // required but hidden
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: "Home", // required but hidden
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.people),
          label: "Profiles", // required but hidden
        ),
      ],
    );
  }
}
