import 'package:flutter/material.dart';

class Hackathon {
  final String name;
  final String description;
  final String location;
  final DateTime startDate;
  final DateTime endDate;
  final TimeOfDay starttime;
  final TimeOfDay endtime;
  final String imageUrl;
  final String createdBy;
  final String id;
  bool? iscompleted;
  bool? isaccepted;
  Hackathon({
    required this.name,
    required this.description,
    required this.location,
    required this.startDate,
    required this.endDate,
    required this.imageUrl,
    required this.createdBy,
    required this.id,
    required this.starttime,
    required this.endtime,
  });
}
