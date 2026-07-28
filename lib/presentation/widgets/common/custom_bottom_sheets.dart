import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../../../data/models/note_model.dart';

class NoteOptionsSheet extends StatelessWidget {
  final NoteModel note;
  final Function(NoteModel) onTogglePin;
  final Function(NoteModel) onToggleArchive;
  final Function(NoteModel) onSoftDelete;
  final Function(NoteModel) onRestore;
  final Function(int) onDeletePermanently;
  final Function(NoteModel) onDuplicate;

  const NoteOptionsSheet({
    super.key,
    required this.note,
    required this.onTogglePin,
    required this.onToggleArchive,
    required this.onSoftDelete,
    required this.onRestore,
    required this.onDeletePermanently,
    required this.onDuplicate,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 8),
          if (!note.isDeleted) ...[
            ListTile(
              leading: Icon(note.isPinned ? Icons.push_pin : Icons.push_pin_outlined),
              title: Text(note.isPinned ? 'Unpin' : 'Pin'),
              onTap: () {
                onTogglePin(note);
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.copy_outlined),
              title: const Text('Duplicate'),
              onTap: () {
                onDuplicate(note);
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(note.isArchived ? Icons.unarchive_outlined : Icons.archive_outlined),
              title: Text(note.isArchived ? 'Unarchive' : 'Archive'),
              onTap: () {
                onToggleArchive(note);
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete_outline, color: Colors.orange),
              title: const Text('Move to Trash', style: TextStyle(color: Colors.orange)),
              onTap: () {
                onSoftDelete(note);
                Navigator.pop(context);
              },
            ),
          ] else ...[
            ListTile(
              leading: const Icon(Icons.restore_outlined),
              title: const Text('Restore Note'),
              onTap: () {
                onRestore(note);
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete_forever_outlined, color: Colors.red),
              title: const Text('Delete Permanently', style: TextStyle(color: Colors.red)),
              onTap: () {
                onDeletePermanently(note.id!);
                Navigator.pop(context);
              },
            ),
          ],
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}

class NoteInfoSheet extends StatelessWidget {
  final NoteModel? note;
  final String content;

  const NoteInfoSheet({super.key, this.note, required this.content});

  @override
  Widget build(BuildContext context) {
    final words = content.trim().isEmpty ? 0 : content.trim().split(RegExp(r'\s+')).length;
    final chars = content.length;

    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Note Info', style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 20),
          _infoRow(Icons.text_fields, 'Characters', chars.toString()),
          _infoRow(Icons.short_text, 'Words', words.toString()),
          _infoRow(Icons.calendar_today, 'Created', DateFormat('MMM dd, yyyy HH:mm').format(note?.createdAt ?? DateTime.now())),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _infoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.black54),
          const SizedBox(width: 12),
          Text(label, style: const TextStyle(color: Colors.black54)),
          const Spacer(),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
