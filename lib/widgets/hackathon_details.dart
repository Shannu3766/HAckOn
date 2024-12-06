import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hackon/classes/hackathon.dart';
import 'package:hackon/widgets/placeholder_trait.dart';
import 'package:transparent_image/transparent_image.dart';

class hackathon_details extends StatefulWidget {
  hackathon_details({
    super.key,
    required this.hackathon,
    required this.iswishlist,
  });
  final Hackathon hackathon;
  bool iswishlist;
  @override
  State<hackathon_details> createState() => _hackathon_detailsState();
}

class _hackathon_detailsState extends State<hackathon_details> {
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
        "studentid": user!.uid,
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
        title: Text(
          widget.hackathon.name,
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          widget.iswishlist
              ? const SizedBox()
              : IconButton(
                  onPressed: () {
                    FirebaseAuth.instance.signOut();
                  },
                  icon: Icon(Icons.exit_to_app, color: Colors.redAccent),
                ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: MediaQuery.of(context).size.width * 0.05,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Hackathon Image
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Container(
                  width: double.infinity,
                  height: MediaQuery.of(context).size.height * 0.2,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 10,
                        offset: Offset(0, 5),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: FadeInImage(
                      placeholder: MemoryImage(kTransparentImage),
                      image: NetworkImage(widget.hackathon.imageUrl),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),

              // Workshop Details
              const Text(
                "Workshop Details",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 15),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Abouthacko(
                    icon: Icons.location_on_outlined,
                    label: widget.hackathon.location,
                  ),
                  Abouthacko(
                    icon: Icons.calendar_today_outlined,
                    label: date,
                  ),
                ],
              ),
              const SizedBox(height: 25),

              // About Section
              const Text(
                "About",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                widget.hackathon.description,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[700],
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 30),

              // Faculty Details
              const Text(
                "Faculty Details",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 15),
              Row(
                children: [
                  CircleAvatar(
                    backgroundImage: NetworkImage(faculty_image),
                    radius: 30,
                  ),
                  const SizedBox(width: 15),
                  Text(
                    faculty_name,
                    style: const TextStyle(fontSize: 18),
                  ),
                ],
              ),
              const SizedBox(height: 40),

              // Action Buttons
              Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: registred_to_hackathon
                    ? Center(
                        child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            padding: const EdgeInsets.symmetric(
                                vertical: 12, horizontal: 20),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          onPressed: () {},
                          icon: const Icon(Icons.check_circle_outline),
                          label: const Text("Registered"),
                        ),
                      )
                    : Row(
                        children: [
                          widget.iswishlist
                              ? const SizedBox()
                              : Expanded(
                                  child: ElevatedButton.icon(
                                    icon: ispresent
                                        ? const Icon(Icons.highlight_remove)
                                        : const Icon(Icons.add),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color.fromARGB(
                                          255, 54, 235, 244),
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 12),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
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
                                        ? const Text("Remove Wishlist")
                                        : const Text("Add to Wishlist"),
                                  ),
                                ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green,
                                padding:
                                    const EdgeInsets.symmetric(vertical: 12),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              onPressed: () {
                                register_to_hackathon();
                                setState(() {
                                  isregistred(registred);
                                });
                              },
                              child: const Text("Register"),
                            ),
                          ),
                        ],
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
