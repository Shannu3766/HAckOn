import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hackon/screens/Authentication.dart';
import 'package:hackon/screens/Student/student_navigator.dart';
import 'package:hackon/screens/faculty/faculty_navigator.dart';

import 'firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';

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
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'FlutterChat',
      home: Scaffold(
        body: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final user = FirebaseAuth.instance.currentUser!;
              final displayName = user.displayName;
              final url = user.photoURL;
              if (displayName == "Faculty") {
                return const facultystatehandler();
              }
              if (displayName == "Student") {
                return const StudentNavigator();
              }
            }
            return const AuthScreen();
          },
        ),
      ),
    );
  }
}
