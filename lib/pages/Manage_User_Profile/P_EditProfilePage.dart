import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


import '../../ui/common/daie_header.dart';
import '../../ui/common/preacher_nav.dart';

class PEditProfilePage extends StatefulWidget {
  final String userId;
  final Map<String, dynamic> existing;

  const PEditProfilePage({
    super.key,
    required this.userId,
    required this.existing,
  });

  @override
  State<PEditProfilePage> createState() => _PEditProfilePageState();
}

class _PEditProfilePageState extends State<PEditProfilePage> {
  static const Color mainBlue = Color(0xFF7DD3FC);

  late TextEditingController name;
  late TextEditingController phone;
  late TextEditingController address;

  @override
  void initState() {
    super.initState();
    name = TextEditingController(text: widget.existing['fullName']);
    phone = TextEditingController(text: widget.existing['phoneNumber']);
    address = TextEditingController(text: widget.existing['address']);
  }

  Future<void> _save() async {
    await FirebaseFirestore.instance
        .collection('preachers')
        .doc(widget.userId)
        .update({
          'fullName': name.text,
          'phoneNumber': phone.text,
          'address': address.text,
        });

    if (!mounted) return;

    _successDialog();
  }

  void _successDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.check_circle, color: Colors.green, size: 60),
              const SizedBox(height: 16),
              const Text(
                "Edit successful!",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(height: 20),
              _mainButton("OK", () {
                Navigator.pop(context);
                Navigator.pop(context);
              }),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const DaieHeader(),
      body: Center(
        child: Container(
          width: 320,
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(color: Colors.black.withOpacity(.12), blurRadius: 8),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "Edit Profile",
                style: TextStyle(fontWeight: FontWeight.w900),
              ),
              const SizedBox(height: 20),

              _input("Full Name", name),
              _input("Phone Number", phone),
              _input("Address", address),

              const SizedBox(height: 20),
              _mainButton("Save", _save),
            ],
          ),
        ),
      ),
      bottomNavigationBar: PreacherNav(
        currentIndex: 2,
        onTap: (i) {
          if (i == 1) Navigator.pop(context);
        },
      ),
    );
  }

  Widget _input(String label, TextEditingController c) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 6),
          TextField(
            controller: c,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _mainButton(String text, VoidCallback onTap) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: mainBlue,
        foregroundColor: Colors.black,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
      ),
      onPressed: onTap,
      child: Text(text, style: const TextStyle(fontWeight: FontWeight.bold)),
    );
  }
}
