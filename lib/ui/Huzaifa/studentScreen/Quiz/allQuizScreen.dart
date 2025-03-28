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
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Available Quizzes",
          style: TextStyle(fontSize: screenWidth * 0.05),
        ),
      ),
      body: isLoading
          ? Center(
              child: SizedBox(
                width: screenWidth * 0.1,
                height: screenWidth * 0.1,
                child: CircularProgressIndicator(),
              ),
            )
          : quizzes.isEmpty
              ? Center(
                  child: Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
                    child: Text(
                      "No quizzes available",
                      style: TextStyle(fontSize: screenWidth * 0.045),
                      textAlign: TextAlign.center,
                    ),
                  ),
                )
              : ListView.builder(
                  padding: EdgeInsets.symmetric(
                      vertical: screenHeight * 0.02,
                      horizontal: screenWidth * 0.04),
                  itemCount: quizzes.length,
                  itemBuilder: (context, index) {
                    final quiz = quizzes[index];

                    return FutureBuilder<int>(
                      future: getAttemptsLeft(quiz['id']),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: screenHeight * 0.01),
                            child: ListTile(
                              title: Text(
                                quiz['title'] ?? 'Untitled Quiz',
                                style: TextStyle(fontSize: screenWidth * 0.045),
                              ),
                              subtitle: Text(
                                "Loading attempts...",
                                style: TextStyle(fontSize: screenWidth * 0.04),
                              ),
                            ),
                          );
                        }

                        int attemptsLeft = snapshot.data!;
                        bool canAttempt = attemptsLeft > 0;

                        return Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: screenHeight * 0.01),
                          child: ListTile(
                            title: Text(
                              quiz['title'] ?? 'Untitled Quiz',
                              style: TextStyle(fontSize: screenWidth * 0.045),
                            ),
                            subtitle: Text(
                              "Attempts Left: $attemptsLeft",
                              style: TextStyle(fontSize: screenWidth * 0.04),
                            ),
                            trailing: Icon(
                              canAttempt ? Icons.play_arrow : Icons.lock,
                              color: canAttempt ? Colors.green : Colors.red,
                              size: screenWidth * 0.06,
                            ),
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
                          ),
                        );
                      },
                    );
                  },
                ),
    );
  }
}
