import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class AddQuestionScreen extends StatefulWidget {
  final String quizID;
  AddQuestionScreen({required this.quizID});

  @override
  _AddQuestionScreenState createState() => _AddQuestionScreenState();
}

class _AddQuestionScreenState extends State<AddQuestionScreen> {
  final TextEditingController questionController = TextEditingController();
  final List<TextEditingController> optionControllers =
      List.generate(4, (index) => TextEditingController());
  int correctIndex = 0;

  void addQuestion() async {
    if (questionController.text.isEmpty ||
        optionControllers.any((controller) => controller.text.isEmpty)) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("All fields and options are required!")));
      return;
    }

    try {
      await FirebaseFirestore.instance
          .collection('quizzes')
          .doc(widget.quizID)
          .collection('questions')
          .add({
        'question': questionController.text,
        'options':
            optionControllers.map((controller) => controller.text).toList(),
        'correctIndex': correctIndex,
        'createdAt': FieldValue.serverTimestamp(), // Add createdAt field
      });

      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Question Added!")));

      // Clear all fields
      questionController.clear();
      setState(() {
        for (var controller in optionControllers) {
          controller.clear();
        }
        correctIndex = 0;
      });
    } catch (e) {
      print("Error adding question: $e");
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Failed to add question!")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Add Questions",
          style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Add a Question",
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              SizedBox(height: 20.h),
              TextField(
                controller: questionController,
                decoration: InputDecoration(
                  labelText: "Question",
                  labelStyle: TextStyle(color: Colors.teal),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                ),
              ),
              SizedBox(height: 15.h),
              Text(
                "Options",
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              SizedBox(height: 10.h),
              ...List.generate(4, (index) {
                return Padding(
                  padding: EdgeInsets.symmetric(vertical: 5.h),
                  child: ListTile(
                    title: TextField(
                      controller: optionControllers[index],
                      decoration: InputDecoration(
                        labelText: "Option ${index + 1}",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.r),
                        ),
                      ),
                    ),
                    leading: Radio(
                      value: index,
                      groupValue: correctIndex,
                      onChanged: (int? value) {
                        setState(() => correctIndex = value!);
                      },
                    ),
                  ),
                );
              }),
              SizedBox(height: 25.h),
              Center(
                child: ElevatedButton(
                  onPressed: addQuestion,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal,
                    padding:
                        EdgeInsets.symmetric(horizontal: 25.w, vertical: 12.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                  ),
                  child: Text(
                    "Add Question",
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
