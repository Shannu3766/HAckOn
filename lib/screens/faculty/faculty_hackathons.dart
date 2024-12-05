import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hackon/classes/hackathon.dart';
import 'package:hackon/screens/faculty/hackathon_item_for_faculty_total_list.dart';
// import 'package:hackon/widgets/placeholder.dart';

class viewmyhackathons extends StatefulWidget {
  @override
  _viewmyhackathonsState createState() => _viewmyhackathonsState();
}

class _viewmyhackathonsState extends State<viewmyhackathons> {
  late Future<List<Hackathon>> _hackathonsFuture;
  final user = FirebaseAuth.instance.currentUser;

  Future<List<Hackathon>> fetchHackathons() async {
    final snapshot = await FirebaseFirestore.instance
        .collection("faculty")
        .doc(user!.uid)
        .collection("hackathons")
        .get();
    return snapshot.docs.map((doc) {
      final data = doc.data();
      return Hackathon(
          id: doc.id,
          name: data['name'],
          description: data['description'],
          location: data['location'],
          startDate: (data['startDate'] as Timestamp).toDate(),
          endDate: (data['endDate'] as Timestamp).toDate(),
          starttime:
              TimeOfDay.fromDateTime((data['startDate'] as Timestamp).toDate()),
          endtime:
              TimeOfDay.fromDateTime((data['endDate'] as Timestamp).toDate()),
          imageUrl: data['imageUrl'],
          createdBy: data['createdBy'],
          iscompleted: false);
    }).toList();
  }

  @override
  void initState() {
    super.initState();
    _hackathonsFuture = fetchHackathons();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Hackathon>>(
      future: _hackathonsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text('No Hackathons Available'));
        } else {
          final hackathons = snapshot.data!;
          return ListView.builder(
            itemCount: hackathons.length,
            itemBuilder: (context, index) {
              final hackathon = hackathons[index];
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: hackathon_item_for_faculty_total_list(
                  name: hackathon.name,
                  imageUrl: hackathon.imageUrl,
                  location: hackathon.location,
                  startdate: hackathon.startDate,
                  starttime: hackathon.starttime,
                  hackathon: hackathon,
                  iswishlist: false,
                ),
              );
            },
          );
        }
      },
    );
  }
}
