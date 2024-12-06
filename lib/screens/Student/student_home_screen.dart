import 'package:flutter/material.dart';
import 'package:hackon/screens/Student/registred_hackathons.dart';
import 'package:hackon/screens/Student/student_profile.dart';
import 'package:hackon/screens/wishlist_screen.dart';
import 'package:hackon/screens/Hackathon_list.dart';

class Student_home_screen extends StatefulWidget {
  const Student_home_screen({super.key});

  @override
  State<Student_home_screen> createState() => _Student_home_screenState();
}

class _Student_home_screenState extends State<Student_home_screen> {
  int _currentIndex = 0;
  final List<Widget> _pages = [
    Expanded(child: Hackathon_list()),
    Wishlistscreen(),
    RegistredHackathons(),
    ProfilePage_student(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text("HackON"),
        actions: [],
      ),
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex, // Highlight the selected item
        onTap: (index) {
          setState(() {
            _currentIndex = index; // Update the current index
          });
        },
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.black,
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
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
