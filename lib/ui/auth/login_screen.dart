import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:qabilacademy/components/main_button.dart';
import 'package:qabilacademy/ui/auth/register_screen.dart';
import 'package:qabilacademy/ui/home_screen.dart';
import 'package:qabilacademy/ui/student_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

final FirebaseAuth _auth = FirebaseAuth.instance;
final FirebaseFirestore _firestore = FirebaseFirestore.instance;
bool isloading = false;
TextEditingController loginEmailController = TextEditingController();
TextEditingController loginPasswordController = TextEditingController();

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.teal,
              Colors.white,
              Colors.teal,
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Text('Welcome Back!',
                    style: GoogleFonts.merriweather(
                        textStyle: const TextStyle(
                            fontSize: 24,
                            color: Colors.indigo,
                            fontWeight: FontWeight.bold))),
                const SizedBox(
                  height: 40,
                ),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  child: TextFormField(
                    controller: loginEmailController,
                    decoration: InputDecoration(
                      suffixIcon: const Icon(
                        Icons.email,
                        color: Colors.indigo,
                      ),
                      label: const Text('Email'),
                      labelStyle: const TextStyle(color: Colors.indigo),
                      fillColor: Colors.indigo[50],
                      filled: true,
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.indigo),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.grey),
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  child: TextFormField(
                    controller: loginPasswordController,
                    decoration: InputDecoration(
                      suffixIcon: const Icon(
                        Icons.remove_red_eye,
                        color: Colors.indigo,
                      ),
                      label: const Text('Password'),
                      labelStyle: const TextStyle(color: Colors.indigo),
                      fillColor: Colors.indigo[50],
                      filled: true,
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.indigo),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.grey),
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 60,
                ),
                MainButton(
                  loading: isloading,
                  title: 'Login',
                  onTap: () async {
                    var loginEmail = loginEmailController.text.trim();
                    var loginPassword = loginPasswordController.text.trim();
                    isloading = true;

                    if (loginEmail.isEmpty || loginPassword.isEmpty) {
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
                        isloading = true;
                      });

                      // Authenticate the user
                      final UserCredential userCredential =
                          await _auth.signInWithEmailAndPassword(
                        email: loginEmail,
                        password: loginPassword,
                      );
                      final User? firebaseUser = userCredential.user;

                      if (firebaseUser == null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text('Login failed: User not found')),
                        );
                        setState(() {
                          isloading = false;
                        });
                        return;
                      }

                      DocumentSnapshot userDoc = await _firestore
                          .collection('users')
                          .doc(firebaseUser.uid)
                          .get();

                      if (!userDoc.exists) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text('User data not found in database')),
                        );
                        setState(() {
                          isloading = false;
                        });
                        return;
                      }

                      String userRole = userDoc['userRole'];
                      if (userRole == 'Admin') {
                        Get.to(() => const HomeScreen());
                      } else if (userRole == 'User') {
                        Get.to(() => const StudentScreen());
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Invalid role: $userRole')),
                        );
                        setState(() {
                          isloading = false;
                        });
                      }
                    } on FirebaseAuthException catch (e) {
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
                            content: Text('An unexpected error occurred: $e')),
                      );
                      setState(() {
                        isloading = false;
                      });
                    }
                  },
                ),
                const SizedBox(
                  height: 20,
                ),
                GestureDetector(
                  onTap: () {
                    Get.to(() => const RegisterScreen());
                  },
                  child: RichText(
                    text: TextSpan(
                      text: 'Not Registered? ',
                      style: GoogleFonts.merriweather(
                        textStyle: const TextStyle(
                          fontSize: 14,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      children: [
                        TextSpan(
                          text: 'Register',
                          style: GoogleFonts.merriweather(
                            textStyle: const TextStyle(
                              fontSize: 16,
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
    ));
  }
}
