import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/note.dart';

class FirestoreService {                                   // Service class that manages Firestore operations.
  FirestoreService._();                                    // Firestore private constructor
  static final FirestoreService instance = FirestoreService._();     // Instance of the FireStoreService

  final CollectionReference _notesCol = FirebaseFirestore.instance.collection('notes');  // Connects to Firebase Collection

  Stream<List<Note>> notesStream() {                       // Returns a stream of notes [ Realtime updates ]
    return _notesCol.orderBy('createdAt', descending: false).snapshots().map((snap) {    // Sort notes by creation time
      return snap.docs.map((d) => Note.fromDoc(d)).toList();
    });
  }    // Returns a list of notes

  Future<DocumentReference> createNote(Note note) async {  // Adds a new Note to the Firestore
    return await _notesCol.add(note.toMap(serverTimestamps: true));
  }    // Note converted to map/JSON and add to Firestore

  Future<void> updateNote(Note note) async {               // Updating the note
    if (note.id == null) return;
    await _notesCol.doc(note.id).update({                  // Select the note with the id to update it
      'title': note.title,
      'body': note.body,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> deleteNote(String id) async {               // Deleting the note
    await _notesCol.doc(id).delete();                      // Select the note with the id to delete it.
  }
}
