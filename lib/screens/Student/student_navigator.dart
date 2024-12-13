import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hackon/screens/Student/student_home_screen.dart';
import 'package:hackon/screens/Student/update_student_details.dart';

class StudentNavigator extends StatefulWidget {
  const StudentNavigator({super.key});

  @override
  State<StudentNavigator> createState() => _StudentNavigatorState();
}

class _StudentNavigatorState extends State<StudentNavigator> {
  bool inewuser = false;
  // bool isLoading = true;
  final user = FirebaseAuth.instance.currentUser;

  Future<void> getDetails() async {
    if (user != null) {
      try {
        final snapshot = await FirebaseFirestore.instance
            .collection('Students')
            .doc(user!.uid)
            .get();
        setState(() {
          final inewuser = !snapshot.exists;
        });
      } catch (error) {
        // Handle error if needed
      }
    } else {}
  }

  @override
  void initState() {
    getDetails();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (user == null) {
      return const Center(
        child: Text('No user is logged in.'),
      );
    }
    print(inewuser);
    print("..................................................................");
    if (inewuser == true) {
      return const UpdateStudentDetails();
    } else {
      return const Student_home_screen();
    }
  }
}
