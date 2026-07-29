import 'package:flutter/material.dart';

class FormattingToolbar extends StatelessWidget {
  final VoidCallback onBold;
  final VoidCallback onItalic;
  final VoidCallback onBullet;
  final VoidCallback onChecklist;
  final VoidCallback onMic;
  final bool isRecording;
  final bool isChecklist;

  const FormattingToolbar({
    super.key,
    required this.onBold,
    required this.onItalic,
    required this.onBullet,
    required this.onChecklist,
    required this.onMic,
    required this.isRecording,
    required this.isChecklist,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Colors.black.withValues(alpha: 0.1))),
      ),
      child: Row(
        children: [
          IconButton(
            icon: Icon(Icons.format_bold_rounded, color: Colors.black87),
            onPressed: onBold,
          ),
          IconButton(
            icon: Icon(Icons.format_italic_rounded, color: Colors.black87),
            onPressed: onItalic,
          ),
          IconButton(
            icon: Icon(Icons.format_list_bulleted_rounded, color: Colors.black87),
            onPressed: onBullet,
          ),
          VerticalDivider(width: 20, indent: 12, endIndent: 12),
          IconButton(
            icon: Icon(
              isChecklist ? Icons.check_box_rounded : Icons.check_box_outline_blank_rounded,
              color: isChecklist ? const Color(0xFF0061A4) : Colors.black87,
            ),
            onPressed: onChecklist,
          ),
          const Spacer(),
          IconButton(
            icon: Icon(
              isRecording ? Icons.stop_circle_rounded : Icons.mic_rounded,
              color: isRecording ? Colors.red : Colors.black87,
              size: 28,
            ),
            onPressed: onMic,
          ),
        ],
      ),
    );
  }
}
