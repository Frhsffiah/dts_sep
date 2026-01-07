import 'package:flutter/material.dart';
import '../../services/auth_service.dart';
import '../../ui/common/daie_header.dart';
import '../../ui/common/officer_nav.dart';

import 'O_ProfilePage.dart';
import 'O_RegPreacherPage.dart';

class OHomePage extends StatefulWidget {
  final String officerId;

  const OHomePage({super.key, required this.officerId});

  @override
  State<OHomePage> createState() => _OHomePageState();
}

class _OHomePageState extends State<OHomePage> {
  int _index = 1;
  int _imgIndex = 0;

  final images = ['assets/images/officer1.jpeg', 'assets/images/officer2.jpeg'];

  void _onNavTap(int i) {
    // left icon = Registered Preachers list
    if (i == 0) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const ORegPreacherPage()),
      );
    }
    // middle icon = Home
    else if (i == 1) {
      setState(() => _index = 1);
    }
    // right icon = Profile
    else if (i == 2) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => OProfilePage(userId: widget.officerId), // ✅ FIXED
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final officerName = (AuthService.currentUser?['fullName'] ?? 'Officer')
        .toString();

    return Scaffold(
      appBar: const DaieHeader(),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "Welcome to $officerName!",
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: const Icon(Icons.chevron_left, size: 32),
                  onPressed: () {
                    setState(() {
                      _imgIndex =
                          (_imgIndex - 1 + images.length) % images.length;
                    });
                  },
                ),
                Container(
                  width: 260,
                  height: 180,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.15),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Image.asset(images[_imgIndex], fit: BoxFit.cover),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.chevron_right, size: 32),
                  onPressed: () {
                    setState(() {
                      _imgIndex = (_imgIndex + 1) % images.length;
                    });
                  },
                ),
              ],
            ),
          ],
        ),
      ),
      bottomNavigationBar: OfficerNav(currentIndex: _index, onTap: _onNavTap),
    );
  }
}
