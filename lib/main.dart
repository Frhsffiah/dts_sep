import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';

import 'firebase_options.dart';

// Controllers
import 'provider/LoginController.dart';
import 'provider/RegisterController.dart';
import 'provider/ActivityController.dart';
import 'provider/PaymentController.dart';

// Services
import 'services/user_service.dart';

// Start page
import 'pages/Manage_User_Registration/LoginPage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // Controllers
        ChangeNotifierProvider(create: (_) => LoginController()),
        ChangeNotifierProvider(create: (_) => RegisterController()),
        ChangeNotifierProvider(create: (_) => ActivityController()),
        ChangeNotifierProvider(create: (_) => PaymentController()),

        // Services
        Provider<UserService>(create: (_) => UserService()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'DaieTrack',
        theme: ThemeData(
          useMaterial3: true,
        ),
        home: const LoginPage(),
      ),
    );
  }
}
