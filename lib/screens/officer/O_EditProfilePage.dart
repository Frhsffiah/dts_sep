import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../ui/common/daie_header.dart';
import '../../ui/common/officer_nav.dart';
import 'O_ProfilePage.dart';
import 'O_HomePage.dart';

class OEditProfilePage extends StatefulWidget {
  final String officerId;
  final Map<String, dynamic> data;

  const OEditProfilePage({
    super.key,
    required this.officerId,
    required this.data,
  });

  @override
  State<OEditProfilePage> createState() => _OEditProfilePageState();
}

class _OEditProfilePageState extends State<OEditProfilePage> {
  late final TextEditingController fullName;
  late final TextEditingController phone;
  late final TextEditingController address;

  @override
  void initState() {
    super.initState();
    fullName = TextEditingController(text: widget.data['fullName']);
    phone = TextEditingController(text: widget.data['phoneNumber']);
    address = TextEditingController(text: widget.data['address']);
  }

  Future<void> _save() async {
    await FirebaseFirestore.instance
        .collection('officers')
        .doc(widget.officerId)
        .update({
          'fullName': fullName.text.trim(),
          'phoneNumber': phone.text.trim(),
          'address': address.text.trim(),
        });

    _successDialog();
  }

  // ✅ SAME POPUP STYLE AS PREACHER
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
                          builder: (_) =>
                              OProfilePage(userId: widget.officerId),
                        ),
                      );
                    },
                  ),
                ),
                const Icon(Icons.check_circle, size: 60, color: Colors.green),
                const SizedBox(height: 10),
                const Text(
                  "Edit successful!",
                  style: TextStyle(fontWeight: FontWeight.w800, fontSize: 16),
                ),
              ],
            ),
          ),
        ),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const DaieHeader(),
      body: Center(
        child: Container(
          width: 320, // ✅ SAME AS PREACHER
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

              // ✅ BLUE SAVE BUTTON (SAME AS PREACHER)
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
                  child: Text(
                    "Save",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: OfficerNav(
        currentIndex: 2,
        onTap: (i) {
          if (i == 1) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (_) => OHomePage(officerId: widget.officerId),
              ),
            );
          }
        },
      ),
    );
  }
}
