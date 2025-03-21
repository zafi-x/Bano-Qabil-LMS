import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:qabilacademy/ui/Huzaifa/studentScreen/Quries/quries.dart';
import 'package:qabilacademy/ui/Huzaifa/studentScreen/Tasks/task.dart';
import 'package:qabilacademy/ui/Huzaifa/studentScreen/cources/CourcesScreen.dart';
import 'package:qabilacademy/ui/Huzaifa/custom/DashBoardItem.dart';
import 'package:qabilacademy/ui/Huzaifa/studentScreen/Quiz/quiz_screen.dart';
import 'package:qabilacademy/ui/Huzaifa/studentScreen/TimeTable/timeTable.dart'
    as timeTable1;
import 'package:qabilacademy/ui/Huzaifa/studentScreen/profile/Profile.dart';

import '../../../auth/login_screen.dart';

void logout() async {
  try {
    await FirebaseAuth.instance.signOut();
    // print("User logged out successfully");
  } catch (e) {
    // print("Error logging out: $e");
  }
  Get.to(() => LoginScreen());
}

class StudentDashboard extends StatefulWidget {
  const StudentDashboard({super.key});

  @override
  State<StudentDashboard> createState() => _StudentDashboardState();
}

class _StudentDashboardState extends State<StudentDashboard> {
  User? user = FirebaseAuth.instance.currentUser;
  String userName = "Guest User";
  String userEmail = "No Email";

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  void fetchUserData() async {
    if (user != null) {
      try {
        DocumentSnapshot userDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(user!.uid)
            .get();

        if (userDoc.exists) {
          setState(() {
            userName = (userDoc['name'] ?? "Guest User").toUpperCase();

            userEmail = userDoc['email'] ?? "No Email";
          });
        }
      } catch (e) {
        print("Error fetching user data: $e");
      }
    }
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Qabil Academy ",
            style: GoogleFonts.poppins(
                fontSize: 23.sp, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            UserAccountsDrawerHeader(
              onDetailsPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const ProfileScreen()));
              },
              accountName: Text(userName),
              accountEmail: Text(userEmail),
              currentAccountPicture: const CircleAvatar(
                backgroundImage: AssetImage('assets/image.png'),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text("Dashboard"),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => StudentDashboard()));
              },
            ),
            ListTile(
              leading: const Icon(Icons.quiz),
              title: const Text("Quizes"),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => QuizScreen(
                              quizId: "LNdC0HC7EXVgydpAz4Rv",
                            )));
              },
            ),
            ListTile(
              leading: const Icon(Icons.book),
              title: const Text("Courses"),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const CoursesScreen()));
              },
            ),
            ListTile(
              leading: const Icon(Icons.question_answer),
              title: const Text("Queries"),
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => QueriesScreen()));
              },
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text("Sign Out"),
              onTap: () {
                logout();
              },
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Welcome Banner
            GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const ProfileScreen()));
              },
              child: Flexible(
                child: Container(
                  // height: 120.h,
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.teal,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 45.r,
                        backgroundImage: AssetImage('assets/image.png'),
                      ),
                      const SizedBox(width: 10),
                      Flexible(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("Welcome Back!",
                                style: GoogleFonts.poppins(
                                    color: Colors.white, fontSize: 19.sp)),
                            Text(userName,
                                style: GoogleFonts.poppins(
                                    color: Colors.white,
                                    fontSize: 19.sp,
                                    fontWeight: FontWeight.bold)),
                            Text("Mobile APP Dev | 1234",
                                style: GoogleFonts.poppins(
                                    color: Colors.white, fontSize: 14.sp)),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(height: 20.h),

            // LMS Notification
            Container(
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: Colors.amber.shade600,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  const Icon(Icons.notifications, color: Colors.white),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      "Quiz for Mobile App Development ",
                      style: GoogleFonts.poppins(
                          color: Colors.white, fontSize: 14.sp),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20.sp),

            // Grid Menu
            Expanded(
              child: GridView.count(
                crossAxisCount: 3,
                crossAxisSpacing: 10,
                mainAxisSpacing: 15,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  timeTable1.RamadanTimetableScreen()));
                    },
                    child: const DashBoardItem(
                      title: "Time Table",
                      icon: Icons.calendar_today,
                    ),
                  ),
                  const DashBoardItem(
                    title: "Attendance",
                    icon: Icons.check_circle,
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  QuizScreen(quizId: "LNdC0HC7EXVgydpAz4Rv")));
                    },
                    child: const DashBoardItem(
                      title: "Quizes",
                      icon: Icons.quiz_outlined,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const CoursesScreen()));
                    },
                    child: const DashBoardItem(
                      title: "Courses",
                      icon: Icons.book,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => QueriesScreen()));
                    },
                    child: const DashBoardItem(
                      title: "Queries",
                      icon: Icons.question_answer,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => TaskScreen()));
                    },
                    child: const DashBoardItem(
                      title: "Tasks",
                      icon: Icons.assignment,
                    ),
                  ),
                  const DashBoardItem(
                    title: "Datesheet",
                    icon: Icons.date_range,
                  ),
                  const DashBoardItem(
                    title: "Fee Record",
                    icon: Icons.attach_money,
                  ),
                  GestureDetector(
                    onTap: () {
                      logout();
                    },
                    child: const DashBoardItem(
                      title: "Sign Out",
                      icon: Icons.exit_to_app,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
