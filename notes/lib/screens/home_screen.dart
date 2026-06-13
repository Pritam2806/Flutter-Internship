import 'package:flutter/material.dart';
import '../models/note.dart';
import '../services/firestore_service.dart';
import 'note_edit_screen.dart';
import '../widgets/note_card.dart';

class HomeScreen extends StatelessWidget {                 // Stateless widget
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notes App'),
        centerTitle: true,
        actions: [ 
          IconButton(
            onPressed: () async {   
              await Navigator.push(context, MaterialPageRoute(builder: (_) => const NoteEditScreen()));
            },                                             // Navigate to NoteEditScreen when we press Add icon
            icon: const Icon(Icons.add, color: Colors.white),
          ),
        ]
      ),
      // ***** Stream helps in Realtime updates because the stream is continuously listening to Firestore changes ******
      body: StreamBuilder<List<Note>> (                    // A widget that listens to a stream.
      // Whenever Firestore data changes: [Add Note,Edit Note,Delete Note], UI rebuilds automatically. [No manual refresh needed]
        stream: FirestoreService.instance.notesStream(),   // Gets a stream of notes from Firestore [ Helps realtime updates ]
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {           // snapshot contains stream data.
            return const Center(child: CircularProgressIndicator());           // When loading data, Loading spinner is there
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {                   // When no notes are there.
            return const Center(child: Text('No Notes Yet! Try Adding Using "+" Icon!'));
          }
          final notes = snapshot.data!;                    // Get notes from the snapshot
          return ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 18),
            itemCount: notes.length,                       // Determines how many notes to display
            itemBuilder: (context, index) {
              final note = notes[index];                   // Gets current note
              return GestureDetector(
                onTap: () async {
                  await Navigator.push(context, MaterialPageRoute(builder: (_) => NoteEditScreen(note: note)));
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: NoteCard(note: note, index: index),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
