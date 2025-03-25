import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:qabilacademy/ui/splash/splash.dart';
import 'firebase_options.dart';
import 'providers/auth_provider.dart';
import 'providers/query_provider.dart'; // Import your provider
// import 'package:qabilacademy/providers/quiz_provider.dart';
import 'package:google_fonts/google_fonts.dart'; // Add this import

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => QueryProvider()),
        // ChangeNotifierProvider(
        //     create: (_) => QuizProvider()), // Added QuizProvider
      ],
      child: ScreenUtilInit(
        designSize: const Size(360, 690), // Base design size
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (_, child) {
          return GetMaterialApp(
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              primarySwatch: Colors.teal,
              textTheme: GoogleFonts.poppinsTextTheme(),
            ),
            home: child,
          );
        },
        child: SplashScreen(),
      ),
    );
  }
}
