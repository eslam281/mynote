import 'dart:ui';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../data/models/note_model.dart';

class NoteCard extends StatelessWidget {
  final NoteModel note;
  final VoidCallback onTap;
  final VoidCallback onLongPress;
  final bool isListMode;

  const NoteCard({
    super.key,
    required this.note,
    required this.onTap,
    required this.onLongPress,
    this.isListMode = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: Color(note.color).withValues(alpha: 0.95),
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          onLongPress: onLongPress,
          borderRadius: BorderRadius.circular(28),
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.all(22.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            note.title,
                            style: GoogleFonts.poppins(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              color: const Color(0xFF001E30),
                              height: 1.3,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: 8),
                        if (note.isPinned)
                          Container(
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: Colors.black.withValues(alpha: 0.05),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.push_pin_rounded, size: 16, color: Color(0xFF0061A4)),
                          ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    if (note.isLocked)
                      _buildLockedContent()
                    else ...[
                      if (note.attachments.isNotEmpty)
                        _buildAttachmentsPreview(),
                      if (note.isChecklist)
                        _buildChecklistPreview()
                      else if (note.content.isNotEmpty)
                        ConstrainedBox(
                          constraints: BoxConstraints(maxHeight: isListMode ? 50 : 120),
                          child: MarkdownBody(
                            data: note.content,
                            styleSheet: MarkdownStyleSheet(
                              p: GoogleFonts.poppins(
                                fontSize: 14,
                                color: const Color(0xFF001E30).withValues(alpha: 0.7),
                                height: 1.6,
                              ),
                            ),
                          ),
                        ),
                    ],
                    const SizedBox(height: 24),
                    _buildFooter(),
                  ],
                ),
              ),
              if (note.isLocked)
                Positioned.fill(
                  child: Center(
                    child: Icon(Icons.lock_rounded, color: const Color(0xFF0061A4).withValues(alpha: 0.4), size: 32),
                  ),
                ),
            ],
          ),
        ),
      ),
    )
        .animate()
        .fadeIn(duration: 400.ms, curve: Curves.easeOut)
        .scale(begin: const Offset(0.9, 0.9), duration: 400.ms, curve: Curves.bounceOut);
  }

  Widget _buildLockedContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: ImageFiltered(
            imageFilter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
            child: Text(
              'This note is locked and protected by security.',
              style: GoogleFonts.poppins(fontSize: 14),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildChecklistPreview() {
    try {
      final List<dynamic> items = jsonDecode(note.content);
      final previewItems = items.take(3).toList();
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ...previewItems.map((item) => Padding(
            padding: const EdgeInsets.only(bottom: 4),
            child: Row(
              children: [
                Icon(
                  item['isDone'] ? Icons.check_box_rounded : Icons.check_box_outline_blank_rounded,
                  size: 14,
                  color: item['isDone'] ? const Color(0xFF0061A4) : Colors.black38,
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    item['text'],
                    style: GoogleFonts.poppins(
                      fontSize: 13,
                      decoration: item['isDone'] ? TextDecoration.lineThrough : null,
                      color: item['isDone'] ? Colors.black38 : Colors.black87,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          )),
          if (items.length > 3)
            Text(
              '+ ${items.length - 3} more items',
              style: GoogleFonts.poppins(fontSize: 11, color: Colors.black38),
            ),
        ],
      );
    } catch (e) {
      return const SizedBox.shrink();
    }
  }

  Widget _buildAttachmentsPreview() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          const Icon(Icons.attach_file_rounded, size: 16, color: Color(0xFF0061A4)),
          const SizedBox(width: 4),
          Text(
            '${note.attachments.length} attachment(s)',
            style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.w600, color: const Color(0xFF0061A4)),
          ),
        ],
      ),
    );
  }

  Widget _buildFooter() {
    final hasAudio = note.attachments.any((a) => a.toLowerCase().endsWith('.m4a') || a.toLowerCase().endsWith('.mp3'));

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Text(
              DateFormat('MMM dd, yyyy').format(note.createdAt),
              style: GoogleFonts.poppins(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF001E30).withValues(alpha: 0.4),
              ),
            ),
            if (hasAudio) ...[
              const SizedBox(width: 8),
              Icon(Icons.mic_rounded, size: 12, color: const Color(0xFF001E30).withValues(alpha: 0.4)),
            ],
          ],
        ),
        if (note.category != null)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  const Color(0xFF0061A4).withValues(alpha: 0.1),
                  const Color(0xFF00A3FF).withValues(alpha: 0.1),
                ],
              ),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              note.category!,
              style: const TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w800,
                color: Color(0xFF0061A4),
                letterSpacing: 0.5,
              ),
            ),
          ),
      ],
    );
  }
}
