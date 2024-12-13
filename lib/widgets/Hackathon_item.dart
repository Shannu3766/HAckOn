import 'package:flutter/material.dart';
import 'package:hackon/classes/hackathon.dart';
import 'package:hackon/widgets/hackathon_details.dart';
import 'package:hackon/widgets/placeholder_trait.dart';
import 'package:transparent_image/transparent_image.dart';

class HackathonItem extends StatefulWidget {
  const HackathonItem({
    Key? key,
    required this.name,
    required this.location,
    required this.startDate,
    required this.startTime,
    required this.hackathon,
    required this.isWishlist,
    required this.imageUrl,
  }) : super(key: key);

  final bool isWishlist;
  final String name;
  final String location;
  final DateTime startDate;
  final String imageUrl;
  final TimeOfDay startTime;
  final Hackathon hackathon;

  @override
  State<HackathonItem> createState() => _HackathonItemState();
}

class _HackathonItemState extends State<HackathonItem> {
  @override
  Widget build(BuildContext context) {
    var time = widget.startTime.format(context);
    var date = "${widget.startDate.day}/${widget.startDate.month}";

    return Card(
      margin: const EdgeInsets.all(12.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      elevation: 6.0,
      child: GestureDetector(
        onTap: () {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => hackathon_details(
              hackathon: widget.hackathon,
              iswishlist: widget.isWishlist,
            ),
          ));
        },
        child: Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12.0),
              child: FadeInImage(
                placeholder: MemoryImage(kTransparentImage),
                image: NetworkImage(widget.imageUrl),
                fit: BoxFit.cover,
                width: double.infinity,
                height: 200.0,
              ),
            ),
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: Container(
                padding: const EdgeInsets.all(12.0),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.black.withOpacity(0.7),
                      Colors.black.withOpacity(0.3),
                    ],
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                  ),
                  borderRadius: const BorderRadius.vertical(
                    bottom: Radius.circular(12.0),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 6.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Traititem(icon: Icons.schedule, label: time),
                        Traititem(icon: Icons.calendar_today, label: date),
                        Traititem(
                            icon: Icons.location_on, label: widget.location),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
