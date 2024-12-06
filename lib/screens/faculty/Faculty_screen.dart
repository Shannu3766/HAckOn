import 'package:flutter/material.dart';
import 'package:hackon/screens/faculty/create_hacakthon.dart';
import 'package:hackon/screens/faculty/Profilepage.dart';
import 'package:hackon/screens/faculty/faculty_hackathons.dart';
import 'package:hackon/screens/faculty/hackathon_lists.dart';

class FacultyHomeScreen extends StatefulWidget {
  const FacultyHomeScreen({super.key});

  @override
  State<FacultyHomeScreen> createState() => _FacultyHomeScreenState();
}

class _FacultyHomeScreenState extends State<FacultyHomeScreen> {
  int _currentIndex = 0;
  final List<Widget> _pages = [
    Expanded(child: totalhackathonlist()),
    viewmyhackathons(),
    create_hacakthon(),
    ProfilePage(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("HackON"),
        backgroundColor: Colors.blue,
      ),
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        // backgroundColor,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.black,
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
            label: 'My',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add),
            label: 'New Hackathon',
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
