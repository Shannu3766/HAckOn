import 'dart:io';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AddHackathon extends StatefulWidget {
  @override
  _AddHackathonState createState() => _AddHackathonState();
}

class _AddHackathonState extends State<AddHackathon> {
  var _isuploading = false;
  final user = FirebaseAuth.instance.currentUser!;
  var name = "";
  var description = "";
  var location = "";
  var startDate = "";
  var endDate = "";
  var imageUrl = "";
  var createdBy = "";
  File? _pickedImage;
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  var hacathonid;
  DateTime? _selectedStartDate;
  DateTime? _selectedEndDate;
  TimeOfDay? _selectedStartTime;
  TimeOfDay? _selectedEndTime;
  String generateRandomId() {
    final random = Random();
    const length = 10;
    const chars = '0123456789';
    final randomId =
        List.generate(length, (index) => chars[random.nextInt(chars.length)])
            .join();
    return '${user.uid}_$randomId';
  }

  Future<String?> uploadImageToAzure(File imageFile) async {
    // Replace with your storage account details and SAS token
    final String storageAccountName = 'hackon';
    final String containerName = 'hackathons'; // Your container name
    final String sasToken =
        'sp=racwdl&st=2024-12-04T13:44:50Z&se=2024-12-04T21:44:50Z&spr=https&sv=2022-11-02&sr=c&sig=%2F4U9PeTrBZIL52p2HQAbTLNw7PjSVmMgLRYPEB8KH6s%3D';
    final String blobName =
        'image_${DateTime.now().millisecondsSinceEpoch}.jpg';

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

  DateTime combineDateAndTime(DateTime date, TimeOfDay time) {
    return DateTime(date.year, date.month, date.day, time.hour, time.minute);
  }

  void _pickStartDate() async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null) {
      setState(() {
        _selectedStartDate = pickedDate;
      });
    }
  }

  void _createHackathon() async {
    if (_pickedImage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please pick an image'),
        ),
      );
      return;
    }
    bool isvalid = _formKey.currentState!.validate();
    if (!isvalid) {
      return;
    }
    if (_selectedStartDate == null ||
        _selectedEndDate == null ||
        _selectedStartTime == null ||
        _selectedEndTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select date and time'),
        ),
      );

      return;
    }
    if (_selectedStartDate!.isAfter(_selectedEndDate!)) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("The Startdate is should be after end date")));
      return;
    }
    _formKey.currentState!.save();
    setState(() {
      _isuploading = !_isuploading;
    });
    var image_url = await uploadImageToAzure(_pickedImage!);
    try {
      DateTime startDateTime =
          combineDateAndTime(_selectedStartDate!, _selectedStartTime!);
      DateTime endDateTime =
          combineDateAndTime(_selectedEndDate!, _selectedEndTime!);
      hacathonid = generateRandomId();
      await FirebaseFirestore.instance
          .collection('faculty')
          .doc(user.uid)
          .collection("hackathons")
          .doc(hacathonid)
          .set({
        'name': name,
        'description': description,
        'location': location,
        'startDate': startDateTime,
        'endDate': endDateTime,
        "imageUrl": image_url ?? '',
        'createdBy': user.uid,
        'id': hacathonid
      });

      await FirebaseFirestore.instance
          .collection("hackathons")
          .doc(hacathonid)
          .set({
        'name': name,
        'description': description,
        'location': location,
        'startDate': startDateTime,
        'endDate': endDateTime,
        "imageUrl": image_url ?? '',
        'createdBy': user.uid,
        'id': hacathonid
      });
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Hackathon has been added succesfully"),
        backgroundColor: Colors.green,
      ));
    } catch (e) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Hackathon unable to add succesfully"),
        backgroundColor: Colors.red,
      ));
      print(e.toString());
    }
    setState(() {
      _isuploading = !_isuploading;
    });
  }

  void _pickEndDate() async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null) {
      setState(() {
        _selectedEndDate = pickedDate;
      });
    }
  }

  void _pickStartTime() async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (pickedTime != null) {
      setState(() {
        _selectedStartTime = pickedTime;
      });
    }
  }

  void _pickEndTime() async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (pickedTime != null) {
      setState(() {
        _selectedEndTime = pickedTime;
      });
    }
  }

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedFile = await picker.pickImage(
        source: ImageSource.gallery, maxHeight: 600, maxWidth: 600);

    if (pickedFile != null) {
      setState(() {
        _pickedImage = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Hackathon'),
        actions: [
          IconButton(
            onPressed: () {
              FirebaseAuth.instance.signOut();
            },
            icon: Icon(Icons.logout),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              Container(
                  padding: const EdgeInsets.all(10),
                  child: _pickedImage == null
                      ? Image(
                          image: const NetworkImage(
                              'https://images.pexels.com/photos/91227/pexels-photo-91227.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1'))
                      : Image(image: FileImage(_pickedImage!))),
              TextButton.icon(
                onPressed: _pickImage,
                icon: const Icon(Icons.image),
                label: const Text('Uplaod the poster'),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        decoration:
                            InputDecoration(labelText: 'Hackathon Name'),
                        initialValue: "Hackon",
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter a name';
                          }
                          if (value.length < 4) {
                            return 'Name should be at least 4 characters long';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          name = value!;
                        },
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        initialValue: "kjdnskjf ",
                        decoration: const InputDecoration(
                          labelText: 'Description',
                          alignLabelWithHint: true,
                          border: OutlineInputBorder(),
                        ),
                        maxLines: 5,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter a description';
                          }
                          if (value.length < 10) {
                            return 'Description should be at least 10 characters long';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          description = value!;
                        },
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        decoration: InputDecoration(labelText: 'Location'),
                        initialValue: "Kochi",
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter a location';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          location = value!;
                        },
                      ),
                      SizedBox(height: 20),
                      Row(
                        children: [
                          Text(
                            _selectedStartDate == null
                                ? 'Select Start Date'
                                : 'Start Date: ${_selectedStartDate!.day}/${_selectedStartDate!.month}/${_selectedStartDate!.year}',
                            style: TextStyle(fontSize: 16),
                          ),
                          Spacer(),
                          IconButton(
                            icon: Icon(Icons.calendar_today),
                            onPressed: _pickStartDate,
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Text(
                            _selectedStartTime == null
                                ? 'Select Start Time'
                                : 'Start Time: ${_selectedStartTime!.format(context)}',
                            style: TextStyle(fontSize: 16),
                          ),
                          Spacer(),
                          IconButton(
                            icon: Icon(Icons.access_time),
                            onPressed: _pickStartTime,
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Text(
                            _selectedEndDate == null
                                ? 'Select End Date'
                                : 'Start Date: ${_selectedEndDate!.day}/${_selectedEndDate!.month}/${_selectedEndDate!.year}',
                            style: TextStyle(fontSize: 16),
                          ),
                          Spacer(),
                          IconButton(
                            icon: Icon(Icons.calendar_today),
                            onPressed: _pickEndDate,
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Text(
                            _selectedEndTime == null
                                ? 'Select End Time'
                                : 'Start Time: ${_selectedEndTime!.format(context)}',
                            style: TextStyle(fontSize: 16),
                          ),
                          Spacer(),
                          IconButton(
                              icon: Icon(Icons.access_time),
                              onPressed: _pickEndTime),
                        ],
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      _isuploading
                          ? CircularProgressIndicator()
                          : ElevatedButton(
                              onPressed: () {
                                _createHackathon();
                              },
                              child: Text('Create Hackathon'),
                            ),
                    ],
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
