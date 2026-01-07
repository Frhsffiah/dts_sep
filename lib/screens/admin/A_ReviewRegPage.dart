import 'package:flutter/material.dart';
import '../../services/registration_service.dart';
import '../../ui/common/daie_header.dart';
import '../../ui/common/dt_theme.dart';
import '../../ui/common/admin_nav.dart';
import 'A_HomePage.dart';

class AReviewRegPage extends StatefulWidget {
  final String requestId;
  const AReviewRegPage({super.key, required this.requestId});

  @override
  State<AReviewRegPage> createState() => _AReviewRegPageState();
}

class _AReviewRegPageState extends State<AReviewRegPage> {
  Map<String, dynamic>? data;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    data = await RegistrationService().get(widget.requestId);
    setState(() {});
  }

  void _onNavTap(BuildContext context, int index) {
    if (index == 1) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => const AHomePage(adminId: "admin_001"),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (data == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: const DaieHeader(),
      body: DtTheme.screenCard(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              "Registration Detail",
              style: TextStyle(fontWeight: FontWeight.w900),
            ),
            const SizedBox(height: 14),

            _field("Full Name", data!['fullName']),
            _field("Phone Number", data!['phoneNumber']),
            _field("Email", data!['email']),
            _field("Role", data!['roleRequested']),

            const SizedBox(height: 16),

            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                    ),
                    onPressed: _approve,
                    child: const Text("Approve"),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                    ),
                    onPressed: _reject,
                    child: const Text("Reject"),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 10),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Back"),
            ),
          ],
        ),
      ),
      bottomNavigationBar: AdminNav(
        currentIndex: 0,
        onTap: (i) => _onNavTap(context, i),
      ),
    );
  }

  Widget _field(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.w700)),
          const SizedBox(height: 4),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black12),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(value),
          ),
        ],
      ),
    );
  }

  Future<void> _approve() async {
    await RegistrationService().approve(widget.requestId);
    if (!mounted) return;

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const AHomePage(adminId: "admin_001")),
      (_) => false,
    );
  }

  Future<void> _reject() async {
    await RegistrationService().reject(widget.requestId);
    if (!mounted) return;
    Navigator.pop(context);
  }
}
