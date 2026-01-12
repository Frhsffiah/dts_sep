import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../provider/RegisterController.dart';
import '../../ui/common/dt_theme.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final fullName = TextEditingController();
  final phone = TextEditingController();
  final address = TextEditingController();
  final email = TextEditingController();
  final password = TextEditingController();

  bool agree = false;
  String role = 'preacher';

  Future<void> _register() async {
    if (!agree) {
      DtTheme.errorSnack(context, "Please agree with terms & conditions");
      return;
    }

    try {
      await context.read<RegisterController>().createRequest(
        fullName: fullName.text,
        phoneNumber: phone.text,
        address: address.text,
        email: email.text,
        password: password.text,
        roleRequested: role,
      );

      if (!mounted) return;
      Navigator.pop(context);
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFDDF1FB),
      body: Center(
        child: DtTheme.screenCard(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "CREATE YOUR ACCOUNT",
                style: TextStyle(fontWeight: FontWeight.w900, fontSize: 16),
              ),
              const SizedBox(height: 20),

              _input("Full Name", fullName),
              _input("Phone Number", phone),
              _input("Address", address),
              _input("Email", email),
              _input("Password", password, obscure: true),

              const SizedBox(height: 12),

              _dropdown(),

              const SizedBox(height: 12),

              Row(
                children: [
                  Checkbox(
                    value: agree,
                    onChanged: (v) => setState(() => agree = v!),
                  ),
                  const Text("Agree with terms and conditions"),
                ],
              ),

              const SizedBox(height: 14),

              // 🔵 KEEP BUTTON COLOR AS IS
              DtTheme.primaryButton("SIGN UP", _register),
            ],
          ),
        ),
      ),
    );
  }

  // 🔹 INPUT FIELD WITH LABEL (LIKE PICTURE 2)
  Widget _input(
    String label,
    TextEditingController controller, {
    bool obscure = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("$label:", style: const TextStyle(fontWeight: FontWeight.w700)),
          const SizedBox(height: 6),
          TextField(
            controller: controller,
            obscureText: obscure,
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.white,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 12,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: Colors.black26),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: Colors.black26),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // 🔹 ROLE DROPDOWN MATCHING STYLE
  Widget _dropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Role:", style: TextStyle(fontWeight: FontWeight.w700)),
        const SizedBox(height: 6),
        DropdownButtonFormField<String>(
          value: role,
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 12,
            ),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          ),
          items: const [
            DropdownMenuItem(value: 'preacher', child: Text("Preacher")),
            DropdownMenuItem(value: 'officer', child: Text("Officer")),
          ],
          onChanged: (v) => setState(() => role = v!),
        ),
      ],
    );
  }
}
