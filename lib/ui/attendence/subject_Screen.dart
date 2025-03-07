import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:qabilacademy/ui/attendence/batch_Screen.dart';

class SubjectScreen extends StatefulWidget {
  @override
  _SubjectScreenState createState() => _SubjectScreenState();
}

class _SubjectScreenState extends State<SubjectScreen> {
  List<DocumentSnapshot> subjects = [];

  @override
  void initState() {
    super.initState();
    fetchSubjects();
  }

  void fetchSubjects() async {
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection("subjects").get();
    setState(() {
      subjects = querySnapshot.docs;
    });
  }

  void addSubject() async {
    TextEditingController subNameController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Enter Subject Name"),
          content: TextField(controller: subNameController),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text("Cancel"),
            ),
            TextButton(
              onPressed: () async {
                if (subNameController.text.isNotEmpty) {
                  await FirebaseFirestore.instance
                      .collection("subjects")
                      .add({"name": subNameController.text});
                  fetchSubjects();
                }
                Navigator.pop(context);
              },
              child: Text("Add"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Select Subject")),
      floatingActionButton: FloatingActionButton(
        onPressed: addSubject,
        child: Icon(Icons.add),
      ),
      body: subjects.isEmpty
          ? Center(child: CircularProgressIndicator())
          : GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: 1.5,
              ),
              padding: EdgeInsets.all(10),
              itemCount: subjects.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    Get.to(() =>
                        BatchScreen(subjectName: subjects[index]['name']));
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.indigo,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey,
                          blurRadius: 10,
                          spreadRadius: 2,
                          offset: Offset(0, 0),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          subjects[index]["name"],
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
