import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../provider/LoginController.dart';
import 'A_HomePage.dart';
import 'O_HomePage.dart';
import 'P_HomePage.dart';
import 'RegisterPage.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final email = TextEditingController();
  final password = TextEditingController();

  // ✅ DEFAULT ROLE = OFFICER (like first picture)
  String role = 'officer';

  Future<void> _login() async {
    final ctrl = context.read<LoginController>();

    final user = await ctrl.login(
      email: email.text.trim(),
      password: password.text.trim(),
      selectedRole: role,
    );

    if (!mounted) return;

    // ❌ login failed → show bottom message like picture
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "You are not being registered yet, please register first",
          ),
          backgroundColor: Colors.black87,
        ),
      );
      return;
    }

    // ✅ success → navigate
    if (role == 'admin') {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => AHomePage(adminId: user.userId)),
      );
    } else if (role == 'officer') {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => OHomePage(officerId: user.userId)),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => PHomePage(preacherId: user.userId)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6EFF8), // light purple
      body: Center(
        child: Container(
          width: 320,
          padding: const EdgeInsets.all(20),
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
                "LOGIN",
                style: TextStyle(fontWeight: FontWeight.w900, fontSize: 16),
              ),
              const SizedBox(height: 16),

              // Email
              TextField(controller: email, decoration: _input("Email")),
              const SizedBox(height: 12),

              // Password
              TextField(
                controller: password,
                obscureText: true,
                decoration: _input("Password"),
              ),
              const SizedBox(height: 12),

              // Role
              DropdownButtonFormField<String>(
                value: role,
                decoration: _input("Role"),
                items: const [
                  DropdownMenuItem(value: 'admin', child: Text("Admin")),
                  DropdownMenuItem(value: 'officer', child: Text("Officer")),
                  DropdownMenuItem(value: 'preacher', child: Text("Preacher")),
                ],
                onChanged: (v) => setState(() => role = v!),
              ),

              const SizedBox(height: 18),

              // LOGIN BUTTON
              SizedBox(
                width: 160,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.lightBlue.shade200,
                    foregroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  onPressed: _login,
                  child: const Text(
                    "LOGIN",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),

              const SizedBox(height: 10),

              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const RegisterPage()),
                  );
                },
                child: const Text(
                  "Register account",
                  style: TextStyle(color: Colors.purple),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // 🔹 Shared input style
  InputDecoration _input(String hint) {
    return InputDecoration(
      hintText: hint,
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
    );
  }
}
