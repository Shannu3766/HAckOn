// import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hackon/classes/hackathon.dart';
import 'package:hackon/screens/faculty/registres_students.dart';
import 'package:hackon/widgets/placeholder_trait.dart';
import 'package:transparent_image/transparent_image.dart';

class hacakthonviewFaculty extends StatefulWidget {
  hacakthonviewFaculty({
    super.key,
    required this.hackathon,
  });
  final Hackathon hackathon;
  @override
  State<hacakthonviewFaculty> createState() => _hacakthonviewFacultyState();
}

class _hacakthonviewFacultyState extends State<hacakthonviewFaculty> {
  List<String> wishlist_id = [];
  List<String> registred = [];
  var ispresent = false;
  var registred_to_hackathon = false;
  var user = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var date =
        '${widget.hackathon.startDate.day}/${widget.hackathon.startDate.month}';
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.hackathon.name),
        actions: [
          IconButton(
              onPressed: () {
                FirebaseAuth.instance.signOut();
              },
              icon: Icon(Icons.exit_to_app))
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(
            left: MediaQuery.of(context).size.width * 0.05,
            right: MediaQuery.of(context).size.width * 0.05,
          ),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 10, bottom: 10),
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.9,
                  height: MediaQuery.of(context).size.height * 0.2,
                  child: FadeInImage(
                    placeholder: MemoryImage(kTransparentImage),
                    image: NetworkImage(widget.hackathon.imageUrl),
                  ),
                ),
              ),
              const Text(
                "Workshop Details",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 30,
                ),
                textAlign: TextAlign.left,
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                children: [
                  Traititem_view(
                      icon: Icons.location_on,
                      label: widget.hackathon.location),
                  Spacer(),
                  Traititem_view(icon: Icons.calendar_month, label: date),
                  SizedBox(width: MediaQuery.of(context).size.width * 0.1)
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "About",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 25,
                  ),
                ),
              ),
              Text(widget.hackathon.description),
              const SizedBox(
                height: 30,
              ),
              const SizedBox(
                height: 40,
              ),
              widget.hackathon.createdBy != user!.uid
                  ? const SizedBox(
                      height: 10,
                    )
                  : Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => RegistredStudents(
                                    hackathon_id: widget.hackathon.id,
                                  ),
                                ),
                              );
                            },
                            child: Text("View Registred Students"),
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.greenAccent),
                          ),
                        ),
                      ],
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
