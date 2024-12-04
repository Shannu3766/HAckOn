import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

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
          // Login logic
          final userCred = await _firebase.signInWithEmailAndPassword(
            email: username,
            password: password,
          );
          var displayname = userCred.user!.displayName;
          if (displayname == selectedRole) {
            print("Logged in as $selectedRole");
            print(userCred);
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

          // Update display name to the selected role
         
          // ScaffoldMessenger.of(context).showSnackBar(
          //   SnackBar(
          //     content: Text('Logged in successfully as $selectedRole!'),
          //     backgroundColor: Colors.green,
          //   ),
          // );
        } else {
          // Sign-up logic
          if (password == confirmpassword) {
            final userCred = await _firebase.createUserWithEmailAndPassword(
              email: username,
              password: password,
            );

            // Update display name to the selected role
            await userCred.user!.updateDisplayName(selectedRole);

            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Account created successfully as $selectedRole!'),
                backgroundColor: Colors.green,
              ),
            );
            print(userCred);
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
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Form(
                key: _formkey,
                child: Column(
                  children: [
                    TextFormField(
                      decoration: const InputDecoration(labelText: 'Email'),
                      initialValue: "hello@gmail.com",
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
                    TextFormField(
                      decoration: const InputDecoration(labelText: 'Password'),
                      obscureText: true,
                      initialValue: '1234567',
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
                    if (!islogin)
                      TextFormField(
                        decoration: const InputDecoration(
                            labelText: 'Confirm Password'),
                        obscureText: true,
                        initialValue: '1234567',
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
                    DropdownButtonFormField<String>(
                      decoration:
                          const InputDecoration(labelText: 'Select Role'),
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
                    ElevatedButton(
                        onPressed: () {
                          _firebase.signOut();
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Logged out successfully!'),
                              backgroundColor: Colors.green,
                            ),
                          );
                        },
                        child: const Text("Adfa`"))
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
