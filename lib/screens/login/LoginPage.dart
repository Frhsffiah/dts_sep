import 'package:flutter/material.dart';

import '../../services/auth_service.dart';
import '../admin/A_HomePage.dart';
import '../officer/O_HomePage.dart';
import '../preacher/P_HomePage.dart';
import 'RegisterPage.dart';
import '../../ui/common/dt_theme.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final email = TextEditingController();
  final password = TextEditingController();
  final auth = AuthService();

  String selectedRole = 'admin';

  Future<void> _login() async {
    final user = await auth.login(
      email.text.trim().toLowerCase(),
      password.text.trim(),
    );

    if (!mounted) return;

    if (user == null) {
      DtTheme.errorSnack(context, "Invalid email or password");
      return;
    }

    final roleFromDb = user['role'].toString().toLowerCase();
    final id = user['id'];

    if (roleFromDb != selectedRole) {
      DtTheme.errorSnack(
        context,
        "You selected the wrong role for this account",
      );
      return;
    }

    if (roleFromDb == 'admin') {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => AHomePage(adminId: id)),
      );
    } else if (roleFromDb == 'officer') {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => OHomePage(officerId: id)),
      );
    } else if (roleFromDb == 'preacher') {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => PHomePage(preacherId: id)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6EFF8),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: DtTheme.screenCard(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    "LOGIN",
                    style: TextStyle(fontWeight: FontWeight.w900),
                  ),
                  const SizedBox(height: 16),

                  TextField(
                    controller: email,
                    decoration: DtTheme.input("Email"),
                  ),
                  const SizedBox(height: 10),

                  TextField(
                    controller: password,
                    obscureText: true,
                    decoration: DtTheme.input("Password"),
                  ),
                  const SizedBox(height: 16),

                  DropdownButtonFormField<String>(
                    value: selectedRole,
                    decoration: DtTheme.input("Role"),
                    items: const [
                      DropdownMenuItem(value: 'admin', child: Text("Admin")),
                      DropdownMenuItem(
                        value: 'officer',
                        child: Text("Officer"),
                      ),
                      DropdownMenuItem(
                        value: 'preacher',
                        child: Text("Preacher"),
                      ),
                    ],
                    onChanged: (v) => setState(() => selectedRole = v!),
                  ),

                  const SizedBox(height: 18),

                  DtTheme.primaryButton("LOGIN", _login),

                  const SizedBox(height: 12),

                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const RegisterPage()),
                      );
                    },
                    child: const Text("Register account"),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
