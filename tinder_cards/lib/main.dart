import 'package:flutter/material.dart';
import 'package:tinder_cards/tinder_home_page.dart';

void main() {
  runApp(const TinderCardsApp());
}

class TinderCardsApp extends StatelessWidget {
  const TinderCardsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tinder Card Swipe App',
      debugShowCheckedModeBanner: false,                   // Removing the Debug belt on top right
      theme: ThemeData(
        brightness: Brightness.light,                      // App theme set to light mode
        primarySwatch: Colors.red,                       // Setting the Red color for the theme
      ),
      home: const TinderHomePage(),                        // First screen of the app
    );
  }
}




