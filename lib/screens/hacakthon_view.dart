import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hackon/classes/hackathon.dart';
import 'package:hackon/widgets/placeholder_trait.dart';
import 'package:transparent_image/transparent_image.dart';

class hacakthonview extends StatefulWidget {
  hacakthonview({
    super.key,
    required this.hackathon,
    required this.iswishlist,
  });
  final Hackathon hackathon;
  bool iswishlist;
  @override
  State<hacakthonview> createState() => _hacakthonviewState();
}

class _hacakthonviewState extends State<hacakthonview> {
  var faculty_name = "";
  var faculty_image = "";
  var student_name = "";
  var imageurl = "";
  var department = "";
  var student_college = "";
  var phonenumber = "";
  List<String> wishlist_id = [];
  List<String> registred = [];
  var ispresent = false;
  var registred_to_hackathon = false;
  var user = FirebaseAuth.instance.currentUser;
  DateTime combineDateAndTime(DateTime date, TimeOfDay time) {
    return DateTime(date.year, date.month, date.day, time.hour, time.minute);
  }

  Future<void> wishlist(String createdBy, List<String> wishlist_id) async {
    try {
      // Access the collection or sub-collection
      final snapshot = await FirebaseFirestore.instance
          .collection("Students")
          .doc(user!.uid)
          .collection("wishlist") // Replace with your sub-collection name
          .get();
      if (snapshot.docs.isNotEmpty) {
        wishlist_id.addAll(snapshot.docs.map((doc) => doc.id));
        if (wishlist_id.contains(widget.hackathon.id)) {
          setState(() {
            ispresent = true;
          });
        } else {
          setState(() {
            ispresent = false;
          });
        }
      } else {
        print("No documents found in the wishlist collection.");
      }
    } catch (e) {
      print("Error fetching wishlist IDs: $e");
    }
  }

  Future<void> isregistred(List<String> registred) async {
    try {
      // Access the collection or sub-collection
      final snapshot = await FirebaseFirestore.instance
          .collection("Students")
          .doc(user!.uid)
          .collection("Registred") // Replace with your sub-collection name
          .get();
      if (snapshot.docs.isNotEmpty) {
        registred.addAll(snapshot.docs.map((doc) => doc.id));
        if (registred.contains(widget.hackathon.id)) {
          setState(() {
            registred_to_hackathon = true;
          });
        }
      } else {
        print("No documents found in the wishlist collection.");
      }
    } catch (e) {
      print("Error fetching wishlist IDs: $e");
    }
  }

  void get_faculty() async {
    final snapshot = await FirebaseFirestore.instance
        .collection("faculty")
        .doc(widget.hackathon.createdBy)
        .get();
    setState(() {
      faculty_name = snapshot['name'];
      faculty_image = snapshot['imageUrl'];
    });
  }

  void get_student_details() async {
    final snapshot = await FirebaseFirestore.instance
        .collection('Students')
        .doc(user!.uid)
        .get();
    setState(() {
      student_name = snapshot['name'];
      department = snapshot['department'];
      imageurl = snapshot['imageUrl'];
      student_college = snapshot['college'];
      phonenumber = snapshot['phonenumber'];
    });
  }

  void removehackathonfromwishlist() async {
    await FirebaseFirestore.instance
        .collection('Students')
        .doc(user!.uid)
        .collection("wishlist")
        .doc(widget.hackathon.id)
        .delete();
    setState(() {
      wishlist(widget.hackathon.createdBy, wishlist_id);
    });
  }

