// import 'package:firebase_auth/firebase_auth.dart';

// import 'package:flutter/material.dart';
// import 'package:hackon/classes/hackathon.dart';

// import 'package:transparent_image/transparent_image.dart';

// class hackathon_itemregister extends StatefulWidget {
//   const hackathon_itemregister(
//       {super.key,
//       required this.name,
//       required this.location,
//       required this.startdate,
//       required this.starttime,
//       required this.hackathon,
//       required this.iswishlist,
//       required this.imageUrl,
//       required this.iscompleted});
//   final bool iswishlist;
//   final String name;
//   final String location;
//   final DateTime startdate;
//   final String imageUrl;
//   final TimeOfDay starttime;
//   final Hackathon hackathon;
//   final bool iscompleted;
//   @override
//   State<hackathon_itemregister> createState() => _hackathon_itemregisterState();
// }

// class _hackathon_itemregisterState extends State<hackathon_itemregister> {
//   bool isaccepted = false;

//   final user = FirebaseAuth.instance.currentUser;

//   @override
//   void initState() {
//     // checkcompleted();
//     print(widget.iscompleted);
//     print("sdafasdf............................");
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       child: Column(
//         children: [
//           GestureDetector(
//             onTap: () {},
//             child: Stack(
//               children: [
//                 Container(
//                   width: MediaQuery.of(context).size.width * 0.9,
//                   height: MediaQuery.of(context).size.height * 0.2,
//                   child: FadeInImage(
//                     placeholder: MemoryImage(kTransparentImage),
//                     image: NetworkImage(widget.imageUrl),
//                   ),
//                 ),
//                 !widget.iscompleted
//                     ? Positioned(
//                         left: 0,
//                         right: 0,
//                         bottom: 0,
//                         top: 0,
//                         child: Container(
//                             color: const Color.fromARGB(124, 0, 0, 0),
//                             child: Center(
//                               child: Icon(
//                                 Icons.lock_clock,
//                                 color: const Color.fromARGB(255, 197, 99, 92),
//                                 size: MediaQuery.of(context).size.width * 0.4,
//                               ),
//                             )),
//                       )
//                     : Positioned(
//                         left: 0,
//                         right: 0,
//                         bottom: 0,
//                         top: 0,
//                         child: Container(
//                             color: const Color.fromARGB(124, 0, 0, 0),
//                             child: Center(
//                               child: Icon(
//                                 Icons.check,
//                                 color: Colors.green,
//                                 size: MediaQuery.of(context).size.width * 0.4,
//                               ),
//                             )),
//                       ),
//               ],
//             ),
//           ),
//           const SizedBox(
//             height: 10,
//           ),
//           Text(
//             "Status  :${widget.iscompleted ? "Completed" : "Not Yet completed"}",
//             style: TextStyle(fontSize: 15),
//           ),
//           const SizedBox(
//             height: 10,
//           ),
//         ],
//       ),
//     );
//   }
// }
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hackon/classes/hackathon.dart';
import 'package:transparent_image/transparent_image.dart';
import 'dart:async';

class hackathon_itemregister extends StatefulWidget {
  const hackathon_itemregister({
    super.key,
    required this.name,
    required this.location,
    required this.startdate,
    required this.starttime,
    required this.hackathon,
    required this.iswishlist,
    required this.imageUrl,
    required this.iscompleted,
  });

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
  late Timer _timer;
  late Duration _timeLeft;

  @override
  void initState() {
    super.initState();
    _calculateTimeLeft();
    _startTimer();
  }

  void _calculateTimeLeft() {
    final now = DateTime.now();
    final hackathonDateTime = DateTime(
      widget.startdate.year,
      widget.startdate.month,
      widget.startdate.day,
      widget.starttime.hour,
      widget.starttime.minute,
    );
    _timeLeft = hackathonDateTime.difference(now);
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      setState(() {
        _calculateTimeLeft();
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  String _formatTimeLeft(Duration duration) {
    if (duration.isNegative) {
      return "Started";
    }
    final days = duration.inDays;
    final hours = duration.inHours % 24;
    final minutes = duration.inMinutes % 60;
    final seconds = duration.inSeconds % 60;
    return days > 0
        ? "$days days $hours hrs $minutes mins"
        : "$hours hrs $minutes mins $seconds secs";
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(12.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      elevation: 6.0,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: () {},
            child: Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(12.0),
                  ),
                  child: FadeInImage(
                    placeholder: MemoryImage(kTransparentImage),
                    image: NetworkImage(widget.imageUrl),
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: 200.0,
                  ),
                ),
                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.black.withOpacity(0.6),
                          Colors.black.withOpacity(0.2),
                        ],
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                      ),
                    ),
                    child: Center(
                      child: Icon(
                        widget.iscompleted ? Icons.check : Icons.lock_clock,
                        color: widget.iscompleted
                            ? Colors.green
                            : Colors.redAccent,
                        size: 60.0,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.name,
                  style: const TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 6.0),
                Row(
                  children: [
                    const Icon(Icons.location_on,
                        size: 18.0, color: Colors.grey),
                    const SizedBox(width: 6.0),
                    Text(
                      widget.location,
                      style: const TextStyle(
                        fontSize: 14.0,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8.0),
                Row(
                  children: [
                    const Icon(Icons.calendar_today,
                        size: 18.0, color: Colors.grey),
                    const SizedBox(width: 6.0),
                    Text(
                      "${widget.startdate.day}/${widget.startdate.month}/${widget.startdate.year}",
                      style:
                          const TextStyle(fontSize: 14.0, color: Colors.grey),
                    ),
                    const Spacer(),
                    Text(
                      widget.iscompleted
                          ? "Status: Completed"
                          : "Status: Not Completed",
                      style: TextStyle(
                        fontSize: 14.0,
                        color: widget.iscompleted
                            ? Colors.green
                            : Colors.redAccent,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8.0),
                Row(
                  children: [
                    const Icon(Icons.access_time,
                        size: 18.0, color: Colors.grey),
                    const SizedBox(width: 6.0),
                    Text(
                      _formatTimeLeft(_timeLeft),
                      style: TextStyle(
                        fontSize: 14.0,
                        color: _timeLeft.isNegative
                            ? Colors.green
                            : Colors.redAccent,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
