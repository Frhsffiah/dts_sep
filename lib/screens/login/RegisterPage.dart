import 'package:flutter/material.dart';
import '../../services/registration_service.dart';
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

  final reg = RegistrationService();

  Future<void> _register() async {
    if (!agree) {
      DtTheme.errorSnack(context, "Please agree with terms & conditions");
      return;
    }

    if (fullName.text.trim().isEmpty ||
        phone.text.trim().isEmpty ||
        address.text.trim().isEmpty ||
        email.text.trim().isEmpty ||
        password.text.isEmpty) {
      DtTheme.errorSnack(context, "Please fill in all fields");
      return;
    }

    try {
      await reg.register(
        fullName: fullName.text.trim(),
        phone: phone.text.trim(),
        address: address.text.trim(),
        email: email.text.trim(),
        password: password.text,
        role: role,
      );

      if (!mounted) return;
      _showSuccessDialog();
    } catch (e) {
      // If email exists or any other error
      if (!mounted) return;
      DtTheme.errorSnack(context, e.toString().replaceAll('Exception: ', ''));
    }
  }

  void _showSuccessDialog() {
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
                const Icon(Icons.check_circle, size: 70, color: Colors.green),
                const SizedBox(height: 16),
                const Text(
                  "Sign Up\nSuccessful",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _register,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(
                      0xFF5E60CE,
                    ), // 🔵 SRS-style blue
                    foregroundColor: Colors.white, // white text
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 60,
                      vertical: 14,
                    ),
                    elevation: 4,
                  ),
                  child: const Text(
                    "SIGN UP",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _label(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Text(text, style: const TextStyle(fontWeight: FontWeight.w700)),
    );
  }

  Widget _input(TextEditingController c, {bool obscure = false}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      child: TextField(
        controller: c,
        obscureText: obscure,
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFDDF1FB),
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            width: 320,
            padding: const EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Center(
                  child: Text(
                    "CREATE YOUR ACCOUNT",
                    style: TextStyle(fontWeight: FontWeight.w900, fontSize: 16),
                  ),
                ),
                const SizedBox(height: 20),

                _label("Full Name:"),
                _input(fullName),

                _label("Phone Number:"),
                _input(phone),

                _label("Address:"),
                _input(address),

                _label("Email:"),
                _input(email),

                _label("Password:"),
                _input(password, obscure: true),

                _label("Role:"),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.grey),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: role,
                      isExpanded: true,
                      items: const [
                        DropdownMenuItem(
                          value: 'preacher',
                          child: Text("Preacher"),
                        ),
                        DropdownMenuItem(
                          value: 'officer',
                          child: Text("Officer"),
                        ),
                      ],
                      onChanged: (v) => setState(() => role = v!),
                    ),
                  ),
                ),

                const SizedBox(height: 12),

                Row(
                  children: [
                    Checkbox(
                      value: agree,
                      onChanged: (v) => setState(() => agree = v ?? false),
                    ),
                    const Expanded(
                      child: Text("Agree with terms and conditions"),
                    ),
                  ],
                ),

                const SizedBox(height: 10),

                Center(
                  child: ElevatedButton(
                    onPressed: _register,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.indigo,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 60,
                        vertical: 14,
                      ),
                    ),
                    child: const Text(
                      "SIGN UP",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
