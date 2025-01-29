// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:get/get.dart';
// import 'package:qabilacademy/ui/auth/login_screen.dart';

// registerService(String userName, String userEmail,String userPassword, String userRole,) async {
//   User? userId = FirebaseAuth.instance.currentUser;

//   try {
//     await FirebaseFirestore.instance.collection('users')
//         .doc(userId!.uid).set({
//       'userName': userName,
//       'userEmail': userEmail,
//       'userPassword': userPassword,
//       'createdAt': DateTime.now(),
//       'userId': userId.uid,
//       'userRole': userRole
//     }).then((value) =>
//         {FirebaseAuth.instance.signOut(), Get.to((() => LoginScreen()))});

//   } on FirebaseAuthException catch (e) {
//     print('error $e');
//   }
// }
