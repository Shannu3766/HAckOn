import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hackon/screens/hacakthon_view.dart';
import 'package:hackon/screens/registred_hackathons.dart';
import 'package:hackon/screens/wishlist.dart';
import 'package:hackon/widgets/view_hackathon.dart';

class Student_screen extends StatefulWidget {
  const Student_screen({super.key});

  @override
  State<Student_screen> createState() => _Student_screenState();
}

class _Student_screenState extends State<Student_screen> {
  int _currentIndex = 0;
  final List<Widget> _pages = [
    Expanded(child: ViewHackathon()),
    Wishlistscreen(),
    RegistredHackathons(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () {
                FirebaseAuth.instance.signOut();
              },
              icon: Icon(Icons.exit_to_app))
        ],
      ),
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex, // Highlight the selected item
        onTap: (index) {
          setState(() {
            _currentIndex = index; // Update the current index
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_bag),
            label: 'Wishlist',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.how_to_reg),
            label: 'Registred',
          ),
        ],
      ),
    );
  }
}
