import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:qabilacademy/components/main_button.dart';
import 'package:get/get.dart';
import 'package:qabilacademy/ui/auth/login_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  String userRole = 'user';
  final _formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool isLoading = false;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void dispose() {
    super.dispose();
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
  }

  void registerUser() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        isLoading = true;
      });
      try {
        // Create user with email and password
        UserCredential userCredential =
            await _auth.createUserWithEmailAndPassword(
          email: emailController.text.trim(),
          password: passwordController.text.trim(),
        );

        await _firestore.collection('users').doc(userCredential.user!.uid).set({
          'uid': userCredential.user!.uid,
          'name': nameController.text.trim(),
          'email': emailController.text.trim(),
          'role': userRole,
          'createdAt': DateTime.now(),
        });

        // Show success message and navigate to Login screen
        Get.snackbar('Success', 'Account created successfully!',
            backgroundColor: Colors.green, colorText: Colors.white);
        isloading = false;
        Get.to(() => const LoginScreen());
      } on FirebaseAuthException catch (e) {
        // Handle Firebase authentication errors
        String errorMessage = '';
        switch (e.code) {
          case 'email-already-in-use':
            errorMessage = 'The email is already registered.';
            break;
          case 'weak-password':
            errorMessage = 'The password is too weak.';
            break;
          case 'invalid-email':
            errorMessage = 'The email address is not valid.';
            break;
          default:
            errorMessage = 'An unknown error occurred. Please try again.';
        }
        Get.snackbar('Error', errorMessage,
            backgroundColor: Colors.red, colorText: Colors.white);
      } catch (e) {
        // Handle general errors
        Get.snackbar('Error', 'Something went wrong. Please try again.',
            backgroundColor: Colors.red, colorText: Colors.white);
      } finally {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

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
                Text('Register To Continue',
                    style: GoogleFonts.merriweather(
                        textStyle: const TextStyle(
                            fontSize: 24,
                            color: Colors.indigo,
                            fontWeight: FontWeight.bold))),
                const SizedBox(
                  height: 40,
                ),
                Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 20),
                          child: DropdownButtonFormField<String>(
                            iconEnabledColor: Colors.indigo,
                            decoration: InputDecoration(
                              fillColor: Colors.indigo[50],
                              filled: true,
                              hintText: 'Join as',
                              hintStyle: const TextStyle(color: Colors.indigo),
                              focusedBorder: OutlineInputBorder(
                                borderSide:
                                    const BorderSide(color: Colors.indigo),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide:
                                    const BorderSide(color: Colors.grey),
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            items: ['Admin', 'Student'].map((String user) {
                              return DropdownMenuItem<String>(
                                value: user,
                                child: Text(user),
                              );
                            }).toList(),
                            onChanged: (String? newValue) {
                              setState(() {
                                userRole = newValue!;
                              });
                            },
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Select Role!';
                              }
                              return null;
                            },
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 20),
                          child: TextFormField(
                            keyboardType: TextInputType.name,
                            controller: nameController,
                            decoration: InputDecoration(
                              suffixIcon: const Icon(
                                Icons.person,
                                color: Colors.indigo,
                              ),
                              label: const Text('Name'),
                              labelStyle: const TextStyle(color: Colors.indigo),
                              fillColor: Colors.indigo[50],
                              filled: true,
                              focusedBorder: OutlineInputBorder(
                                borderSide:
                                    const BorderSide(color: Colors.indigo),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide:
                                    const BorderSide(color: Colors.grey),
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Enter Name!';
                              }
                              return null;
                            },
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 20),
                          child: TextFormField(
                            keyboardType: TextInputType.emailAddress,
                            controller: emailController,
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
                                borderSide:
                                    const BorderSide(color: Colors.indigo),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide:
                                    const BorderSide(color: Colors.grey),
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Enter Email!'; // Ensures null and empty string are checked
                              }
                              return null;
                            },
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 20),
                          child: TextFormField(
                            controller: passwordController,
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
                                borderSide:
                                    const BorderSide(color: Colors.indigo),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide:
                                    const BorderSide(color: Colors.grey),
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Enter Password!'; // Ensures null and empty string are checked
                              }
                              return null;
                            },
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        )
                      ],
                    )),
                MainButton(
                    title: 'Register',
                    loading: isLoading,
                    onTap: () {
                      registerUser();
                    }),
                const SizedBox(
                  height: 10,
                ),
                GestureDetector(
                  onTap: () {
                    Get.back();
                  },
                  child: RichText(
                    text: TextSpan(
                      text: 'Already have an account? ',
                      style: GoogleFonts.merriweather(
                        textStyle: const TextStyle(
                          fontSize: 14,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      children: [
                        TextSpan(
                          text: 'Login',
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
