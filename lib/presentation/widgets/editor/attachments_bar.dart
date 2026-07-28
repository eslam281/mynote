import 'dart:io';
import 'package:flutter/material.dart';

class AttachmentsBar extends StatelessWidget {
  final List<String> attachments;
  final Function(int) onRemoveAttachment;

  const AttachmentsBar({
    super.key,
    required this.attachments,
    required this.onRemoveAttachment,
  });

  @override
  Widget build(BuildContext context) {
    if (attachments.isEmpty) return const SizedBox.shrink();

    return Container(
      height: 120,
      margin: const EdgeInsets.only(bottom: 16),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: attachments.length,
        itemBuilder: (context, index) {
          final path = attachments[index];
          final isImage = path.toLowerCase().endsWith('.jpg') || 
                          path.toLowerCase().endsWith('.png') || 
                          path.toLowerCase().endsWith('.jpeg');

          return Container(
            width: 100,
            margin: const EdgeInsets.only(right: 12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: Colors.black.withValues(alpha: 0.05),
            ),
            clipBehavior: Clip.antiAlias,
            child: Stack(
              fit: StackFit.expand,
              children: [
                if (isImage)
                  Image.file(File(path), fit: BoxFit.cover)
                else
                  const Center(child: Icon(Icons.insert_drive_file_rounded, size: 32, color: Colors.black45)),
                Positioned(
                  top: 4,
                  right: 4,
                  child: GestureDetector(
                    onTap: () => onRemoveAttachment(index),
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(color: Colors.black54, shape: BoxShape.circle),
                      child: const Icon(Icons.close, size: 12, color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
