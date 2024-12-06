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
            // Navigate to page for users without a photo
            return const UpdateFacultyDetails();
          } else {
            // Navigate to page for users with a photo
            return const FacultyHomeScreen();
          }
        }

        // Handle case where user is not logged in
        return const Center(
          child: Text('No user is logged in.'),
        );
      },
    );
  }
}
