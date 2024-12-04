import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'dart:io';


class UpdateFacultyDetails extends StatefulWidget {
  const UpdateFacultyDetails({super.key});

  @override
  _UpdateFacultyDetailsState createState() => _UpdateFacultyDetailsState();
}

class _UpdateFacultyDetailsState extends State<UpdateFacultyDetails> {
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
    final String storageAccountName = 'hackon';
    final String containerName = 'photos'; // Your container name
    final String sasToken =
        'sv=2022-11-02&ss=bfqt&srt=sco&sp=rwdlacupiytfx&se=2025-05-08T14:10:47Z&st=2024-12-04T06:10:47Z&spr=https&sig=%2BcIA9xzL0VKJanJCMumpXs93dy3do%2FHdqJqv3SbW8BY%3D'; // SAS Token

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

    FirebaseFirestore.instance.collection('faculty').doc(user.uid).set({
      'name': name,
      'college': college,
      'department': department,
      'phonenumber': phonenumber,
      'imageUrl': imageUrl,
    });
    await user.updatePhotoURL(imageUrl);
    setState(() {
      _isUploading = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Faculty details updated successfully!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Update Faculty Details'),
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
        child: Column(
          children: [
            CircleAvatar(
              radius: 50,
              backgroundImage: _pickedImage == null
                  ? const NetworkImage(
                      'https://images.pexels.com/photos/91227/pexels-photo-91227.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1')
                  : FileImage(_pickedImage!),
            ),
            TextButton.icon(
              onPressed: _pickImage,
              icon: const Icon(Icons.image),
              label: const Text('Pick Image'),
            ),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    decoration: const InputDecoration(labelText: 'Name'),
                    initialValue: "shanmukah srinivas",
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
                  TextFormField(
                    decoration: const InputDecoration(labelText: 'College'),
                    initialValue: "amrita visea vidyapetham",
                    onSaved: (value) {
                      college = value!;
                    },
                  ),
                  TextFormField(
                    decoration: const InputDecoration(labelText: 'Department'),
                    initialValue: "cse",
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
                  TextFormField(
                    decoration:
                        const InputDecoration(labelText: 'Phone Number'),
                    keyboardType: TextInputType.phone,
                    initialValue: "1234567890",
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
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _isUploading ? null : _submit,
                    child: _isUploading
                        ? const CircularProgressIndicator()
                        : const Text('Submit'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
