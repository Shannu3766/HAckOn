import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hackon/classes/student.dart';

class RegistredStudents extends StatefulWidget {
  const RegistredStudents({super.key, required this.hackathon_id});
  final String hackathon_id;

  @override
  State<RegistredStudents> createState() => _RegistredStudentsState();
}

class _RegistredStudentsState extends State<RegistredStudents> {
  final user = FirebaseAuth.instance.currentUser;

  // State to track selected students using their studentid
  final Map<String, bool> selectedStudents = {};

  Stream<List<Student>> getRegisteredStudentsStream() {
    return FirebaseFirestore.instance
        .collection("faculty")
        .doc(user!.uid)
        .collection("hackathons")
        .doc(widget.hackathon_id)
        .collection("registered_students")
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) {
              final data = doc.data() as Map<String, dynamic>;
              return Student.fromMap(data);
            }).toList());
  }

  // Save selected students
  void saveSelectedStudents() async {
    // Get the list of selected students' IDs
    final selected = selectedStudents.entries
        .where((entry) => entry.value) // Filter only selected students
        .map((entry) => entry.key) // Get the unique student IDs
        .toList();

    if (selected.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No students selected to save.')),
      );
      return;
    }

    try {
      for (String studentId in selected) {
        // print(studentId);
        // print("............................................................");
        await FirebaseFirestore.instance
            .collection("Students")
            .doc(studentId)
            .collection("Registred")
            .doc(widget.hackathon_id)
            .update({'iscompleted': true});
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text('${selected.length} students updated successfully!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error updating students: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Registered Students"),
      ),
      body: StreamBuilder<List<Student>>(
        stream: getRegisteredStudentsStream(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text('No registered students found.'),
            );
          }

          final students = snapshot.data!;
          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: students.length,
                  itemBuilder: (context, index) {
                    final student = students[index];
                    return CheckboxListTile(
                      value: selectedStudents[student.studentid] ?? false,
                      onChanged: (isChecked) {
                        setState(() {
                          selectedStudents[student.studentid] = isChecked!;
                        });
                      },
                      title: Text(student.student_name),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(student.student_college),
                          Text("ID: ${student.studentid}",
                              style: const TextStyle(
                                  fontSize: 12, color: Colors.grey)),
                        ],
                      ),
                      secondary: CircleAvatar(
                        backgroundImage: NetworkImage(student.imageurl),
                      ),
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: ElevatedButton(
                  onPressed: saveSelectedStudents,
                  child: const Text("Save Selected Students"),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
