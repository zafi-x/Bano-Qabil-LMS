import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AdminQuizScreen extends StatefulWidget {
  @override
  _AdminQuizScreenState createState() => _AdminQuizScreenState();
}

class _AdminQuizScreenState extends State<AdminQuizScreen> {
  final TextEditingController _quizTitleController = TextEditingController();
  List<Map<String, dynamic>> _questions = [];

  void _addQuestion() {
    setState(() {
      _questions.add({
        'question': '',
        'options': ['', '', '', ''],
        'answerIndex': 0
      });
    });
  }

  void _submitQuiz() async {
    if (_quizTitleController.text.isEmpty || _questions.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content:
              const Text("Please add a title and at least one question!")));
      return;
    }

    // Save quiz to Firebase
    await FirebaseFirestore.instance.collection('quizzes').add({
      'title': _quizTitleController.text,
      'questions': _questions,
      'timestamp': FieldValue.serverTimestamp(),
    });

    ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Quiz Added Successfully!")));

    // Reset fields
    _quizTitleController.clear();
    setState(() {
      _questions.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Admin - Add Quiz")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _quizTitleController,
              decoration: const InputDecoration(labelText: "Quiz Title"),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: _addQuestion,
              child: const Text("Add Question"),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: _questions.length,
                itemBuilder: (context, index) {
                  return QuestionInputCard(
                    questionData: _questions[index],
                    onUpdate: (updatedData) {
                      setState(() {
                        _questions[index] = updatedData;
                      });
                    },
                  );
                },
              ),
            ),
            ElevatedButton(
              onPressed: _submitQuiz,
              child: const Text("Submit Quiz"),
            ),
          ],
        ),
      ),
    );
  }
}

// Widget for Question Input
class QuestionInputCard extends StatefulWidget {
  final Map<String, dynamic> questionData;
  final Function(Map<String, dynamic>) onUpdate;

  QuestionInputCard({required this.questionData, required this.onUpdate});

  @override
  _QuestionInputCardState createState() => _QuestionInputCardState();
}

class _QuestionInputCardState extends State<QuestionInputCard> {
  late TextEditingController _questionController;
  late List<TextEditingController> _optionControllers;
  int _selectedAnswer = 0;

  @override
  void initState() {
    super.initState();
    _questionController =
        TextEditingController(text: widget.questionData['question']);
    _optionControllers = List.generate(
        4,
        (index) =>
            TextEditingController(text: widget.questionData['options'][index]));
    _selectedAnswer = widget.questionData['answerIndex'];
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(10),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            TextField(
              controller: _questionController,
              decoration: const InputDecoration(labelText: "Question"),
              onChanged: (val) {
                widget.onUpdate({
                  'question': val,
                  'options': widget.questionData['options'],
                  'answerIndex': _selectedAnswer
                });
              },
            ),
            Column(
              children: List.generate(4, (index) {
                return RadioListTile<int>(
                  title: TextField(
                    controller: _optionControllers[index],
                    decoration:
                        InputDecoration(labelText: "Option ${index + 1}"),
                    onChanged: (val) {
                      widget.questionData['options'][index] = val;
                      widget.onUpdate({
                        'question': _questionController.text,
                        'options': widget.questionData['options'],
                        'answerIndex': _selectedAnswer
                      });
                    },
                  ),
                  value: index,
                  groupValue: _selectedAnswer,
                  onChanged: (value) {
                    setState(() {
                      _selectedAnswer = value!;
                      widget.onUpdate({
                        'question': _questionController.text,
                        'options': widget.questionData['options'],
                        'answerIndex': _selectedAnswer
                      });
                    });
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
