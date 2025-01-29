import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qabilacademy/ui/auth/login_screen.dart';
import 'package:qabilacademy/ui/home_screen.dart';

class SplashServices {
  void isLogin(BuildContext context) {
    final auth = FirebaseAuth.instance;
    final user = auth.currentUser;

    if (user != null) {
      Timer(const Duration(seconds: 3), () {
        Get.to(() => const HomeScreen());
      });
    } else {
      Timer(const Duration(seconds: 3), () {
        Get.to(() => const LoginScreen());
      });
    }
  }
}
