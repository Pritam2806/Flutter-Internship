import 'package:flutter/material.dart';
import 'package:tinder_cards/profile.dart';

class MatchScreen extends StatelessWidget {
  const MatchScreen({super.key, required this.profile});

  final Profile profile;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.pink.shade50,
      appBar: AppBar(
        title: const Text("It's a Match!"),
        centerTitle: true,
        backgroundColor: Colors.pink,
      ),
      body: SafeArea(                                      // Leaves space for notification pane and 3 buttons at bottom
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "It's a Match!",
                  style: TextStyle(
                    fontSize: 38,
                    fontWeight: FontWeight.bold,
                    color: Colors.pink,
                  ),
                ),
                const SizedBox(height: 24),
                Hero(                                      // Hero is an animation
                  tag: profile.name,                       // Flutter looks for another Hero widget with the same tag on the previous screen.
                  child: CircleAvatar(                     // Circular profile images
                    radius: 64,
                    backgroundColor: Colors.white,
                    child: Icon(profile.avatarIcon, size: 56, color: Colors.pink),
                  ),
                ),
                const SizedBox(height: 22),
                Text(
                  profile.name,
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '${profile.age} years old',
                  style: const TextStyle(
                    fontSize: 18,
                    color: Colors.black54,
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  profile.description,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 40),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.pink,
                    padding: const EdgeInsets.symmetric(horizontal: 36, vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();           // Move back to the previous screen
                  },
                  child: const Text(
                    'Back to Cards',
                    style: TextStyle(fontSize: 18, color: Colors.black26),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
