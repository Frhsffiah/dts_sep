import 'package:flutter/material.dart';

class PreacherNav extends StatelessWidget {
  final int currentIndex; // 0=activity,1=home,2=profile (you can adjust)
  final void Function(int) onTap;
  const PreacherNav({
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
          _item(Icons.groups_outlined, 0),
          _item(Icons.home_outlined, 1),
          _item(Icons.person_outline, 2),
        ],
      ),
    );
  }

  Widget _item(IconData icon, int index) {
    final selected = index == currentIndex;
    return IconButton(
      onPressed: () => onTap(index),
      icon: Icon(
        icon,
        size: 30,
        color: selected ? Colors.black : Colors.black54,
      ),
    );
  }
}
