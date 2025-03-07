import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qabilacademy/ui/attendence/mark_attendence.dart';

class BatchScreen extends StatefulWidget {
  final String subjectName;
  BatchScreen({required this.subjectName});

  @override
  _BatchScreenState createState() => _BatchScreenState();
}

class _BatchScreenState extends State<BatchScreen> {
  bool isLoading = true;
  List<DocumentSnapshot> batches = [];

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    fetchBatches();
  }

  Future<void> fetchBatches() async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection("subjects")
        .doc(widget.subjectName)
        .collection("batches")
        .get();

    if (mounted) {
      setState(() {
        batches = querySnapshot.docs;
        isLoading = false;
      });
    }
  }

  final TextEditingController _instituteController = TextEditingController();
  final TextEditingController _instructorController = TextEditingController();
  String? selectedBatch;

  void _showBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      isScrollControlled: true,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom:
                MediaQuery.of(context).viewInsets.bottom, // Adjust for keyboard
          ),
          child: Form(
            key: _formKey,
            child: Container(
              padding: EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  DropdownButtonFormField<String>(
                    value: selectedBatch,
                    decoration: InputDecoration(labelText: 'Select Batch'),
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
                    onChanged: (newValue) {
                      setState(() {
                        selectedBatch = newValue;
                      });
                    },
                    validator: (value) =>
                        value == null ? 'Please select a batch' : null,
                  ),
                  TextFormField(
                    controller: _instituteController,
                    decoration: InputDecoration(labelText: 'Institute Name'),
                    validator: (value) =>
                        value!.isEmpty ? 'Please enter institute name' : null,
                  ),
                  TextFormField(
                    controller: _instructorController,
                    decoration: InputDecoration(labelText: 'Instructor Name'),
                    validator: (value) =>
                        value!.isEmpty ? 'Please enter instructor name' : null,
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () => _saveToFirebase(context),
                    child: Text('Submit'),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _saveToFirebase(BuildContext context) async {
    if (!_formKey.currentState!.validate()) return;

    await FirebaseFirestore.instance
        .collection("subjects")
        .doc(widget.subjectName)
        .collection("batches")
        .add({
      'batchName':
          selectedBatch, // Fixed: Using selected batch instead of _batchController
      'instituteName': _instituteController.text,
      'instructorName': _instructorController.text,
      'timestamp': FieldValue.serverTimestamp(),
    });

    await fetchBatches(); // Ensure UI updates properly
    if (mounted) {
      setState(() {});
    }

    _instituteController.clear();
    _instructorController.clear();
    selectedBatch = null;

    Navigator.pop(context); // Close bottom sheet

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Data saved successfully!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Select Batch")),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showBottomSheet(context),
        child: Icon(Icons.add),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : batches.isEmpty
              ? Center(child: Text("No Batches Found"))
              : ListView.builder(
                  itemCount: batches.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: GestureDetector(
                        onTap: () {
                          Get.to(
                            () => MarkAttendance(
                              subjectName: widget.subjectName,
                              batchName: batches[index]['batchName'],
                            ),
                          );
                        },
                        child: Container(
                          height: 60,
                          decoration: BoxDecoration(
                            color: Colors.teal[200],
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: Colors.teal),
                          ),
                          child: Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.edit_document,
                                  color: Colors.black,
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  batches[index]['batchName'],
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}
