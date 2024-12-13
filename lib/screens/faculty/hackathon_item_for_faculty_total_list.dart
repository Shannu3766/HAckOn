import 'package:flutter/material.dart';
import 'package:hackon/classes/hackathon.dart';
import 'package:hackon/screens/faculty/hackathonviewfaculty.dart';
import 'package:hackon/widgets/placeholder_trait.dart';
import 'package:transparent_image/transparent_image.dart';

class HackathonItemForFacultyTotalList extends StatefulWidget {
  const HackathonItemForFacultyTotalList({
    super.key,
    required this.name,
    required this.location,
    required this.startdate,
    required this.starttime,
    required this.hackathon,
    required this.iswishlist,
    required this.imageUrl,
  });

  final bool iswishlist;
  final String name;
  final String location;
  final DateTime startdate;
  final String imageUrl;
  final TimeOfDay starttime;
  final Hackathon hackathon;

  @override
  State<HackathonItemForFacultyTotalList> createState() =>
      _HackathonItemForFacultyTotalListState();
}

class _HackathonItemForFacultyTotalListState
    extends State<HackathonItemForFacultyTotalList> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var time = widget.starttime.format(context);
    var date = "${widget.startdate.day}/${widget.startdate.month}";

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => hacakthonviewFaculty(
                hackathon: widget.hackathon,
              ),
            ),
          );
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Hackathon Image with Gradient Overlay
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(12),
                  ),
                  child: Container(
                    width: double.infinity,
                    height: 180,
                    child: FadeInImage(
                      fit: BoxFit.cover,
                      placeholder: MemoryImage(kTransparentImage),
                      image: NetworkImage(widget.imageUrl),
                    ),
                  ),
                ),
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.black54,
                          Colors.transparent,
                        ],
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                      ),
                    ),
                    child: Text(
                      widget.name,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),

            // Hackathon Details Section
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                children: [
                  Row(
                    children: [
                      Abouthacko(icon: Icons.schedule, label: time),
                      const Spacer(),
                      Abouthacko(icon: Icons.calendar_today, label: date),
                      const Spacer(),
                      Abouthacko(
                          icon: Icons.location_city_sharp,
                          label: widget.location),
                    ],
                  ),
                  const SizedBox(height: 10),
                  if (widget.iswishlist)
                    Chip(
                      label: const Text(
                        'Wishlist',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      backgroundColor: Colors.blue,
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
