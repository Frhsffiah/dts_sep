import 'package:flutter/material.dart';

class OfficerNav extends StatelessWidget {
  final int currentIndex; // 0=activity,1=home,2=profile
  final void Function(int) onTap;
  const OfficerNav({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70,
      decoration: BoxDecoration(
        color: Colors.grey.shade300,
        border: Border(top: BorderSide(color: Colors.black.withOpacity(.2))),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _item(
            index: 0,
            selectedIcon: Icons.calendar_month, // ✅ like design
            unselectedIcon: Icons.calendar_month_outlined,
          ),
          _item(
            index: 1,
            selectedIcon: Icons.home,
            unselectedIcon: Icons.home_outlined,
          ),
          _item(
            index: 2,
            selectedIcon: Icons.person,
            unselectedIcon: Icons.person_outline,
          ),
        ],
      ),
    );
  }

  Widget _item({
    required int index,
    required IconData selectedIcon,
    required IconData unselectedIcon,
  }) {
    final selected = index == currentIndex;
    return IconButton(
      onPressed: () => onTap(index),
      icon: Icon(
        selected ? selectedIcon : unselectedIcon,
        size: 30,
        color: selected ? Colors.black : Colors.black54,
      ),
    );
  }
}
