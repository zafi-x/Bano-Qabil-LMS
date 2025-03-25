import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:qabilacademy/components/main_button.dart';
import 'package:qabilacademy/ui/Huzaifa/studentScreen/Dashboard/StudentDashboard.dart';
import 'package:qabilacademy/ui/auth/register_screen.dart';
import 'package:qabilacademy/ui/homeScreens/ad_home_screen.dart';
import 'package:qabilacademy/providers/auth_provider.dart'
    as qabilAuthProvider; // Import your provider

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

final FirebaseFirestore _firestore = FirebaseFirestore.instance;
TextEditingController loginEmailController = TextEditingController();
TextEditingController loginPasswordController = TextEditingController();

class _LoginScreenState extends State<LoginScreen> {
  bool isloading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.teal, Colors.white, Colors.teal],
              begin: Alignment.bottomRight,
              end: Alignment.topLeft,
            ),
          ),
          child: Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Column(
                  children: [
                    Text(
                      'Welcome Back!',
                      style: GoogleFonts.merriweather(
                        textStyle: TextStyle(
                          fontSize: 24.sp,
                          color: Colors.indigo,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    SizedBox(height: 40.h),
                    _buildTextField(
                      controller: loginEmailController,
                      label: 'Email',
                      icon: Icons.email,
                    ),
                    SizedBox(height: 20.h),
                    _buildTextField(
                      controller: loginPasswordController,
                      label: 'Password',
                      icon: Icons.lock,
                      obscureText: true,
                    ),
                    SizedBox(height: 60.h),
                    MainButton(
                      loading: isloading,
                      title: 'Login',
                      onTap: () async {
                        var loginEmail = loginEmailController.text
                            .trim(); //jo data user na email field ma dala ha wo loginEmail ma store ho rha ha
                        var loginPassword = loginPasswordController.text
                            .trim(); // jo data user na password field ma dala ha wo loginPassword ma store ho rha ha
                        isloading = true;

                        if (loginEmail.isEmpty || loginPassword.isEmpty) {
                          // agar email ya password empty ha toh yeh error show krega
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content:
                                    Text('Email and Password cannot be empty')),
                          );
                          return;
                        }
                        try {
                          // Show the loading indicator
                          setState(() {
                            isloading =
                                true; // yeh loading indicator show krne k liye ha
                          });

                          // Authenticate the user
                          final authProvider =
                              Provider.of<qabilAuthProvider.AuthProvider>(
                                  context,
                                  listen: false);
                          await authProvider.signIn(loginEmail, loginPassword);
                          final User? firebaseUser = authProvider.user;

                          if (firebaseUser == null) {
                            // agar user null ha toh yeh error show krega
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content:
                                      Text('Login failed: User not found')),
                            );
                            setState(() {
                              isloading = false;
                            });
                            return;
                          }

                          DocumentSnapshot userDoc =
                              await _firestore // yeh user ka data firestore ma store krne k liye ha
                                  .collection(
                                      'users') // yeh collection ka name ha jahan user ka data store hoga
                                  .doc(firebaseUser
                                      .uid) // yeh user ka id ha jis user ka data store hoga
                                  .get();

                          if (!userDoc.exists) {
                            // agar user ka data firestore ma nhi mila toh yeh error show krega
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content:
                                      Text('User data not found in database')),
                            );
                            setState(() {
                              isloading = false;
                            });
                            return;
                          }

                          String role = userDoc[
                              'role']; // yeh user ka role ha jo firestore ma store ha
                          if (role == 'Admin') {
                            Get.to(() => const AdHomeScreen());
                          } else if (role == 'Student') {
                            Get.to(() => StudentDashboard());
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Invalid role: $role')),
                            );
                            setState(() {
                              isloading = false;
                            });
                          }
                        } on FirebaseAuthException catch (e) {
                          // agar koi error aye toh yeh catch krega
                          String errorMessage;
                          if (e.code == 'user-not-found') {
                            errorMessage = 'No user found with this email.';
                          } else if (e.code == 'wrong-password') {
                            errorMessage = 'Incorrect password.';
                          } else {
                            errorMessage = 'Login failed. Please try again.';
                          }
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(errorMessage)),
                          );
                          setState(() {
                            isloading = false;
                          });
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                                content:
                                    Text('An unexpected error occurred: $e')),
                          );
                          setState(() {
                            isloading = false;
                          });
                        }
                      },
                    ),
                    SizedBox(height: 20.h),
                    GestureDetector(
                      onTap: () {
                        Get.to(() => const RegisterScreen());
                      },
                      child: RichText(
                        text: TextSpan(
                          text: 'Not Registered? ',
                          style: GoogleFonts.merriweather(
                            textStyle: TextStyle(
                              fontSize: 14.sp,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          children: [
                            TextSpan(
                              text: 'Register',
                              style: GoogleFonts.merriweather(
                                textStyle: TextStyle(
                                  fontSize: 16.sp,
                                  color: Colors.indigo,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    bool obscureText = false,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      decoration: InputDecoration(
        suffixIcon: Icon(icon, color: Colors.indigo),
        labelText: label,
        labelStyle: TextStyle(color: Colors.indigo),
        fillColor: Colors.indigo[50],
        filled: true,
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.indigo),
          borderRadius: BorderRadius.circular(10.r),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey),
          borderRadius: BorderRadius.circular(10.r),
        ),
      ),
    );
  }
}
