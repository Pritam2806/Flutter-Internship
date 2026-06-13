import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/note.dart';
import '../services/firestore_service.dart';

class NoteEditScreen extends StatefulWidget {
  const NoteEditScreen({super.key, this.note});
  final Note? note;

  @override
  State<NoteEditScreen> createState() => _NoteEditScreenState();
}

class _NoteEditScreenState extends State<NoteEditScreen> {
  late final TextEditingController _titleCtrl;
  late final TextEditingController _bodyCtrl;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _titleCtrl = TextEditingController(text: widget.note?.title ?? '');
    _bodyCtrl = TextEditingController(text: widget.note?.body ?? '');
  }

  @override
  void dispose() {                                         // Freeing up the resources.
    _titleCtrl.dispose();
    _bodyCtrl.dispose();
    super.dispose();
  }

  Future<void> _save() async {                             // Save Functionality
    final title = _titleCtrl.text.trim();                  // "trim" removes the trailing spaces
    final body = _bodyCtrl.text.trim();                    // "trim" removes the trailing spaces
    if (title.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Title cannot be empty!!')));
      return;
    }
    setState(() => _saving = true);
    try {
      if (widget.note == null) {
        final note = Note(title: title, body: body);
        await FirestoreService.instance.createNote(note);
      } 
      else {
        final note = widget.note!;
        note.title = title;
        note.body = body;
        await FirestoreService.instance.updateNote(note);
      }
      if (mounted) {
        Navigator.pop(context);
      }
    } 
    catch (e) {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to save note: $e')));
    } 
    finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  Future<void> _delete() async {                           // Delete Functionality
    if (widget.note?.id == null) return;
    final confirm = await showDialog<bool>(                // Dialog Box for confirmation
      context: context,
      builder: (c) => AlertDialog(
        title: const Text('Delete note?'),
        content: const Text('This action cannot be undone.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(c, false), child: const Text('Cancel')),
          TextButton(onPressed: () => Navigator.pop(c, true), child: const Text('Delete')),
        ],
      ),
    );
    if (confirm == true) {
      await FirestoreService.instance.deleteNote(widget.note!.id!);            // Deleting the note from Firestore
      if (mounted) Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.note != null;
    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Edit Note' : 'New Note'),
        actions: [
          if (isEditing)
            IconButton(
              onPressed: _delete,
              icon: const Icon(Icons.delete_outline),
            ),
          IconButton(
            onPressed: _saving ? null : _save,
            icon: const Icon(Icons.done),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _titleCtrl,
              decoration: const InputDecoration(hintText: 'Title'),
              style: GoogleFonts.outfit(
                fontSize: 24,
                color: Colors.white,
                fontWeight: FontWeight.bold
              ),
            ),
            const SizedBox(height: 20),
            Expanded(                                      // Expanded very important  for handling the Keypad
              child: TextField(
                controller: _bodyCtrl,
                maxLines: null,
                expands: true,
                onTap: () {
                  // Clear selection when tapped to allow cursor placement
                  _bodyCtrl.selection = TextSelection.collapsed(offset: _bodyCtrl.selection.baseOffset);
                },
                decoration: const InputDecoration(hintText: 'Body', border: InputBorder.none),
                style: GoogleFonts.cabin(
                  fontSize: 15,
                  color: Colors.white70,
                  fontWeight: FontWeight.w700
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
