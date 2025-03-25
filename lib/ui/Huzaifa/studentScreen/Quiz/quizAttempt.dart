import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:qabilacademy/ui/Huzaifa/studentScreen/Quiz/quiz_startScreen.dart';

class QuizAttemptScreen extends StatefulWidget {
  final String studentID;

  const QuizAttemptScreen({Key? key, required this.studentID})
      : super(key: key);

  @override
  _QuizAttemptScreenState createState() => _QuizAttemptScreenState();
}

class _QuizAttemptScreenState extends State<QuizAttemptScreen> {
  List<Map<String, dynamic>> quizzes = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchQuizzes();
  }

  Future<void> fetchQuizzes() async {
    try {
      QuerySnapshot quizSnapshot =
          await FirebaseFirestore.instance.collection('quizzes').get();

      setState(() {
        quizzes = quizSnapshot.docs.map((doc) {
          return {'id': doc.id, ...doc.data() as Map<String, dynamic>};
        }).toList();
        isLoading = false;
      });
    } catch (e) {
      print("Error fetching quizzes: $e");
      setState(() => isLoading = false);
    }
  }

  Future<int> getAttemptsLeft(String quizID) async {
    try {
      DocumentSnapshot attemptDoc = await FirebaseFirestore.instance
          .collection('quiz_attempts')
          .doc('${widget.studentID}_$quizID')
          .get();

      int maxAttempts =
          quizzes.firstWhere((q) => q['id'] == quizID)['maxAttempts'] ?? 3;
      int attemptsUsed = attemptDoc.exists ? (attemptDoc['attempts'] ?? 0) : 0;

      return maxAttempts - attemptsUsed;
    } catch (e) {
      print("Error fetching attempts: $e");
      return 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Available Quizzes")),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : quizzes.isEmpty
              ? Center(child: Text("No quizzes available"))
              : ListView.builder(
                  itemCount: quizzes.length,
                  itemBuilder: (context, index) {
                    final quiz = quizzes[index];

                    return FutureBuilder<int>(
                      future: getAttemptsLeft(quiz['id']),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return ListTile(
                            title: Text(quiz['title'] ?? 'Untitled Quiz'),
                            subtitle: Text("Loading attempts..."),
                          );
                        }

                        int attemptsLeft = snapshot.data!;
                        bool canAttempt = attemptsLeft > 0;

                        return ListTile(
                          title: Text(quiz['title'] ?? 'Untitled Quiz'),
                          subtitle: Text("Attempts Left: ${attemptsLeft}"),
                          trailing: canAttempt
                              ? Icon(Icons.play_arrow, color: Colors.green)
                              : Icon(Icons.lock, color: Colors.red),
                          onTap: canAttempt
                              ? () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => QuizStartScreen(
                                        quizID: quiz['id'],
                                        studentID: widget.studentID,
                                      ),
                                    ),
                                  );
                                }
                              : null,
                        );
                      },
                    );
                  },
                ),
    );
  }
}
