import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:hackon/classes/hackathon.dart';

import 'package:transparent_image/transparent_image.dart';

class hackathon_itemregister extends StatefulWidget {
  const hackathon_itemregister(
      {super.key,
      required this.name,
      required this.location,
      required this.startdate,
      required this.starttime,
      required this.hackathon,
      required this.iswishlist,
      required this.imageUrl,
      required this.iscompleted});
  final bool iswishlist;
  final String name;
  final String location;
  final DateTime startdate;
  final String imageUrl;
  final TimeOfDay starttime;
  final Hackathon hackathon;
  final bool iscompleted;
  @override
  State<hackathon_itemregister> createState() => _hackathon_itemregisterState();
}

class _hackathon_itemregisterState extends State<hackathon_itemregister> {
  bool isaccepted = false;

  final user = FirebaseAuth.instance.currentUser;
  // void checkcompleted() async {
  //   final snapshot = await FirebaseFirestore.instance
  //       .collection("Students")
  //       .doc(user!.uid)
  //       .collection("Registred")
  //       .doc(widget.hackathon.id)
  //       .get();
  //   isaccepted = snapshot['isaccepted'];
  //   iscompleted = snapshot['iscompleted'];
  //   print(isaccepted);
  //   print("......................");
  // }

  @override
  void initState() {
    // checkcompleted();
    print(widget.iscompleted);
    print("sdafasdf............................");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // var time = widget.starttime.format(context);
    // var date = "${widget.startdate.day}/${widget.startdate.month}";
    return Card(
      child: Column(
        children: [
          GestureDetector(
            onTap: () {},
            child: Stack(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width * 0.9,
                  height: MediaQuery.of(context).size.height * 0.2,
                  child: FadeInImage(
                    placeholder: MemoryImage(kTransparentImage),
                    image: NetworkImage(widget.imageUrl),
                  ),
                ),
                !widget.iscompleted
                    ? Positioned(
                        left: 0,
                        right: 0,
                        bottom: 0,
                        top: 0,
                        child: Container(
                            color: const Color.fromARGB(124, 0, 0, 0),
                            child: Center(
                              child: Icon(
                                Icons.lock_clock,
                                color: const Color.fromARGB(255, 197, 99, 92),
                                size: MediaQuery.of(context).size.width * 0.4,
                              ),
                            )),
                      )
                    : Positioned(
                        left: 0,
                        right: 0,
                        bottom: 0,
                        top: 0,
                        child: Container(
                            color: const Color.fromARGB(124, 0, 0, 0),
                            child: Center(
                              child: Icon(
                                Icons.check,
                                color: Colors.green,
                                size: MediaQuery.of(context).size.width * 0.4,
                              ),
                            )),
                      ),
              ],
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Text(
            "Status  :${widget.iscompleted ? "Completed" : "Not Yet completed"}",
            style: TextStyle(fontSize: 15),
          ),
          const SizedBox(
            height: 10,
          ),
        ],
      ),
    );
  }
}
