import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:qabilacademy/ui/attendence/view_prev_atten.dart';

class PrevAttenScreen extends StatefulWidget {
  final String subjectName;
  final String batchName;

  PrevAttenScreen({required this.subjectName, required this.batchName});

  @override
  _PrevAttenScreenState createState() => _PrevAttenScreenState();
}

class _PrevAttenScreenState extends State<PrevAttenScreen> {
  List<String> dates = [];

  @override
  void initState() {
    super.initState();
    fetchAttendanceDates();
  }

  void fetchAttendanceDates() async {
    var attendanceCollection = await FirebaseFirestore.instance
        .collection('attendance')
        .doc(widget.subjectName)
        .collection(widget.batchName)
        .get();

    setState(() {
      dates = attendanceCollection.docs.map((doc) => doc.id).toList();
    });
  }

  void viewAttendanceForDate(String date) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ViewPrevAtten(
          subjectName: widget.subjectName,
          batchName: widget.batchName,
          date: date,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Previous Attendance")),
      body: dates.isEmpty
          ? Center(child: Text("No previous attendance found"))
          : ListView.builder(
              itemCount: dates.length,
              itemBuilder: (context, index) {
                return ListTile(
                  tileColor: Colors.teal[100],
                  title: Text(dates[index]),
                  trailing: Icon(Icons.arrow_forward),
                  onTap: () => viewAttendanceForDate(dates[index]),
                );
              },
            ),
    );
  }
}
