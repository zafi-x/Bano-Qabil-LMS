import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qabilacademy/ui/homeScreens/ad_home_screen.dart';
import 'package:qabilacademy/ui/homeScreens/stu_home_screen.dart';
import 'package:qabilacademy/ui/auth/login_screen.dart';

class SplashServices {
  void isLogin(BuildContext context) {
    final auth = FirebaseAuth.instance;
    final user = auth.currentUser;

    if (user != null) {
      _navigateBasedOnRole(user.uid);
    } else {
      Timer(const Duration(seconds: 3), () {
        Get.to(() => const LoginScreen());
      });
    }
  }

  Future<void> _navigateBasedOnRole(String uid) async {
    try {
      DocumentSnapshot userDoc =
          await FirebaseFirestore.instance.collection('users').doc(uid).get();

      if (userDoc.exists) {
        String role = userDoc['role'] ?? 'student';

        Timer(const Duration(seconds: 3), () {
          if (role.toLowerCase() == 'student') {
            Get.to(() => const StuHomeScreen());
          } else {
            Get.to(() => const AdHomeScreen());
          }
        });
      } else {
        Get.snackbar('Error', 'User data not found!',
            backgroundColor: Colors.red, colorText: Colors.white);
        Get.to(() => const LoginScreen());
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to fetch user role!',
          backgroundColor: Colors.red, colorText: Colors.white);
      Get.to(() => const LoginScreen());
    }
  }
}
