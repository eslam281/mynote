import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../../../logic/l10n/app_localizations.dart';
import '../../../data/models/note_model.dart';

class NoteOptionsSheet extends StatelessWidget {
// ... same fields ...
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
    final l10n = AppLocalizations.of(context);

    return SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 8),
          if (!note.isDeleted) ...[
            ListTile(
              leading: Icon(note.isPinned ? Icons.push_pin : Icons.push_pin_outlined),
              title: Text(note.isPinned ? l10n.translate('unpin') : l10n.translate('pin')),
              onTap: () {
                onTogglePin(note);
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.copy_outlined),
              title: Text(l10n.translate('duplicate')),
              onTap: () {
                onDuplicate(note);
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(note.isArchived ? Icons.unarchive_outlined : Icons.archive_outlined),
              title: Text(note.isArchived ? l10n.translate('unarchive') : l10n.translate('archive')),
              onTap: () {
                onToggleArchive(note);
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete_outline, color: Colors.orange),
              title: Text(l10n.translate('move_to_trash'), style: const TextStyle(color: Colors.orange)),
              onTap: () {
                onSoftDelete(note);
                Navigator.pop(context);
              },
            ),
          ] else ...[
            ListTile(
              leading: const Icon(Icons.restore_outlined),
              title: Text(l10n.translate('restore')),
              onTap: () {
                onRestore(note);
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete_forever_outlined, color: Colors.red),
              title: Text(l10n.translate('delete_permanent'), style: const TextStyle(color: Colors.red)),
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
    final l10n = AppLocalizations.of(context);
    final words = content.trim().isEmpty ? 0 : content.trim().split(RegExp(r'\s+')).length;
    final chars = content.length;

    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(l10n.translate('note_info'), style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 20),
          _infoRow(Icons.text_fields, l10n.translate('characters'), chars.toString()),
          _infoRow(Icons.short_text, l10n.translate('words'), words.toString()),
          _infoRow(Icons.calendar_today, l10n.translate('created'), DateFormat('MMM dd, yyyy HH:mm').format(note?.createdAt ?? DateTime.now())),
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
