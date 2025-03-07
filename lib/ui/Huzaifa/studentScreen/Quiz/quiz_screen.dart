import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:math';

class QuizScreen extends StatefulWidget {
  @override
  _QuizScreenState createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  int _currentQuestionIndex = 0;
  int _score = 0;
  bool _quizCompleted = false;
  List<Map<String, dynamic>> _shuffledQuestions = [];

  final List<Map<String, dynamic>> _questions = [
    {
      'question': 'What is 2 + 2?',
      'options': ['3', '4', '5', '6'],
      'answer': 1
    },
    {
      'question': 'Which planet is known as the Red Planet?',
      'options': ['Earth', 'Mars', 'Jupiter', 'Venus'],
      'answer': 1
    },
    {
      'question': 'What is the capital of France?',
      'options': ['Rome', 'Paris', 'London', 'Berlin'],
      'answer': 1
    },
    {
      'question': 'Who developed Flutter?',
      'options': ['Google', 'Apple', 'Microsoft', 'Amazon'],
      'answer': 0
    },
    {
      'question': 'What programming language is used in Flutter?',
      'options': ['Java', 'Dart', 'Python', 'Swift'],
      'answer': 1
    },
    {
      'question': 'What is the widget tree in Flutter?',
      'options': [
        'A structure of UI elements',
        'A type of database',
        'A Flutter package',
        'An animation framework'
      ],
      'answer': 0
    },
    {
      'question': 'Which widget is used for handling user input?',
      'options': ['Container', 'TextField', 'Column', 'Row'],
      'answer': 1
    },
    {
      'question': 'What is the default programming language of Flutter?',
      'options': ['Kotlin', 'Swift', 'Dart', 'JavaScript'],
      'answer': 2
    },
    {
      'question': 'Which command is used to create a new Flutter project?',
      'options': [
        'flutter new',
        'flutter create',
        'flutter init',
        'flutter start'
      ],
      'answer': 1
    },
    {
      'question': 'What does “hot reload” do in Flutter?',
      'options': [
        'Restarts the app',
        'Updates UI instantly',
        'Compiles code from scratch',
        'Saves a file'
      ],
      'answer': 1
    },
    {
      'question': 'What is a StatelessWidget in Flutter?',
      'options': [
        'A widget that does not change state',
        'A dynamic widget',
        'A database widget',
        'A network widget'
      ],
      'answer': 0
    },
    {
      'question': 'Which function is the entry point of a Flutter app?',
      'options': ['runFlutter()', 'main()', 'initFlutter()', 'startApp()'],
      'answer': 1
    },
    {
      'question': 'What is used for navigation in Flutter?',
      'options': ['Navigator', 'Router', 'Switch', 'Transition'],
      'answer': 0
    },
    {
      'question': 'Which widget is used to create a button in Flutter?',
      'options': ['Text', 'Container', 'ElevatedButton', 'Scaffold'],
      'answer': 2
    },
    {
      'question': 'What is Flutter primarily used for?',
      'options': [
        'Web development',
        'Mobile development',
        'AI development',
        'Game development'
      ],
      'answer': 1
    }
  ];

  void _shuffleQuestions() {
    _shuffledQuestions = List.from(_questions)..shuffle(Random());
  }

  void _answerQuestion(int selectedIndex) {
    if (selectedIndex == _shuffledQuestions[_currentQuestionIndex]['answer']) {
      _score++;
    }
    if (_currentQuestionIndex < _shuffledQuestions.length - 1) {
      setState(() {
        _currentQuestionIndex++;
      });
    } else {
      setState(() {
        _quizCompleted = true;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _shuffleQuestions();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Quiz App',
          style:
              GoogleFonts.poppins(fontSize: 23.sp, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: _quizCompleted
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Quiz Completed!',
                        style: TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 20),
                    Text('Your Score: $_score / ${_shuffledQuestions.length}',
                        style: const TextStyle(fontSize: 20)),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.teal.shade400,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 10),
                      ),
                      onPressed: () {
                        setState(() {
                          _currentQuestionIndex = 0;
                          _score = 0;
                          _quizCompleted = false;
                          _shuffleQuestions();
                        });
                      },
                      child: const Text(
                        'Restart Quiz',
                        style: TextStyle(fontSize: 20, color: Colors.black),
                      ),
                    ),
                  ],
                ),
              )
            : Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: 80.h),
                    Text(
                      'Question ${_currentQuestionIndex + 1} of ${_shuffledQuestions.length}',
                      style: const TextStyle(
                          fontSize: 22, fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      _shuffledQuestions[_currentQuestionIndex]['question'],
                      style: TextStyle(
                          fontSize: 24.sp, fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 20),
                    ...List.generate(
                      4,
                      (index) {
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.teal.shade300,
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              minimumSize: const Size(double.infinity, 50),
                            ),
                            onPressed: () => _answerQuestion(index),
                            child: Text(
                              _shuffledQuestions[_currentQuestionIndex]
                                  ['options'][index],
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 20.sp,
                                  fontWeight: FontWeight.w500),
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
