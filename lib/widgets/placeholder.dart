// import 'package:flutter/material.dart';
// import 'package:hackon/classes/hackathon.dart';
// import 'package:hackon/screens/Student/hacakthon_view.dart';
// import 'package:hackon/widgets/placeholder_trait.dart';
// import 'package:transparent_image/transparent_image.dart';

// class hackathon_item extends StatefulWidget {
//   const hackathon_item(
//       {super.key,
//       required this.name,
//       required this.location,
//       required this.startdate,
//       required this.starttime,
//       required this.hackathon,
//       required this.iswishlist,
//       required this.imageUrl});
//   final bool iswishlist;
//   final String name;
//   final String location;
//   final DateTime startdate;
//   final String imageUrl;
//   final TimeOfDay starttime;
//   final Hackathon hackathon;
//   @override
//   State<hackathon_item> createState() => _hackathon_itemState();
// }

// class _hackathon_itemState extends State<hackathon_item> {
//   @override
//   void initState() {
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     var time = widget.starttime.format(context);
//     var date = "${widget.startdate.day}/${widget.startdate.month}";
//     return Card(
//       child: GestureDetector(
//         onTap: () {
//           Navigator.of(context).push(MaterialPageRoute(
//             builder: (context) => hacakthonview(hackathon: widget.hackathon,iswishlist:widget.iswishlist,),
//           ));
//         },
//         child: Stack(
//           children: [
//             Container(
//               width: MediaQuery.of(context).size.width * 0.9,
//               height: MediaQuery.of(context).size.height * 0.2,
//               child: FadeInImage(
//                 placeholder: MemoryImage(kTransparentImage),
//                 image: NetworkImage(widget.imageUrl),
//               ),
//             ),
//             Positioned(
//               left: 0,
//               right: 0,
//               bottom: 0,
//               child: Container(
//                 color: const Color.fromARGB(124, 0, 0, 0),
//                 child: Column(
//                   children: [
//                     Text(
//                       widget.name,
//                       maxLines: 2,
//                       textAlign: TextAlign.center,
//                       softWrap: true,
//                       overflow: TextOverflow.ellipsis,
//                       style: const TextStyle(
//                         fontSize: 20,
//                         fontWeight: FontWeight.bold,
//                         color: Color.fromARGB(255, 0, 0, 0),
//                       ),
//                     ),
//                     const SizedBox(height: 10),
//                     Row(
//                       children: [
//                         Traititem(icon: Icons.schedule, label: '$time..'),
//                         const Spacer(),
//                         Traititem(icon: Icons.calendar_today, label: '$date'),
//                         const Spacer(),
//                         Traititem(
//                             icon: Icons.location_city_sharp,
//                             label: widget.location),
//                         const Spacer(),
//                       ],
//                     )
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:hackon/classes/hackathon.dart';
import 'package:hackon/screens/Student/hacakthon_view.dart';
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
            builder: (context) => hacakthonview(
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
                        Traititem(icon: Icons.location_on, label: widget.location),
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
