import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../ui/common/daie_header.dart';
import '../../ui/common/preacher_nav.dart';
import 'P_ProfilePage.dart';
import 'P_HomePage.dart';

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
  late final TextEditingController fullName;
  late final TextEditingController phone;
  late final TextEditingController address;

  @override
  void initState() {
    super.initState();
    fullName = TextEditingController(text: widget.existing['fullName']);
    phone = TextEditingController(text: widget.existing['phoneNumber']);
    address = TextEditingController(text: widget.existing['address']);
  }

  Future<void> _save() async {
    await FirebaseFirestore.instance
        .collection('preachers')
        .doc(widget.userId)
        .update({
          'fullName': fullName.text.trim(),
          'phoneNumber': phone.text.trim(),
          'address': address.text.trim(),
        });

    _successDialog();
  }

  void _successDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => Center(
        child: Material(
          color: Colors.transparent,
          child: Container(
            width: 260,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Align(
                  alignment: Alignment.topRight,
                  child: IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () {
                      Navigator.pop(context); // close dialog
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (_) => PProfilePage(userId: widget.userId),
                        ),
                      );
                    },
                  ),
                ),
                const Icon(Icons.check_circle, size: 60, color: Colors.green),
                const SizedBox(height: 10),
                const Text(
                  "Edit successful!",
                  style: TextStyle(fontWeight: FontWeight.w800),
                ),
              ],
            ),
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
            borderRadius: BorderRadius.circular(14),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "Edit Profile",
                style: TextStyle(fontWeight: FontWeight.w900),
              ),
              const SizedBox(height: 18),

              _input("Full Name", fullName),
              _input("Phone Number", phone),
              _input("Address", address),

              const SizedBox(height: 14),

              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.lightBlue.shade200,
                  foregroundColor: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                onPressed: _save,
                child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                  child: Text("Save"),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: PreacherNav(
        currentIndex: 2,
        onTap: (i) {
          if (i == 1) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (_) => PHomePage(preacherId: widget.userId),
              ),
            );
          }
        },
      ),
    );
  }

  Widget _input(String label, TextEditingController c) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 4),
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
}
