import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:qabilacademy/ui/Huzaifa/studentScreen/Quiz/add_Questions.dart';
import 'package:qabilacademy/ui/Huzaifa/studentScreen/Quiz/submitted_Quiz.dart';
// import 'package:qabilacademy/ui/Huzaifa/studentScreen/Quiz/submitted_quizzes.dart'; // Import Submitted Quiz Screen

class AdminQuizScreen extends StatefulWidget {
  @override
  _AdminQuizScreenState createState() => _AdminQuizScreenState();
}

class _AdminQuizScreenState extends State<AdminQuizScreen> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController courseController = TextEditingController();
  final TextEditingController durationController = TextEditingController();
  final TextEditingController maxAttemptsController = TextEditingController();
  bool isLoading = false;

  @override
  void dispose() {
    titleController.dispose();
    courseController.dispose();
    durationController.dispose();
    maxAttemptsController.dispose();
    super.dispose();
  }

  void createQuiz({bool navigateToAddQuestions = false}) async {
    if (titleController.text.isEmpty ||
        courseController.text.isEmpty ||
        durationController.text.isEmpty ||
        maxAttemptsController.text.isEmpty) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("All fields are required!")));
      return;
    }

    setState(() => isLoading = true);

    try {
      DocumentReference quizRef =
          await FirebaseFirestore.instance.collection('quizzes').add({
        'title': titleController.text,
        'course': courseController.text,
        'duration': int.parse(durationController.text),
        'maxAttempts': int.parse(maxAttemptsController.text),
        'assignedUsers': [],
        'createdAt': FieldValue.serverTimestamp(),
      });

      String quizID = quizRef.id;
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Quiz Created!")));

      if (navigateToAddQuestions) {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => AddQuestionScreen(quizID: quizID)),
        );
      }
    } catch (e) {
      print("Error creating quiz: $e");
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Failed to create quiz!")));
    } finally {
      setState(() => isLoading = false);
    }
  }

  Widget buildTextField(
      {required String label,
      required TextEditingController controller,
      TextInputType keyboardType = TextInputType.text}) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.teal, width: 2),
        ),
        labelText: label,
        labelStyle: GoogleFonts.poppins(color: Colors.teal),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Admin: Create Quiz",
          style: GoogleFonts.poppins(
            fontSize: 23.sp,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.teal,
        elevation: 5,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Create a New Quiz",
                style: GoogleFonts.poppins(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              SizedBox(height: 20.h),
              buildTextField(label: "Quiz Title", controller: titleController),
              SizedBox(height: 15.h),
              buildTextField(label: "Course", controller: courseController),
              SizedBox(height: 15.h),
              buildTextField(
                  label: "Duration (mins)",
                  controller: durationController,
                  keyboardType: TextInputType.number),
              SizedBox(height: 15.h),
              buildTextField(
                  label: "Max Attempts",
                  controller: maxAttemptsController,
                  keyboardType: TextInputType.number),
              SizedBox(height: 25.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: isLoading ? null : () => createQuiz(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.teal,
                      padding: EdgeInsets.symmetric(
                          horizontal: 25.w, vertical: 12.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: isLoading
                        ? CircularProgressIndicator(color: Colors.white)
                        : Text(
                            "Create Quiz",
                            style: GoogleFonts.poppins(
                              fontSize: 14.sp,
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                  ),
                  ElevatedButton(
                    onPressed: isLoading
                        ? null
                        : () => createQuiz(navigateToAddQuestions: true),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.teal.shade700,
                      padding: EdgeInsets.symmetric(
                          horizontal: 25.w, vertical: 12.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: isLoading
                        ? CircularProgressIndicator(color: Colors.white)
                        : Text(
                            "Add Questions",
                            style: GoogleFonts.poppins(
                              fontSize: 14.sp,
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                  ),
                ],
              ),
              SizedBox(height: 20.h),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => SubmittedQuizzesScreen(
                                studentID: '',
                              )),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    padding:
                        EdgeInsets.symmetric(horizontal: 25.w, vertical: 12.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Text(
                    "View Submitted Quizzes",
                    style: GoogleFonts.poppins(
                      fontSize: 14.sp,
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
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
