import 'dart:io';
import 'package:flutter/material.dart';
import '../../../logic/services/audio_service.dart';

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
          final lowerPath = path.toLowerCase();
          final isImage = lowerPath.endsWith('.jpg') || 
                          lowerPath.endsWith('.png') || 
                          lowerPath.endsWith('.jpeg');
          final isAudio = lowerPath.endsWith('.m4a') || 
                          lowerPath.endsWith('.mp3');

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
                else if (isAudio)
                  _buildAudioTile(path)
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

  Widget _buildAudioTile(String path) {
    return InkWell(
      onTap: () => AudioService.playAudio(path),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.audiotrack_rounded, size: 32, color: Color(0xFF0061A4)),
          const SizedBox(height: 4),
          const Text('Play Audio', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
