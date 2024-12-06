import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hackon/screens/AuthScreen.dart';
import 'package:hackon/screens/faculty/Faculty_screen.dart';
import 'package:hackon/screens/faculty/Update_faculty_details.dart';
import 'package:hackon/screens/Student/student_screen.dart';
import 'package:hackon/screens/Student/update_student_details.dart';
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
                // if (url == null) {
                // return const UpdateFacultyDetails();
                return const facultystatehandler();
                // } else {
                // return FacultyHomeScreen();
                // }
              }
              if (displayName == "Student") {
                // if (url == null) {
                return const UpdateStudentDetails();
                // } else {
                // return Student_screen();
                // }
              }
            }
            return const AuthScreen();
          },
        ),
      ),
    );
  }
}
