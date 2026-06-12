import 'package:flutter/material.dart';
import '../models/note.dart';
import 'package:intl/intl.dart';

class NoteCard extends StatelessWidget {
  const NoteCard({super.key, required this.note});

  final Note note;                                         // Created an object of the Class Note

  static const _lightColors = [                            // Colors of the Notes Card
    Color(0xFFFFF9C4), // light yellow
    Color(0xFFBBDEFB), // light blue
    Color(0xFFC8E6C9), // light green
    Color(0xFFF8BBD0), // light pink
    Color(0xFFE1BEE7), // light purple
    Color(0xFFFFE0B2), // light orange
  ];

  Color _colorForId(String? id) {                          // Color selection function [ Returns color for the card ]
    if (id == null) return _lightColors[0];                // Colors for the first note
    final idx = id.hashCode.abs() % _lightColors.length;
    return _lightColors[idx];
  }

  @override
  Widget build(BuildContext context) {                     // Builds the UI
    final bg = _colorForId(note.id);                       // Color of the note card
    final created = note.createdAt?.toDate();              // Created Date
    final time = created != null ? DateFormat.yMMMd().format(created) : '';    // Jun 21, 2025 type format
    return Container(
      height: 160,
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 4, offset: Offset(0,2))],
      ),
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(note.title, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 18, color: Colors.black)),
          const SizedBox(height: 8),
          Expanded(
            child: Text(
              note.body,
              maxLines: 4,
              overflow: TextOverflow.ellipsis,             // 3 dots for large texts
              style: TextStyle(fontSize: 14, color: Colors.black54),
            ),
          ),
          Align(alignment: Alignment.bottomRight, child: Text(time, style: const TextStyle(fontSize: 12, color: Colors.black38)))
        ],
      ),
    );
  }
}
