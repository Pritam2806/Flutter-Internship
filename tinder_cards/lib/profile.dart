import 'package:flutter/material.dart';

class Profile {
  final String name;                                       // What each profile will contain
  final int age;
  final String description;
  final List<Color> gradientColors;
  final IconData avatarIcon;

  const Profile({                                          // Constructor
    required this.name,
    required this.age,
    required this.description,
    required this.gradientColors,
    required this.avatarIcon,
  });
}

final List<Profile> profiles = const [
    Profile(
      name: 'Aarav Patel',
      age: 24,
      description: 'Loves hiking and new coffee shops.',
      gradientColors: [Color(0xFFFBAB66), Color(0xFFF7418C)],
      avatarIcon: Icons.person,
    ),
    Profile(
      name: 'Mia Thompson',
      age: 22,
      description: 'Yoga enthusiast and travel planner.',
      gradientColors: [Color(0xFF00B4DB), Color(0xFF0083B0)],
      avatarIcon: Icons.person_outline,
    ),
    Profile(
      name: 'Noah Smith',
      age: 26,
      description: 'Into tech, music, and weekend road trips.',
      gradientColors: [Color(0xFF8E2DE2), Color(0xFF4A00E0)],
      avatarIcon: Icons.man,
    ),
    Profile(
      name: 'Zara Khan',
      age: 23,
      description: 'Art lover with a soft spot for street food.',
      gradientColors: [Color(0xFFFF7E5F), Color(0xFFFEB47B)],
      avatarIcon: Icons.face_retouching_natural,
    ),
    Profile(
      name: 'Ethan Carter',
      age: 25,
      description: 'Startup builder and marathon runner.',
      gradientColors: [Color(0xFF00C9FF), Color(0xFF92FE9D)],
      avatarIcon: Icons.sports_basketball,
    ),
    Profile(
      name: 'Lina Gomez',
      age: 24,
      description: 'Avid reader and film night host.',
      gradientColors: [Color(0xFFFF5F6D), Color(0xFFFFC371)],
      avatarIcon: Icons.camera_alt,
    ),
    Profile(
      name: 'Arjun Mehta',
      age: 27,
      description: 'Gamer, coder, and foodie on the weekends.',
      gradientColors: [Color(0xFF36D1DC), Color(0xFF5B86E5)],
      avatarIcon: Icons.videogame_asset,
    ),
    Profile(
      name: 'Nina Das',
      age: 21,
      description: 'Music festival lover and amateur chef.',
      gradientColors: [Color(0xFFFF9A9E), Color(0xFFFAD0C4)],
      avatarIcon: Icons.music_note,
    ),
    Profile(
      name: 'Rahul Sharma',
      age: 28,
      description: 'Beach runner and weekend explorer.',
      gradientColors: [Color(0xFFEE9CA7), Color(0xFFFFDDE1)],
      avatarIcon: Icons.directions_run,
    ),
    Profile(
      name: 'Sara Ali',
      age: 23,
      description: 'Dreamer, painter, and planner of city escapes.',
      gradientColors: [Color(0xFF43C6AC), Color(0xFF191654)],
      avatarIcon: Icons.brush,
    ),
  ];
