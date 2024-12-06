import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hackon/screens/faculty/Faculty_screen.dart';
import 'package:hackon/screens/faculty/Update_faculty_details.dart';

class facultystatehandler extends StatelessWidget {
  const facultystatehandler({super.key});

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
            return const UpdateFacultyDetails();
          } else {
            return const FacultyHomeScreen();
          }
        }
        return const Center(
          child: Text('No user is logged in.'),
        );
      },
    );
  }
}
