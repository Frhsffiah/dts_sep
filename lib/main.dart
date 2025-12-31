import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

// ✅ Import your module screens (adjust paths if different)
import 'screens/officer/officer_activity_list.dart';
import 'screens/preacher/preacher_activity_tabs.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // ✅ IMPORTANT: await Firebase init
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'DaieTrack',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),

      // ==============================
      // ✅ TEMP TEST (NO LOGIN YET)
      // Switch between Officer / Preacher by changing ONLY this line
      // ==============================

      // Officer (CRUD)
       home: const OfficerActivityList(officerId: "officer_001"),

      // Preacher (View Upcoming/Completed)
      // home: const PreacherActivityTabs(preacherId: "preacher_002"),
    );
  }
}
