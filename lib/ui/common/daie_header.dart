import 'package:flutter/material.dart';

class DaieHeader extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  const DaieHeader({super.key, this.title = "DaieTrack"});

  @override
  Size get preferredSize => const Size.fromHeight(74);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: Container(
        height: preferredSize.height,
        padding: const EdgeInsets.symmetric(horizontal: 14),
        decoration: BoxDecoration(
          color: const Color(0xFFD6EEF9), // light blue like your UI
          border: Border(
            bottom: BorderSide(color: Colors.black.withOpacity(.2), width: 1),
          ),
          borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(6),
            bottomRight: Radius.circular(6),
          ),
        ),
        child: Row(
          children: [
            const Icon(Icons.notifications_none, size: 30),
            const SizedBox(width: 14),
            Expanded(
              child: Center(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF1F3C88),
                    shadows: [
                      Shadow(offset: Offset(1, 1), blurRadius: 0, color: Colors.black38),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(width: 44), // to balance bell spacing
          ],
        ),
      ),
    );
  }
}
