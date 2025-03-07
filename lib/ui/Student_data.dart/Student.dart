import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class StudentListScreen extends StatefulWidget {
  @override
  _StudentListScreenState createState() => _StudentListScreenState();
}

class _StudentListScreenState extends State<StudentListScreen> {
  List<Map<String, dynamic>> students = [];

  @override
  void initState() {
    super.initState();
    fetchStudents();
  }

  Future<void> fetchStudents() async {
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('users')
        .where('role', isEqualTo: 'Student')
        .get();

    setState(() {
      students = snapshot.docs
          .map((doc) => {
                'id': doc.id,
                'name': doc['name'],
                'batch': doc['batch'],
                'course': doc['course'],
                'rollNo': doc['rollNo'],
                'email': doc['email'],
                'phone': doc['phone'],
              })
          .toList();
    });
  }

  void showStudentDetails(Map<String, dynamic> student) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
      ),
      builder: (context) {
        return Container(
          padding: EdgeInsets.all(20),
          height: MediaQuery.of(context).size.height * 0.9,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Text(
                  "${student['name']}'s Details",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(height: 20),
              ListTile(
                leading: Icon(Icons.perm_identity, color: Colors.blue),
                title: Text("Name: ${student['name']}"),
              ),
              ListTile(
                leading: Icon(Icons.numbers, color: Colors.green),
                title: Text("Roll No: ${student['rollNo']}"),
              ),
              ListTile(
                leading: Icon(Icons.class_, color: Colors.orange),
                title: Text("Batch: ${student['batch']}"),
              ),
              ListTile(
                leading: Icon(Icons.book, color: Colors.purple),
                title: Text("Course: ${student['course']}"),
              ),
              ListTile(
                leading: Icon(Icons.email, color: Colors.red),
                title: Text("Email: ${student['email']}"),
              ),
              ListTile(
                leading: Icon(Icons.phone, color: Colors.teal),
                title: Text("Phone: ${student['phone']}"),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 30),
                child: Center(
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text(
                      "Close",
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.indigo, // Teal color
                      minimumSize:
                          const Size(200, 50), // Increased width and height
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                            10), // Slightly rounded corners
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Students")),
      body: students.isEmpty
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: students.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: GestureDetector(
                    onTap: () {
                      showStudentDetails(students[index]);
                    },
                    child: Container(
                      height: 80,
                      decoration: BoxDecoration(
                        color: Colors.blue[100],
                        border: Border.all(color: Colors.blue),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text("Name: ${students[index]['name']}",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16)),
                              Text(
                                  "Roll No: ${students[index]['rollNo']} | Batch: ${students[index]['batch']}"),
                            ],
                          ),
                          Text(
                            students[index]['course'],
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
