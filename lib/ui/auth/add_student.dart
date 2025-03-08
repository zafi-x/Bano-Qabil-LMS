import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:qabilacademy/components/main_button.dart';
import 'package:qabilacademy/ui/auth/login_screen.dart';

class AddStudent extends StatefulWidget {
  final String uid;
  final String name;
  final String email;
  final String role;

  const AddStudent(
      {super.key,
      required this.uid,
      required this.name,
      required this.email,
      required this.role});

  @override
  State<AddStudent> createState() => _AddStudentState();
}

class _AddStudentState extends State<AddStudent> {
  final _formKey = GlobalKey<FormState>();
  String? _selectedCourse;
  final TextEditingController _batchController = TextEditingController();
  final TextEditingController _courseController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _rollNoController = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  bool isLoading = false;
  String? _selectedBatch;

  void saveStudentInfo() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        isLoading = true;
      });

      try {
        await _firestore.collection('users').doc(widget.uid).set({
          'uid': widget.uid,
          'name': widget.name,
          'email': widget.email,
          'role': widget.role,
          'phone': _phoneController.text.trim(),
          'rollNo': _rollNoController.text.trim(),
          'course': _selectedCourse,
          'batch': _selectedBatch,
          'createdAt': DateTime.now(),
        });

        Get.snackbar('Success', 'Student information saved!',
            backgroundColor: Colors.green, colorText: Colors.white);
        Get.to(() => const LoginScreen());
      } catch (e) {
        Get.snackbar('Error', 'Could not save data. Try again!',
            backgroundColor: Colors.red, colorText: Colors.white);
      } finally {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Fill The Form")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                TextFormField(
                  controller: _rollNoController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                      labelText: "Roll NO",
                      fillColor: Colors.indigo[50],
                      filled: true,
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.indigo),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.grey),
                        borderRadius: BorderRadius.circular(10),
                      )),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Enter Roll No!';
                    }
                    return null;
                  },
                ),
                // Store selected value

                DropdownButtonFormField<String>(
                  value: _selectedCourse,
                  decoration: InputDecoration(
                    labelText: "Course",
                    fillColor: Colors.indigo[50],
                    filled: true,
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.indigo),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.grey),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  items: [
                    "App Development",
                    "Web Development",
                    "Video Editing",
                    "Graphic Designing",
                    "E-Commerce",
                    "Digital Marketing",
                  ].map((course) {
                    return DropdownMenuItem<String>(
                      value: course,
                      child: Text(course),
                    );
                  }).toList(),
                  onChanged: (value) {
                    _selectedCourse = value;
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please select a course!';
                    }
                    return null;
                  },
                ),
                DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                    labelText: "Batch",
                    fillColor: Colors.indigo[50],
                    filled: true,
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.indigo),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.grey),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  items: [
                    "001",
                    "002",
                    "003",
                    "004",
                    "005",
                    "006",
                    "007",
                    "008",
                    "009",
                  ].map((batch) {
                    return DropdownMenuItem<String>(
                      value: batch,
                      child: Text(batch),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedBatch = value;
                    });
                    // Store selected batch
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please select a batch!';
                    }
                    return null;
                  },
                ),

                TextFormField(
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(
                    labelText: "Phone Number",
                    fillColor: Colors.indigo[50],
                    filled: true,
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.indigo),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.grey),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  inputFormatters: [
                    FilteringTextInputFormatter
                        .digitsOnly, // Only allows numeric input
                    LengthLimitingTextInputFormatter(
                        11), // Limits input to 11 digits
                  ],
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Enter phone number!';
                    } else if (value.length != 11) {
                      return 'Phone number must be exactly 11 digits!';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: isLoading ? null : saveStudentInfo,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.indigo, // Teal color
                    minimumSize:
                        const Size(200, 50), // Increased width and height
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(10), // Slightly rounded corners
                    ),
                  ),
                  child: isLoading
                      ? const CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(
                              Colors.white), // White loader
                        )
                      : const Text(
                          "Save",
                          style: TextStyle(
                              color: Colors.white, fontSize: 18), // White text
                        ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
