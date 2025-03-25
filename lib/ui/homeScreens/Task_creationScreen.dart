import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:qabilacademy/ui/homeScreens/task_review.dart';
// import 'admin_task_submission_screen.dart'; // Import the new screen

class AdminTaskScreen extends StatefulWidget {
  @override
  _AdminTaskScreenState createState() => _AdminTaskScreenState();
}

class _AdminTaskScreenState extends State<AdminTaskScreen> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  DateTime? dueDate;

  void createTask() async {
    if (titleController.text.isEmpty ||
        descriptionController.text.isEmpty ||
        dueDate == null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('All fields are required')));
      return;
    }
    await FirebaseFirestore.instance.collection('tasks').add({
      'title': titleController.text,
      'description': descriptionController.text, // ✅ Corrected
      'dueDate': dueDate!.toIso8601String(),
      'status': 'in-progress',
    });

    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text('Task Added Successfully')));
    titleController.clear();
    descriptionController.clear();
    setState(() => dueDate = null);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Create Task',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Task Details',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.teal,
                ),
              ),
              SizedBox(height: 20),
              TextField(
                controller: titleController,
                decoration: InputDecoration(
                  labelText: 'Task Title',
                  labelStyle: TextStyle(color: Colors.teal),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.teal, width: 2),
                  ),
                ),
              ),
              SizedBox(height: 20),
              TextField(
                controller: descriptionController,
                maxLines: 4,
                decoration: InputDecoration(
                  labelText: 'Task Description',
                  labelStyle: TextStyle(color: Colors.teal),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.teal, width: 2),
                  ),
                ),
              ),
              SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      dueDate == null
                          ? 'No Due Date Selected'
                          : 'Due Date: ${DateFormat.yMMMd().format(dueDate!)}',
                      style: TextStyle(fontSize: 16, color: Colors.black54),
                    ),
                  ),
                  ElevatedButton.icon(
                    onPressed: () async {
                      DateTime? picked = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime.now(),
                        lastDate: DateTime(2100),
                      );
                      if (picked != null) setState(() => dueDate = picked);
                    },
                    icon: Icon(Icons.calendar_today),
                    label: Text('Pick Date',
                        style: TextStyle(fontSize: 16, color: Colors.white)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.teal,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 30),
              Center(
                child: ElevatedButton(
                  onPressed: createTask,
                  child: Text(
                    'Add Task',
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal,
                    padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),
              Divider(thickness: 1, color: Colors.grey[300]),
              SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => AdminTaskSubmissionScreen()),
                    );
                  },
                  child: Text(
                    'View Submissions',
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal.shade700,
                    padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
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
