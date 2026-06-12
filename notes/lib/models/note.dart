import 'package:cloud_firestore/cloud_firestore.dart';

class Note {                                               // Notes class [ Blueprint for every note ]
  final String? id;
  String title;
  String body;
  Timestamp? createdAt;
  Timestamp? updatedAt;

  Note({this.id, required this.title, required this.body, this.createdAt, this.updatedAt});        // Constructor

  factory Note.fromDoc(DocumentSnapshot doc) {             // Factory constructor -> firebase document "JSON" into Note object
    final data = doc.data() as Map<String, dynamic>? ?? {};          // Gets Firebase Document content [ Example - Json]
    return Note(                                           // Returns the Note Object
      id: doc.id,
      title: data['title'] as String? ?? '',               // data is a map    
      body: data['body'] as String? ?? '',
      createdAt: data['createdAt'] as Timestamp?,
      updatedAt: data['updatedAt'] as Timestamp?,
    );
  }

  Map<String, dynamic> toMap({bool serverTimestamps = false}) {      // Converts Note object into a JSON.
    if (serverTimestamps) {
      return {
        'title': title,
        'body': body,
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      };
    }
    return {                                               // Converts map to Json
      'title': title,
      'body': body,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }
}
