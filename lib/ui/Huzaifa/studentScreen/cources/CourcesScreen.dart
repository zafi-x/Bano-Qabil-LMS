import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:qabilacademy/ui/Huzaifa/custom/DashBoardItem.dart';

class CoursesScreen extends StatelessWidget {
  const CoursesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Courses",
          style: TextStyle(
            fontSize: screenWidth * 0.06,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Padding(
        padding: EdgeInsets.all(screenWidth * 0.04),
        child: GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: screenWidth * 0.03,
          mainAxisSpacing: screenWidth * 0.03,
          children: const [
            DashBoardItem(
              title: "Graphic Designing",
              icon: Icons.design_services,
            ),
            DashBoardItem(
              title: "Digital Marketing",
              icon: Icons.mark_email_read,
            ),
            DashBoardItem(
              title: "Web Development",
              icon: Icons.web,
            ),
            DashBoardItem(
              title: "Mobile Development",
              icon: Icons.developer_mode,
            ),
            DashBoardItem(
              title: "UI/UX Designing",
              icon: Icons.design_services,
            ),
            DashBoardItem(
              title: "E-Commerce",
              icon: Icons.shopping_cart,
            ),
            DashBoardItem(
              title: "Video Editing",
              icon: Icons.video_collection,
            ),
            DashBoardItem(
              title: "SEO",
              icon: Icons.search,
            ),
            DashBoardItem(
              title: "Data Science",
              icon: Icons.data_usage,
            ),
          ],
        ),
      ),
    );
  }
}
