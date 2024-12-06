import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hackon/screens/Student/student_home_screen.dart';
import 'package:hackon/screens/Student/update_student_details.dart';

class StudentNavigator extends StatelessWidget {
  const StudentNavigator({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasData) {
          final user = FirebaseAuth.instance.currentUser!;
          final photoURL = user.photoURL;

          if (photoURL == null) {
            return const UpdateStudentDetails();
          } else {
            return const Student_home_screen();
          }
        }
        return const Center(
          child: Text('No user is logged in.'),
        );
      },
    );
  }
}
