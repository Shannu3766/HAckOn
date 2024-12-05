import 'package:flutter/material.dart';
import 'package:hackon/classes/hackathon.dart';
// import 'package:hackon/screens/Student/hacakthon_view.dart';
import 'package:hackon/screens/faculty/hackathonviewfaculty.dart';
import 'package:hackon/widgets/placeholder_trait.dart';
import 'package:transparent_image/transparent_image.dart';

class hackathon_item_for_faculty_total_list extends StatefulWidget {
  const hackathon_item_for_faculty_total_list(
      {super.key,
      required this.name,
      required this.location,
      required this.startdate,
      required this.starttime,
      required this.hackathon,
      required this.iswishlist,
      required this.imageUrl});
  final bool iswishlist;
  final String name;
  final String location;
  final DateTime startdate;
  final String imageUrl;
  final TimeOfDay starttime;
  final Hackathon hackathon;
  @override
  State<hackathon_item_for_faculty_total_list> createState() =>
      _hackathon_item_for_faculty_total_listState();
}

class _hackathon_item_for_faculty_total_listState
    extends State<hackathon_item_for_faculty_total_list> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var time = widget.starttime.format(context);
    var date = "${widget.startdate.day}/${widget.startdate.month}";
    return Card(
      child: Column(
        children: [
          GestureDetector(
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => hacakthonviewFaculty(
                  hackathon: widget.hackathon,
                ),
              ));
            },
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
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: Container(
                    color: const Color.fromARGB(124, 0, 0, 0),
                    child: Column(
                      children: [
                        Text(
                          widget.name,
                          maxLines: 2,
                          textAlign: TextAlign.center,
                          softWrap: true,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Color.fromARGB(255, 255, 255, 255),
                          ),
                        ),
                        const SizedBox(height: 5),
                        Row(
                          children: [
                            Traititem(icon: Icons.schedule, label: '$time..'),
                            const Spacer(),
                            Traititem(
                                icon: Icons.calendar_today, label: '$date'),
                            const Spacer(),
                            Traititem(
                                icon: Icons.location_city_sharp,
                                label: widget.location),
                            const Spacer(),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 2,
          ),
          Text(""),
        ],
      ),
    );
  }
}
