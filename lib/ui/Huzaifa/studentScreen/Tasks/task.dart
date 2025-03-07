import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:qabilacademy/main.dart';

class TaskScreen extends StatefulWidget {
  @override
  _TaskScreenState createState() => _TaskScreenState();
}

class _TaskScreenState extends State<TaskScreen> {
  final TextEditingController _taskTitleController = TextEditingController();
  final TextEditingController _taskDescriptionController =
      TextEditingController();
  List<Map<String, String>> tasks = [];

  void _submitTask() {
    if (_taskTitleController.text.isNotEmpty &&
        _taskDescriptionController.text.isNotEmpty) {
      setState(() {
        tasks.insert(0, {
          'title': _taskTitleController.text,
          'description': _taskDescriptionController.text,
          'status': 'Pending'
        });
      });
      _taskTitleController.clear();
      _taskDescriptionController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Submit Tasks',
          style:
              GoogleFonts.poppins(fontSize: 23.sp, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            TextField(
              controller: _taskTitleController,
              decoration: InputDecoration(
                labelText: 'Task Title',
                labelStyle: TextStyle(color: Colors.teal),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: const BorderSide(color: Colors.teal),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: const BorderSide(color: Colors.teal),
                ),
              ),
            ),
            SizedBox(height: 8),
            TextField(
              controller: _taskDescriptionController,
              maxLines: 3,
              decoration: InputDecoration(
                labelText: 'Task Description',
                labelStyle: TextStyle(color: Colors.teal),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: const BorderSide(color: Colors.teal),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: const BorderSide(color: Colors.teal),
                ),
              ),
            ),
            SizedBox(height: 8),
            ElevatedButton(
              style: ButtonStyle(
                backgroundColor:
                    MaterialStateProperty.all(Colors.teal.shade400),
              ),
              onPressed: _submitTask,
              child: Text('Submit Task',
                  style: TextStyle(color: Colors.black, fontSize: 16.sp)),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: tasks.length,
                itemBuilder: (context, index) {
                  return Card(
                    margin: EdgeInsets.all(8.0),
                    child: ListTile(
                      title: Text(tasks[index]['title']!),
                      subtitle: Text(tasks[index]['description']!),
                      trailing: Text(tasks[index]['status']!),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
