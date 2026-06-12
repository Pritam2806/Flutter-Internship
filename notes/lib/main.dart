import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'screens/home_screen.dart';

Future<void> main() async {                                // Using "Future" because Firebase is aysnchronous
  WidgetsFlutterBinding.ensureInitialized();               // Initializes Flutter engine before any asynchronous operations.
  // Since Firebase needs Flutter services to be ready, we manually initialize them first using binding. Firebase runs before app runs.
  await Firebase.initializeApp();                          // Connect app with firebase (Firebase functionalities becomes active)
  if (FirebaseAuth.instance.currentUser == null) {         // checks for the user 
    await FirebaseAuth.instance.signInAnonymously();       // If no user, then anonymous user login occurs
  }
  runApp(const MyApp());                                   // Launches the app. Hence binding is done early.
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Notes',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: Colors.black,
        colorScheme: ColorScheme.dark(primary: Colors.teal),         // Primary color of the application
      ),
      home: const HomeScreen(),
    );
  }
}