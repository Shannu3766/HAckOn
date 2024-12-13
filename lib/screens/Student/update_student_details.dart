import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hackon/screens/Student/student_home_screen.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

class UpdateStudentDetails extends StatefulWidget {
  const UpdateStudentDetails({super.key});

  @override
  _UpdateStudentDetailsState createState() => _UpdateStudentDetailsState();
}

class _UpdateStudentDetailsState extends State<UpdateStudentDetails> {
  String? Semster;
  final user = FirebaseAuth.instance.currentUser!;
  var name = "";
  var college = "";
  var department = "";
  var phonenumber = "";
  File? _pickedImage;
  bool _isUploading = false;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedFile =
        await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _pickedImage = File(pickedFile.path);
      });
    }
  }

  Future<String?> uploadImageToAzure(File imageFile) async {
    // Replace with your storage account details and SAS token
    const String storageAccountName = 'hackon';
    const String containerName = 'photos'; // Your container name
    const String sasToken =
        'sp=racwdl&st=2024-12-05T14:47:56Z&se=2024-12-27T22:47:56Z&spr=https&sv=2022-11-02&sr=c&sig=VhMf6V2JUb86jGCQLt4a6Df9k4ih9254zYSRvhax7N4%3D';

    // Generate the blob name dynamically or use a predefined name
    final String blobName = 'image_${user.uid}.jpg';

    // Construct the full upload URL
    final String uploadUrl =
        'https://$storageAccountName.blob.core.windows.net/$containerName/$blobName?$sasToken';

    try {
      // Read the image bytes
      final imageBytes = await imageFile.readAsBytes();

      // Make the PUT request to upload the image
      final response = await http.put(
        Uri.parse(uploadUrl),
        headers: {
          'x-ms-blob-type': 'BlockBlob', // Mandatory header for block blobs
          'Content-Type':
              'image/jpeg', // Ensure the content type matches your file
        },
        body: imageBytes,
      );

      if (response.statusCode == 201) {
        print('Image uploaded successfully!');
        // Return the image URL (excluding SAS token for sharing purposes)
        return uploadUrl.split('?')[0];
      } else {
        print('Failed to upload image. Status Code: ${response.statusCode}');
        print('Response Body: ${response.body}');
        return null;
      }
    } catch (e) {
      print('Error uploading image: $e');
      return null;
    }
  }

  void _submit() async {
    final isValid = _formKey.currentState!.validate();
    if (!isValid) {
      return;
    }
    _formKey.currentState!.save();

    if (_pickedImage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select an image')),
      );
      return;
    }

    setState(() {
      _isUploading = true;
    });

    final imageUrl = await uploadImageToAzure(_pickedImage!);
    if (imageUrl == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Image upload failed')),
      );
      setState(() {
        _isUploading = false;
      });
      return;
    }
    FirebaseFirestore.instance.collection('Students').doc(user.uid).set({
      'name': name,
      'college': college,
      'department': department,
      'phonenumber': phonenumber,
      'imageUrl': imageUrl,
      'sem': Semster,
    });
    await user.updatePhotoURL(imageUrl);
    setState(() {
      _isUploading = false;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Student details updated successfully!')),
    );
    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) {
      return const Student_home_screen();
    }));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('HAckOn'),
        actions: [
          IconButton(
            onPressed: () {
              FirebaseAuth.instance.signOut();
            },
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          decoration: const BoxDecoration(
              gradient: LinearGradient(colors: [Colors.blue, Colors.blue])),
          child: Column(
            children: [
              const SizedBox(
                height: 15,
              ),
              CircleAvatar(
                radius: MediaQuery.of(context).size.width * 0.25,
                backgroundImage: _pickedImage == null
                    ? const NetworkImage(
                        'https://images.pexels.com/photos/91227/pexels-photo-91227.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1')
                    : FileImage(_pickedImage!),
              ),
              const SizedBox(
                height: 5,
              ),
              ElevatedButton.icon(
                onPressed: _pickImage,
                icon: const Icon(
                  Icons.image,
                  color: Colors.black,
                ),
                label: const Text(
                  'Pick Image',
                  style: TextStyle(color: Colors.black),
                ),
              ),
              Card(
                margin: const EdgeInsets.all(20),
                child: Form(
                  key: _formKey,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        TextFormField(
                          decoration: const InputDecoration(
                            labelText: 'Name',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(10.0),
                              ),
                              borderSide: BorderSide(
                                color: Colors.black,
                              ),
                            ),
                          ),
                          // initialValue: "shanmukah srinivas",
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter your name';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            name = value!;
                          },
                        ),
                        const SizedBox(height: 10),
                        TextFormField(
                          decoration: const InputDecoration(
                            labelText: 'College',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(10.0),
                              ),
                              borderSide: BorderSide(
                                color: Colors.black,
                              ),
                            ),
                          ),
                          // initialValue: "amrita visea vidyapetham",
                          onSaved: (value) {
                            college = value!;
                          },
                        ),
                        const SizedBox(height: 10),
                        TextFormField(
                          decoration: const InputDecoration(
                            labelText: 'Department',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(10.0),
                              ),
                              borderSide: BorderSide(
                                color: Colors.black,
                              ),
                            ),
                          ),
                          // initialValue: "cse",
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter your department';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            department = value!;
                          },
                        ),
                        const SizedBox(height: 10),
                        TextFormField(
                          decoration: const InputDecoration(
                            labelText: 'Phone Number',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(10.0),
                              ),
                              borderSide: BorderSide(
                                color: Colors.black,
                              ),
                            ),
                          ),
                          keyboardType: TextInputType.phone,
                          // initialValue: "1234567890",
                          validator: (value) {
                            if (value!.isEmpty || value.length < 10) {
                              return 'Invalid phone number';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            phonenumber = value!;
                          },
                        ),
                        const SizedBox(height: 10),
                        DropdownButtonFormField<String>(
                          decoration: const InputDecoration(
                            labelText: 'Select Semster',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(10.0),
                              ),
                              borderSide: BorderSide(
                                color: Colors.black,
                              ),
                            ),
                          ),
                          value: Semster,
                          items: const [
                            DropdownMenuItem(
                              value: 'Sem1',
                              child: Text('Sem1'),
                            ),
                            DropdownMenuItem(
                              value: 'Sem2',
                              child: Text('Sem2'),
                            ),
                            DropdownMenuItem(
                              value: 'Sem3',
                              child: Text('Sem3'),
                            ),
                            DropdownMenuItem(
                              value: 'Sem4',
                              child: Text('Sem4'),
                            ),
                            DropdownMenuItem(
                              value: 'Sem5',
                              child: Text('Sem5'),
                            ),
                            DropdownMenuItem(
                              value: 'Sem6',
                              child: Text('Sem6'),
                            ),
                            DropdownMenuItem(
                              value: 'Sem7',
                              child: Text('Sem7'),
                            ),
                            DropdownMenuItem(
                              value: 'Sem8',
                              child: Text('Sem8'),
                            ),
                          ],
                          validator: (value) {
                            if (value == null) {
                              return 'Please select a Semster';
                            }
                            return null;
                          },
                          onChanged: (value) {
                            setState(() {
                              Semster = value!;
                            });
                          },
                        ),
                        const SizedBox(height: 20),
                        ElevatedButton.icon(
                          icon: Icon(Icons.upload),
                          onPressed: _isUploading ? null : _submit,
                          label: _isUploading
                              ? const CircularProgressIndicator()
                              : const Text('Submit'),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
