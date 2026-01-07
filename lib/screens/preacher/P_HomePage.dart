import 'package:flutter/material.dart';
import '../../services/auth_service.dart';
import '../../ui/common/daie_header.dart';
import '../../ui/common/preacher_nav.dart';
import 'P_ProfilePage.dart';

class PHomePage extends StatefulWidget {
  final String preacherId;

  const PHomePage({super.key, required this.preacherId});

  @override
  State<PHomePage> createState() => _PHomePageState();
}

class _PHomePageState extends State<PHomePage> {
  int _index = 1;
  int _imgIndex = 0;

  final images = ['assets/images/preacher1.jpg', 'assets/images/preacher2.jpg'];

  void _onNavTap(int i) {
    if (i == 2) {
      // 👉 Profile
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => PProfilePage(userId: widget.preacherId),
        ),
      );
    } else {
      // index 0 = do nothing, index 1 = home
      setState(() => _index = 1);
    }
  }

  @override
  Widget build(BuildContext context) {
    final preacherName =
        AuthService.currentUser?['fullName']?.toString() ?? 'Preacher';

    return Scaffold(
      appBar: const DaieHeader(),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "Welcome to $preacherName!",
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
      bottomNavigationBar: PreacherNav(currentIndex: _index, onTap: _onNavTap),
    );
  }
}
