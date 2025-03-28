import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.teal.shade300,
      body: Padding(
        padding: EdgeInsets.all(screenWidth * 0.07),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: screenHeight * 0.05),
            Center(
              child: Text(
                'Profile',
                style: TextStyle(
                  fontSize: screenWidth * 0.07,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(height: screenHeight * 0.04),
            CircleAvatar(
              radius: screenWidth * 0.2,
              backgroundImage: const AssetImage('assets/image.png'),
            ),
            SizedBox(height: screenHeight * 0.03),
            _buildProfileRow("Name", "Muhammad Huzaifa", screenWidth),
            _buildProfileRow("Email", "huzaifa123@gmail.com", screenWidth),
            _buildProfileRow("ID", "1234", screenWidth),
            _buildProfileRow("Mobile", "0333-1234567", screenWidth),
            _buildProfileRow("Course", "Mobile App Development", screenWidth),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileRow(String label, String value, double screenWidth) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: screenWidth * 0.02),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            '$label : ',
            style: TextStyle(
              fontSize: screenWidth * 0.06,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: screenWidth * 0.05,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
