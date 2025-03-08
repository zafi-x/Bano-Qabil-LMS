import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ViewPrevAtten extends StatelessWidget {
  final String subjectName;
  final String batchName;
  final String date;

  ViewPrevAtten(
      {required this.subjectName, required this.batchName, required this.date});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Attendance on $date")),
      body: Column(
        children: [
          Container(
            color: Colors.amber[100],
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Text(
                      ' Roll N0',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.indigo,
                          fontSize: 16),
                    ),
                    SizedBox(width: 20),
                    Text(
                      'Name',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.indigo,
                          fontSize: 16),
                    ),
                  ],
                ),
                Text(
                  'Present ',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.indigo,
                      fontSize: 16),
                )
              ],
            ),
          ),
          Expanded(
            child: FutureBuilder<DocumentSnapshot>(
              future: FirebaseFirestore.instance
                  .collection('attendance')
                  .doc(subjectName)
                  .collection(batchName)
                  .doc(date)
                  .get(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(child: CircularProgressIndicator());
                }
                var data = snapshot.data?.data() as Map<String, dynamic>?;
                if (data == null || data['students'] == null) {
                  return Center(
                      child: Text("No attendance found for this date"));
                }
                var students = data['students'] as Map<String, dynamic>;
                return ListView(
                  children: students.entries.map((entry) {
                    var student = entry.value;
                    return ListTile(
                      title: Text("${student['rollNo']} - ${student['name']}"),
                      trailing: Icon(
                        student['isPresent']
                            ? Icons.check_circle
                            : Icons.cancel,
                        color: student['isPresent'] ? Colors.green : Colors.red,
                      ),
                    );
                  }).toList(),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