  void add_hackathonto_wishlist() async {
    DateTime startDateTime = combineDateAndTime(
        widget.hackathon.startDate, widget.hackathon.starttime);
    DateTime endDateTime =
        combineDateAndTime(widget.hackathon.endDate, widget.hackathon.endtime);
    try {
      await FirebaseFirestore.instance
          .collection('Students')
          .doc(user!.uid)
          .collection("wishlist")
          .doc(widget.hackathon.id)
          .set({
        'name': widget.hackathon.name,
        'description': widget.hackathon.description,
        'location': widget.hackathon.location,
        'startDate': startDateTime,
        'endDate': endDateTime,
        "imageUrl": widget.hackathon.imageUrl,
        'createdBy': widget.hackathon.createdBy,
        'id': widget.hackathon.id,
      });
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Error")));
    }
    setState(() {
      wishlist(widget.hackathon.createdBy, wishlist_id);
    });
  }

  void register_to_hackathon() async {
    DateTime startDateTime = combineDateAndTime(
        widget.hackathon.startDate, widget.hackathon.starttime);
    DateTime endDateTime =
        combineDateAndTime(widget.hackathon.endDate, widget.hackathon.endtime);
    try {
      await FirebaseFirestore.instance
          .collection('Students')
          .doc(user!.uid)
          .collection("Registred")
          .doc(widget.hackathon.id)
          .set({
        'name': widget.hackathon.name,
        'description': widget.hackathon.description,
        'location': widget.hackathon.location,
        'startDate': startDateTime,
        'endDate': endDateTime,
        "imageUrl": widget.hackathon.imageUrl,
        'createdBy': widget.hackathon.createdBy,
        'id': widget.hackathon.id,
        'isaccepted': false,
        'iscompleted': false,
      });
      await FirebaseFirestore.instance
          .collection('faculty')
          .doc(widget.hackathon.createdBy)
          .collection('hackathons')
          .doc(widget.hackathon.id)
          .collection('registered_students')
          .doc(user!.uid)
          .set({
        "student_name": student_name,
        "department": department,
        "imageurl": imageurl,
        "student_college": student_college,
        "phonenumber": phonenumber,
      });
      setState(() {
        wishlist(widget.hackathon.createdBy, wishlist_id);
      });
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Error")));
    }
  }

  @override
  void initState() {
    get_faculty();
    get_student_details();
    isregistred(registred);
    wishlist(widget.hackathon.createdBy, wishlist_id);

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
          widget.iswishlist
              ? const SizedBox()
              : IconButton(
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
              const Text(
                "Faculty Details",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 30,
                ),
                textAlign: TextAlign.left,
              ),
              Row(
                children: [
                  CircleAvatar(
                    backgroundImage: NetworkImage(faculty_image),
                    radius: 30,
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  Text(
                    faculty_name,
                    style: TextStyle(fontSize: 15),
                  )
                ],
              ),
              const SizedBox(
                height: 40,
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: registred_to_hackathon
                    ? Row(
                        children: [
                          Expanded(
                              child: ElevatedButton.icon(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.green,
                                  ),
                                  onPressed: () {},
                                  label: Text("Registred"))),
                        ],
                      )
                    : Row(
                        children: [
                          widget.iswishlist
                              ? const SizedBox(
                                  width: 0,
                                )
                              : Expanded(
                                  child: ElevatedButton.icon(
                                    icon: ispresent
                                        ? Icon(Icons.highlight_remove)
                                        : Icon(Icons.add),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color.fromARGB(
                                          255, 54, 235, 244),
                                    ),
                                    onPressed: () {
                                      ispresent
                                          ? removehackathonfromwishlist()
                                          : add_hackathonto_wishlist();
                                      setState(() {
                                        wishlist(widget.hackathon.createdBy,
                                            wishlist_id);
                                      });
                                    },
                                    label: ispresent
                                        ? Text("Wishlist")
                                        : Text("Add to Wishlist"),
                                  ),
                                ),
                          const SizedBox(
                              width: 10), // Add spacing between the buttons
                          Expanded(
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green,
                              ),
                              onPressed: () {
                                register_to_hackathon();
                                setState(() {
                                  isregistred(registred);
                                });
                              },
                              child: Text("Register"),
                            ),
                          ),
                        ],
                      ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
