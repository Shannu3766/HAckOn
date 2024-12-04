import 'package:flutter/material.dart';

class Traititem extends StatelessWidget {
  const Traititem({super.key, required this.icon, required this.label});
  final IconData icon;
  final String label;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(3.0),
      child: Row(
        children: [
          Icon(
            icon,
            size: 25,
            color: const Color.fromARGB(255, 255, 255, 255),
          ),
          const SizedBox(
            height: 20,
            width: 5,
          ),
          Text(
            label,
            style: const TextStyle(
              color: Color.fromARGB(255, 255, 255, 255),
            ),
          )
        ],
      ),
    );
  }
}

class Traititem_view extends StatelessWidget {
  const Traititem_view({super.key, required this.icon, required this.label});
  final IconData icon;
  final String label;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(3.0),
      child: Row(
        children: [
          Icon(
            icon,
            size: 25,
            color: const Color.fromARGB(255, 0, 0, 0),
          ),
          const SizedBox(
            height: 20,
            width: 5,
          ),
          Text(
            label,
            style: const TextStyle(
                color: Color.fromARGB(255, 0, 0, 0), fontSize: 20),
          )
        ],
      ),
    );
  }
}
