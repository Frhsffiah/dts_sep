import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

import 'firebase_options.dart';

// 🔐 Login (final flow)
import 'screens/login/LoginPage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'DaieTrack',
      theme: ThemeData(useMaterial3: true),

      // ===============================
      // 🔁 CHANGE ONLY THIS LINE
      // ===============================

      // ✅ UI CHECKING MODE
      //home: const UiPreviewPage(),

      // ✅ FINAL SUBMISSION MODE
      home: const LoginPage(),
    );
  }
}
