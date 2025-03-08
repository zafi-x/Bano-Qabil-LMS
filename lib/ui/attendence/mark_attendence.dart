import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:qabilacademy/ui/attendence/prev_atten_Screen.dart';

class MarkAttendance extends StatefulWidget {
  final String subjectName;
  final String batchName;

  MarkAttendance({required this.subjectName, required this.batchName});

  @override
  _MarkAttendanceState createState() => _MarkAttendanceState();
}

class _MarkAttendanceState extends State<MarkAttendance> {
  List<DocumentSnapshot> students = [];
  Map<String, bool> attendance = {};
  bool isAttendanceSubmitted = false;
  final String todayDate = DateFormat('yyyy-MM-dd').format(DateTime.now());

  @override
  void initState() {
    super.initState();
    checkAttendanceStatus();
  }

  void checkAttendanceStatus() async {
    var attendanceSnapshot = await FirebaseFirestore.instance
        .collection('attendance')
        .doc(widget.subjectName)
        .collection(widget.batchName)
        .doc(todayDate)
        .get();

    if (attendanceSnapshot.exists) {
      setState(() {
        isAttendanceSubmitted = true;
      });
    } else {
      fetchStudents();
    }
  }

  void fetchStudents() async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('users')
        .where('role', isEqualTo: 'Student')
        .where('batch', isEqualTo: widget.batchName)
        .where('course', isEqualTo: widget.subjectName)
        .get();

    List<DocumentSnapshot> sortedStudents = querySnapshot.docs;

    sortedStudents.sort((a, b) {
      int rollA = int.tryParse(a["rollNo"]) ?? 0;
      int rollB = int.tryParse(b["rollNo"]) ?? 0;
      return rollA.compareTo(rollB);
    });

    setState(() {
      students = sortedStudents;
      for (var student in students) {
        attendance[student.id] = false;
      }
    });
  }

  void submitAttendance() async {
    if (isAttendanceSubmitted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Attendance already submitted for today!")),
      );
      return;
    }

    var attendanceRef = FirebaseFirestore.instance
        .collection('attendance')
        .doc(widget.subjectName)
        .collection(widget.batchName)
        .doc(todayDate);

    Map<String, dynamic> attendanceData = {
      'date': todayDate,
      'students': {},
    };

    for (var student in students) {
      String studentId = student.id;
      bool isPresent = attendance[studentId] ?? false;
      attendanceData['students'][studentId] = {
        'name': student["name"],
        'rollNo': student["rollNo"],
        'isPresent': isPresent,
      };
    }

    await attendanceRef.set(attendanceData);

    setState(() {
      isAttendanceSubmitted = true;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Attendance submitted successfully!")),
    );
  }

  void viewPreviousAttendance() {
    Get.to(
      () => PrevAttenScreen(
        subjectName: widget.subjectName,
        batchName: widget.batchName,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Mark Attendance")),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            color: Colors.indigo,
            child: TextButton(
              onPressed: viewPreviousAttendance,
              child: Text("View Previous Attendance",
                  style: TextStyle(color: Colors.white, fontSize: 16)),
            ),
          ),
          Expanded(
            child: isAttendanceSubmitted
                ? Center(child: Text("Attendance already submitted for today!"))
                : students.isEmpty
                    ? Center(child: CircularProgressIndicator())
                    : ListView.builder(
                        itemCount: students.length,
                        itemBuilder: (context, index) {
                          var student = students[index];
                          return Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 5, horizontal: 10),
                            child: CheckboxListTile(
                              tileColor: Colors.indigo[100],
                              title: Text(
                                  "${student["rollNo"]} - ${student["name"]}"),
                              value: attendance[student.id] ?? false,
                              onChanged: (bool? value) {
                                setState(() {
                                  attendance[student.id] = value!;
                                });
                              },
                            ),
                          );
                        },
                      ),
          ),
        ],
      ),
      floatingActionButton: isAttendanceSubmitted
          ? null
          : FloatingActionButton(
              onPressed: submitAttendance,
              child: Icon(Icons.check),
              tooltip: "Submit Attendance",
            ),
    );
  }
}
