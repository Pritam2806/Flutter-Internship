import 'package:flutter/material.dart';
import '../models/note.dart';
import 'package:intl/intl.dart';
import 'package:google_fonts/google_fonts.dart';

class NoteCard extends StatelessWidget {
  const NoteCard({super.key, required this.note, this.index = 0});

  final Note note;                                         // Created an object of the Class Note
  final int index;                                         // Index of the card for color rotation

  static const _lightColors = [                            // Colors of the Notes Card
    Color(0xFFFFF9C4), // light yellow
    Color(0xFFBBDEFB), // light blue
    Color(0xFFC8E6C9), // light green
    Color(0xFFF8BBD0), // light pink
    Color(0xFFE1BEE7), // light purple
    Color(0xFFFFE0B2), // light orange
  ];

  Color _colorForIndex() {                                 // Color selection function [ Rotating colors based on index ]
    return _lightColors[index % _lightColors.length];
  }

  @override
  Widget build(BuildContext context) {                     // Builds the UI
    final bg = _colorForIndex();                           // Color of the note card (rotation based)
    final created = note.createdAt?.toDate();              // Created Date
    final time = created != null ? DateFormat.yMMMd().format(created) : '';    // Jun 21, 2025 type format
    return Container(
      height: 200,
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 4, offset: Offset(0,2))],
      ),
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            note.title, 
            style: GoogleFonts.outfit(
              fontSize: 18,
              color: Colors.black,
              fontWeight: FontWeight.bold
            )
          ),
          const SizedBox(height: 8),
          Expanded(
            child: Text(
              note.body,
              maxLines: 6,
              overflow: TextOverflow.ellipsis,             // 3 dots for large texts
              style: GoogleFonts.cabin(
                fontSize: 14,
                color: Colors.black,
                fontWeight: FontWeight.w600
            )
            ),
          ),
          Align(alignment: Alignment.bottomRight, child: Text(time, style: const TextStyle(fontSize: 12, color: Colors.black38)))
        ],
      ),
    );
  }
}
