import 'package:flutter/material.dart';

import '../../provider/LoginController.dart';
import '../../ui/common/daie_header.dart';
import '../../ui/common/officer_nav.dart';
import '../Manage_User_Profile/O_ProfilePage.dart';
import '../Manage_User_Profile/O_RegPreacherPage.dart';

class OHomePage extends StatefulWidget {
  final String officerId;
  const OHomePage({super.key, required this.officerId});

  @override
  State<OHomePage> createState() => _OHomePageState();
}

class _OHomePageState extends State<OHomePage> {
  int _index = 1;
  int _imgIndex = 0;

  final images = ['assets/images/officer1.jpeg', 'assets/images/officer2.jpg'];

  void _onNavTap(int i) {
    setState(() => _index = i);

    if (i == 0) {
      // ✅ PASS officerId properly
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => OfficerRegPreacherPage(officerId: widget.officerId),
        ),
      );
    } else if (i == 2) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => OfficerProfilePage(userId: widget.officerId),
        ),
      );
    }
    // i == 1 → stay on home
  }

  @override
  Widget build(BuildContext context) {
    final officerName = LoginController.currentUser?.fullName ?? 'Officer';

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
            _imageCarousel(),
          ],
        ),
      ),
      bottomNavigationBar: OfficerNav(currentIndex: _index, onTap: _onNavTap),
    );
  }

  // 🔁 Carousel (unchanged)
  Widget _imageCarousel() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          icon: const Icon(Icons.chevron_left, size: 32),
          onPressed: () {
            setState(() {
              _imgIndex = (_imgIndex - 1 + images.length) % images.length;
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
    );
  }
}
