import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class QuizScreen extends StatefulWidget {
  final String quizId;
  QuizScreen({required this.quizId});

  @override
  _QuizScreenState createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  int _currentQuestionIndex = 0;
  int _score = 0;
  bool _quizCompleted = false;

  void _answerQuestion(
      int selectedIndex, List<Map<String, dynamic>> questions) {
    if (questions.isNotEmpty &&
        selectedIndex == questions[_currentQuestionIndex]['answer']) {
      setState(() {
        _score++;
      });
    }
    if (_currentQuestionIndex < questions.length - 1) {
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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("📖 Quiz")),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('quizzes')
            .doc(widget.quizId)
            .collection('questions')
            .snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text("⚠️ No Questions Found"));
          }

          List<Map<String, dynamic>> questions = snapshot.data!.docs.map((doc) {
            var data = doc.data() as Map<String, dynamic>;

            // ✅ Ensure options are properly formatted as a List<String>
            if (data.containsKey('options') &&
                data['options'] is List &&
                data['options'].isNotEmpty &&
                data['options'][0] is String) {
              data['options'] = List<String>.from(data['options']);
            }

            return data;
          }).toList();

          return _quizCompleted
              ? _buildResultScreen()
              : _buildQuestionScreen(questions);
        },
      ),
    );
  }

  /// ✅ UI for Quiz Questions
  Widget _buildQuestionScreen(List<Map<String, dynamic>> questions) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          LinearProgressIndicator(
            value: (_currentQuestionIndex + 1) / questions.length,
            backgroundColor: Colors.grey[300],
            color: Colors.teal,
          ),
          SizedBox(height: 20),
          Text(
            "Question ${_currentQuestionIndex + 1} / ${questions.length}",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 20),
          Card(
            elevation: 4,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                questions[_currentQuestionIndex]['question'],
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          SizedBox(height: 20),
          Column(
            children: List.generate(
              questions[_currentQuestionIndex]['options'].length,
              (index) => _buildOptionButton(index, questions),
            ),
          ),
        ],
      ),
    );
  }

  /// ✅ Updated Option Button UI (Correct List Format)
  Widget _buildOptionButton(int index, List<Map<String, dynamic>> questions) {
    return Padding(
      padding:
          const EdgeInsets.symmetric(vertical: 8.0), // Spacing between options
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.white,
          backgroundColor: Colors.teal,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          padding: EdgeInsets.symmetric(vertical: 16), // Bigger button
        ),
        onPressed: () => _answerQuestion(index, questions),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            "${index + 1}. ${questions[_currentQuestionIndex]['options'][index]}",
            style: TextStyle(fontSize: 16),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }

  /// ✅ UI for Quiz Completion
  Widget _buildResultScreen() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.emoji_events, size: 80, color: Colors.teal),
          SizedBox(height: 20),
          Text(
            "Quiz Completed!",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10),
          Text(
            "Your Score: $_score",
            style: TextStyle(fontSize: 22),
          ),
          SizedBox(height: 20),
        ],
      ),
    );
  }
}
