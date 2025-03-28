import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

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
        const SnackBar(content: Text("Quiz attempt deleted successfully!")),
      );
    } catch (e) {
      print("Error deleting quiz attempt: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Failed to delete quiz attempt.")),
      );
    }
  }

  void _deleteQuiz(String quizID, BuildContext context) async {
    bool confirmDelete = await _showDeleteConfirmation(context);
    if (!confirmDelete) return;

    try {
      // Delete all attempts related to the quiz
      var attemptsSnapshot = await FirebaseFirestore.instance
          .collection('quiz_attempts')
          .where('quizID', isEqualTo: quizID)
          .get();

      for (var doc in attemptsSnapshot.docs) {
        await doc.reference.delete();
      }

      // Delete the quiz itself
      await FirebaseFirestore.instance
          .collection('quizzes')
          .doc(quizID)
          .delete();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Quiz deleted successfully!")),
      );
    } catch (e) {
      print("Error deleting quiz: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Failed to delete quiz.")),
      );
    }
  }

  Future<bool> _showDeleteConfirmation(BuildContext context) async {
    return await showDialog<bool>(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text("Confirm Deletion"),
              content: const Text(
                  "Are you sure you want to delete this quiz attempt?"),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context, false),
                  child: const Text("Cancel"),
                ),
                TextButton(
                  onPressed: () => Navigator.pop(context, true),
                  child:
                      const Text("Delete", style: TextStyle(color: Colors.red)),
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
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_forever, color: Colors.white),
            onPressed: () async {
              String quizID = await _getQuizIDFromAdmin(context);
              if (quizID.isNotEmpty) {
                _deleteQuiz(quizID, context);
              }
            },
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('quiz_attempts')
            .where('studentID', isEqualTo: studentID)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
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
                      FutureBuilder<DocumentSnapshot>(
                        future: FirebaseFirestore.instance
                            .collection('quizzes')
                            .doc(attemptData['quizID'])
                            .get(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Text(
                              "Loading quiz title...",
                              style: TextStyle(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.bold,
                              ),
                            );
                          }
                          if (!snapshot.hasData || !snapshot.data!.exists) {
                            return Text(
                              "Quiz title not found",
                              style: TextStyle(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.bold,
                                color: Colors.red,
                              ),
                            );
                          }

                          var quizData =
                              snapshot.data!.data() as Map<String, dynamic>;
                          return Text(
                            "Quiz Title: ${quizData['title']}",
                            style: TextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          );
                        },
                      ),
                      SizedBox(height: 5.h),
                      Text(
                        "Score: ${attemptData['score']}",
                        style: TextStyle(fontSize: 14.sp),
                      ),
                      Text(
                        "Attempted at: ${DateFormat('yyyy-MM-dd – kk:mm').format(attemptData['attemptedAt'].toDate())}",
                        style: TextStyle(fontSize: 14.sp, color: Colors.grey),
                      ),
                      SizedBox(height: 10.h),
                      Align(
                        alignment: Alignment.centerRight,
                        child: IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
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

  Future<String> _getQuizIDFromAdmin(BuildContext context) async {
    TextEditingController controller = TextEditingController();
    String quizID = '';

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Enter Quiz Title"),
          content: TextField(
            controller: controller,
            decoration: const InputDecoration(hintText: "Quiz Title"),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () async {
                String quizTitle = controller.text.trim();
                if (quizTitle.isNotEmpty) {
                  var quizSnapshot = await FirebaseFirestore.instance
                      .collection('quizzes')
                      .where('title', isEqualTo: quizTitle)
                      .get();

                  if (quizSnapshot.docs.isNotEmpty) {
                    quizID = quizSnapshot.docs.first.id;

                    // Delete the quiz from the user's side
                    var userAttemptsSnapshot = await FirebaseFirestore.instance
                        .collection('quiz_attempts')
                        .where('quizID', isEqualTo: quizID)
                        .where('studentID', isEqualTo: studentID)
                        .get();

                    for (var doc in userAttemptsSnapshot.docs) {
                      await doc.reference.delete();
                    }

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text("Quiz deleted from your side.")),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Quiz not found.")),
                    );
                  }
                }
                Navigator.pop(context);
              },
              child: const Text("Submit"),
            ),
          ],
        );
      },
    );

    return quizID;
  }
}
