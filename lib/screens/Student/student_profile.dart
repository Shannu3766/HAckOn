import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ProfilePage_student extends StatefulWidget {
  const ProfilePage_student({Key? key}) : super(key: key);

  @override
  State<ProfilePage_student> createState() => _ProfilePage_studentState();
}

class _ProfilePage_studentState extends State<ProfilePage_student> {
  var imageurl = "";
  var name = "";
  var email = "";
  var phone = "";
  var department = "";
  var college = "";
  final user = FirebaseAuth.instance.currentUser!;

  void get_faculty_details() async {
    final snapshot = await FirebaseFirestore.instance
        .collection('Students')
        .doc(user.uid)
        .get();
    setState(() {
      imageurl = snapshot['imageUrl'];
      name = snapshot['name'];
      email = user.email!;
      phone = snapshot['phonenumber'];
      department = snapshot['department'];
      college = snapshot['college'];
    });
  }

  @override
  void initState() {
    get_faculty_details();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              const SizedBox(height: 20),
              // Profile Picture with Border
              Container(
                width: MediaQuery.of(context).size.width * 0.4,
                height: MediaQuery.of(context).size.width * 0.4,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.black,
                    width: 5.0,
                  ),
                ),
                child: CircleAvatar(
                  foregroundImage: NetworkImage(imageurl),
                  backgroundImage: const NetworkImage(
                      'https://images.pexels.com/photos/91227/pexels-photo-91227.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1'),
                  backgroundColor: Colors.black,
                ),
              ),
              const SizedBox(height: 20),
              // Name
              Text(
                name,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              // Details Section
              Card(
                margin: const EdgeInsets.all(16.0),
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      ListTile(
                        leading: const Icon(Icons.email),
                        title: const Text('Email'),
                        subtitle: Text(email),
                      ),
                      const Divider(),
                      ListTile(
                        leading: const Icon(Icons.phone),
                        title: const Text('Phone'),
                        subtitle: Text(phone),
                      ),
                      const Divider(),
                      ListTile(
                        leading: const Icon(Icons.school),
                        title: const Text('Department'),
                        subtitle: Text(department),
                      ),
                      const Divider(),
                      ListTile(
                        leading: const Icon(Icons.location_city),
                        title: const Text('College'),
                        subtitle: Text(college),
                      ),
                    ],
                  ),
                ),
              ),
              // Logout Button
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: ElevatedButton(
                  onPressed: () {
                    FirebaseAuth.instance.signOut();
                    // Redirect to login screen
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    // primarycol: Colors.red, // Red color for logout
                    padding: const EdgeInsets.symmetric(
                        vertical: 12.0, horizontal: 32.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  child: const Text(
                    'Logout',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
