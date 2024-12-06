import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hackon/screens/Student/update_student_details.dart';
import 'package:hackon/screens/faculty/Update_faculty_details.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  String? selectedRole;
  var username = "";
  var password = "";
  var confirmpassword = "";
  bool islogin = true;
  bool isloading = false;
  bool _obscurepassword = true;
  bool _obscureconfirmpassword = true;

  final _formkey = GlobalKey<FormState>();
  final _firebase = FirebaseAuth.instance;
  void fetchDisplayName() {
    final user = FirebaseAuth.instance.currentUser;
    final displayName = user!.displayName;
  }

  void _submit() async {
    final isValid = _formkey.currentState?.validate() ?? false;
    if (isValid) {
      _formkey.currentState?.save();
      try {
        if (islogin) {
          final userCred = await _firebase.signInWithEmailAndPassword(
            email: username,
            password: password,
          );
          var displayname = userCred.user!.displayName;
          if (displayname == selectedRole) {
            if (selectedRole == 'Student') {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context) => const UpdateStudentDetails(),
                ),
              );
            } else {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context) => const UpdateFacultyDetails(),
                ),
              );
            }
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Invalid Role'),
                backgroundColor: Colors.red,
              ),
            );
            _firebase.signOut();
            return;
          }
        } else {
          // Sign-up logic
          if (password == confirmpassword) {
            final userCred = await _firebase.createUserWithEmailAndPassword(
              email: username,
              password: password,
            );
            await userCred.user!.updateDisplayName(selectedRole);
            if (selectedRole == 'Student') {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context) => const UpdateStudentDetails(),
                ),
              );
            } else {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context) => const UpdateFacultyDetails(),
                ),
              );
            }
          } else {
            // Passwords do not match
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Passwords do not match'),
                backgroundColor: Colors.red,
              ),
            );
          }
        }
      } on FirebaseAuthException catch (error) {
        // Handle Firebase errors
        ScaffoldMessenger.of(context).clearSnackBars();
        String errorMessage;
        switch (error.code) {
          case 'email-already-in-use':
            errorMessage = 'This email is already in use.';
            break;
          case 'user-not-found':
            errorMessage = 'No user found with this email.';
            break;
          case 'wrong-password':
            errorMessage = 'Incorrect password.';
            break;
          default:
            errorMessage = error.message ?? 'Authentication failed.';
        }
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(errorMessage), backgroundColor: Colors.red),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.blue,
              Colors.blue,
              // Colors.purple,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleAvatar(
                    backgroundImage: AssetImage("assets/images/icon.png"),
                    radius: MediaQuery.of(context).size.width * 0.3,
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.09,
                  ),
                  Form(
                    key: _formkey,
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            TextFormField(
                              decoration: const InputDecoration(
                                labelText: 'Email',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(10.0),
                                  ),
                                  borderSide: BorderSide(
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                              // initialValue: "hello@gmail.com",
                              keyboardType: TextInputType.emailAddress,
                              validator: (value) {
                                if (value!.isEmpty || !value.contains('@')) {
                                  return 'Invalid email';
                                }
                                return null;
                              },
                              onSaved: (value) {
                                username = value!;
                              },
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            TextFormField(
                              decoration: InputDecoration(
                                labelText: 'Password',
                                border: const OutlineInputBorder(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(10.0),
                                  ),
                                  borderSide: BorderSide(
                                    color: Colors.black,
                                  ),
                                ),
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    _obscurepassword
                                        ? Icons.visibility
                                        : Icons.visibility_off,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      _obscurepassword = !_obscurepassword;
                                    });
                                  },
                                ),
                              ),
                              obscureText: _obscurepassword,
                              // initialValue: '1234567',
                              validator: (value) {
                                if (value!.isEmpty || value.length < 7) {
                                  return 'Password must be at least 7 characters long';
                                }
                                return null;
                              },
                              onSaved: (value) {
                                password = value!;
                              },
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            if (!islogin)
                              TextFormField(
                                decoration: InputDecoration(
                                  labelText: 'Confirm Password',
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(10.0),
                                    ),
                                    borderSide: BorderSide(
                                      color: Colors.black,
                                    ),
                                  ),
                                  suffixIcon: IconButton(
                                    icon: Icon(
                                      _obscureconfirmpassword
                                          ? Icons.visibility
                                          : Icons.visibility_off,
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        _obscureconfirmpassword =
                                            !_obscureconfirmpassword;
                                      });
                                    },
                                  ),
                                ),
                                obscureText: true,
                                // initialValue: '1234567',
                                validator: (value) {
                                  if (value!.isEmpty || value.length < 7) {
                                    return 'Password must be at least 7 characters long';
                                  }
                                  return null;
                                },
                                onSaved: (value) {
                                  confirmpassword = value!;
                                },
                              ),
                            const SizedBox(
                              height: 10,
                            ),
                            DropdownButtonFormField<String>(
                              decoration: const InputDecoration(
                                labelText: 'Select Role',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(10.0),
                                  ),
                                  borderSide: BorderSide(
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                              value: selectedRole,
                              items: const [
                                DropdownMenuItem(
                                  value: 'Student',
                                  child: Text('Student'),
                                ),
                                DropdownMenuItem(
                                  value: 'Faculty',
                                  child: Text('Faculty'),
                                ),
                              ],
                              validator: (value) {
                                if (value == null) {
                                  return 'Please select a role';
                                }
                                return null;
                              },
                              onChanged: (value) {
                                setState(() {
                                  selectedRole = value!;
                                });
                              },
                            ),
                            const SizedBox(height: 20),
                            ElevatedButton(
                              onPressed: _submit,
                              child: Text(islogin ? 'Login' : 'Sign Up'),
                            ),
                            TextButton(
                              onPressed: () {
                                setState(() {
                                  islogin = !islogin;
                                });
                              },
                              child: Text(islogin
                                  ? 'Create new account'
                                  : 'I already have an account'),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
