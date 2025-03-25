import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SubmittedQuizzesScreen extends StatelessWidget {
  final String studentID;

  const SubmittedQuizzesScreen({Key? key, required this.studentID})
      : super(key: key);

  void _deleteQuizAttempt(String attemptID, BuildContext context) async {
    bool confirmDelete = await _showDeleteConfirmation(context);
    if (!confirmDelete) return;

    try {
      await FirebaseFirestore.instance
          .collection('quiz_attempts')
          .doc(attemptID)
          .delete();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Quiz attempt deleted successfully!")),
      );
    } catch (e) {
      print("Error deleting quiz attempt: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to delete quiz attempt.")),
      );
    }
  }

  Future<bool> _showDeleteConfirmation(BuildContext context) async {
    return await showDialog<bool>(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("Confirm Deletion"),
              content:
                  Text("Are you sure you want to delete this quiz attempt?"),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context, false),
                  child: Text("Cancel"),
                ),
                TextButton(
                  onPressed: () => Navigator.pop(context, true),
                  child: Text("Delete", style: TextStyle(color: Colors.red)),
                ),
              ],
            );
          },
        ) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Submitted Quizzes",
          style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.teal,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('quiz_attempts')
            .where('studentID', isEqualTo: studentID)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(
              child: Text(
                "No submitted quizzes found.",
                style: TextStyle(fontSize: 16.sp, color: Colors.black54),
              ),
            );
          }

          var attempts = snapshot.data!.docs;

          return ListView.builder(
            itemCount: attempts.length,
            itemBuilder: (context, index) {
              var attemptData = attempts[index].data() as Map<String, dynamic>;
              String attemptID = attempts[index].id;

              return Card(
                margin: EdgeInsets.all(10.w),
                child: Padding(
                  padding: EdgeInsets.all(12.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Quiz ID: ${attemptData['quizID']}",
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 5.h),
                      Text(
                        "Score: ${attemptData['score']}",
                        style: TextStyle(fontSize: 14.sp),
                      ),
                      Text(
                        "Attempted at: ${attemptData['attemptedAt'].toDate()}",
                        style: TextStyle(fontSize: 14.sp, color: Colors.grey),
                      ),
                      SizedBox(height: 10.h),
                      Align(
                        alignment: Alignment.centerRight,
                        child: IconButton(
                          icon: Icon(Icons.delete, color: Colors.red),
                          onPressed: () =>
                              _deleteQuizAttempt(attemptID, context),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
