import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:qabilacademy/main.dart';

class DashBoardItem extends StatelessWidget {
  final IconData? icon;
  final String? title;
  const DashBoardItem({super.key, this.icon, this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade300,
            blurRadius: 5,
            spreadRadius: 2,
          )
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 30, color: Colors.teal),
          const SizedBox(height: 5),
          Text("$title",
              style: GoogleFonts.poppins(
                  fontSize: 14.sp, fontWeight: FontWeight.w500)),
        ],
      ),
    );
    ;
  }
}
