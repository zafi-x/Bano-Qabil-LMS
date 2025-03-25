import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class QuizStartScreen extends StatefulWidget {
  final String quizID;
  final String studentID;

  const QuizStartScreen({
    Key? key,
    required this.quizID,
    required this.studentID,
  }) : super(key: key);

  @override
  _QuizStartScreenState createState() => _QuizStartScreenState();
}

class _QuizStartScreenState extends State<QuizStartScreen> {
  List<Map<String, dynamic>> questions = [];
  Map<String, dynamic> selectedAnswers = {};
  bool isLoading = true;
  int remainingTime = 900; // 15 minutes in seconds

  @override
  void initState() {
    super.initState();
    fetchQuestions();
    startTimer();
  }

  Future<void> fetchQuestions() async {
    print("🔎 Fetching questions for quiz ID: ${widget.quizID}");
    try {
      QuerySnapshot questionSnapshot = await FirebaseFirestore.instance
          .collection('quizzes')
          .doc(widget.quizID)
          .collection('questions')
          .get();

      print("✅ Found ${questionSnapshot.docs.length} questions");

      if (questionSnapshot.docs.isEmpty) {
        print("⚠️ No questions found for quiz ID: ${widget.quizID}");
        setState(() {
          isLoading = false; // ✅ Stop loading even if no questions found
        });
        return;
      }

      List<Map<String, dynamic>> fetchedQuestions =
          questionSnapshot.docs.map((doc) {
        var data = doc.data() as Map<String, dynamic>;
        return {
          'id': doc.id,
          'questionText': data['question'],
          'options': List<String>.from(data['options']),
          'correctAnswerIndex': data['correctIndex'],
        };
      }).toList();

      setState(() {
        questions = fetchedQuestions;
        isLoading = false; // ✅ Stop loading once questions are fetched
      });
    } catch (e) {
      print("🔥 Error fetching questions: $e");
      setState(() {
        isLoading = false; // ✅ Stop loading even if an error occurs
      });
    }
  }

  void startTimer() {
    Future.delayed(Duration(seconds: 1), () {
      if (mounted && remainingTime > 0) {
        setState(() => remainingTime--);
        startTimer();
      } else if (remainingTime == 0) {
        submitQuiz();
      }
    });
  }

  void submitQuiz() {
    int score = 0;

    for (var question in questions) {
      String questionID = question['id'];
      int correctIndex = question['correctAnswerIndex'];

      if (selectedAnswers[questionID] == question['options'][correctIndex]) {
        score++;
      }
    }

    FirebaseFirestore.instance
        .collection('quiz_attempts')
        .doc('${widget.studentID}_${widget.quizID}')
        .set({
      'quizID': widget.quizID,
      'studentID': widget.studentID,
      'score': score,
      'attemptedAt': Timestamp.now(),
    }, SetOptions(merge: true));

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Attempt Quiz",
          style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.teal,
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: EdgeInsets.all(16.w),
              child: Column(
                children: [
                  Text(
                    "Time Remaining: ${remainingTime ~/ 60}:${remainingTime % 60}",
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.red,
                    ),
                  ),
                  SizedBox(height: 20.h),
                  Expanded(
                    child: ListView.builder(
                      itemCount: questions.length,
                      itemBuilder: (context, index) {
                        final question = questions[index];
                        return Card(
                          margin: EdgeInsets.symmetric(vertical: 10.h),
                          child: Padding(
                            padding: EdgeInsets.all(12.w),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  question['questionText'],
                                  style: TextStyle(
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 10.h),
                                ...List.generate(question['options'].length,
                                    (i) {
                                  String option = question['options'][i];
                                  return RadioListTile<String>(
                                    title: Text(
                                      option,
                                      style: TextStyle(fontSize: 14.sp),
                                    ),
                                    value: option,
                                    groupValue: selectedAnswers[question['id']],
                                    onChanged: (value) {
                                      setState(() {
                                        selectedAnswers[question['id']] = value;
                                      });
                                    },
                                  );
                                }),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  SizedBox(height: 20.h),
                  ElevatedButton(
                    onPressed: submitQuiz,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.teal,
                      padding: EdgeInsets.symmetric(
                          horizontal: 30.w, vertical: 12.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                    ),
                    child: Text(
                      "Submit Quiz",
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  SizedBox(height: 10.h),
                ],
              ),
            ),
    );
  }
}
