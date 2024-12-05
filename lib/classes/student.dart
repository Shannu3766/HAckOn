import 'package:flutter/foundation.dart';

class Student {
  Student({
    required this.student_college,
    required this.student_name,
    required this.department,
    required this.imageurl,
    required this.phonenumber,
    required this.studentid,
  });

  final String student_name;
  final String department;
  final String imageurl;
  final String student_college;
  final String phonenumber;
  final String studentid;

  // Factory constructor to create a Student object from a map
  factory Student.fromMap(Map<String, dynamic> map) {
    return Student(
      student_name: map['student_name'] ?? '',
      department: map['department'] ?? '',
      imageurl: map['imageurl'] ?? '',
      student_college: map['student_college'] ?? '',
      phonenumber: map['phonenumber'] ?? '',
      studentid: map['studentid'],
    );
  }
  Map<String, dynamic> toMap() {
    return {
      'student_name': student_name,
      'department': department,
      'imageurl': imageurl,
      'student_college': student_college,
      'phonenumber': phonenumber,
      "studentid": studentid,
    };
  }
}
