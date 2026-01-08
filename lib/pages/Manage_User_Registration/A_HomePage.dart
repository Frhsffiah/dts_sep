import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../provider/LoginController.dart';
import '../../ui/common/daie_header.dart';
import '../../ui/common/admin_nav.dart';
import 'A_PendingListPage.dart';
import '../Manage_User_Profile/A_ViewPreacherListPage.dart';
import '../Manage_User_Profile/A_ViewOfficerListPage.dart';

class AHomePage extends StatefulWidget {
  final String adminId;
  const AHomePage({super.key, required this.adminId});

  @override
  State<AHomePage> createState() => _AHomePageState();
}

class _AHomePageState extends State<AHomePage> {
  int _index = 1;
  int _imgIndex = 0;

  final images = ['assets/images/admin1.jpg', 'assets/images/admin2.jpg'];

  void _onNavTap(int i) {
    if (i == 0) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const APendingListPage()),
      );
    } else if (i == 2) {
      _showProfileMenu();
    } else {
      setState(() => _index = 1);
    }
  }

  void _showProfileMenu() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: const Icon(Icons.people),
            title: const Text("View Preachers"),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const AViewPreacherListPage(),
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.badge),
            title: const Text("View Officers"),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const AViewOfficerListPage()),
              );
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final adminName = LoginController.currentUser?.fullName ?? 'Admin';

    return Scaffold(
      appBar: const DaieHeader(),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "Welcome to $adminName!",
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 24),
            _imageCarousel(),
          ],
        ),
      ),
      bottomNavigationBar: AdminNav(currentIndex: _index, onTap: _onNavTap),
    );
  }

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
