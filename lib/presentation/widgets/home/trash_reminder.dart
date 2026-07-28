import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TrashReminder extends StatelessWidget {
  const TrashReminder({super.key});

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Container(
        padding: const EdgeInsets.all(16),
        margin: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.blue.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.blue.withValues(alpha: 0.2)),
        ),
        child: Row(
          children: [
            const Icon(Icons.info_outline, color: Colors.blue, size: 20),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                'Notes in Trash will be permanently deleted after 30 days.',
                style: GoogleFonts.poppins(
                  fontSize: 13,
                  color: Colors.blue.shade800,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
