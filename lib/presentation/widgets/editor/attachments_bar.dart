import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path/path.dart' as p;
import 'package:open_file_plus/open_file_plus.dart';
import '../../../logic/services/audio_service.dart';
import '../../pages/editor/attachment_viewer_page.dart';

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
          final fileName = p.basename(path);
          final lowerPath = path.toLowerCase();
          final isImage = lowerPath.endsWith('.jpg') || 
                          lowerPath.endsWith('.png') || 
                          lowerPath.endsWith('.jpeg');
          final isAudio = lowerPath.endsWith('.m4a') || 
                          lowerPath.endsWith('.mp3');
          final isPdf = lowerPath.endsWith('.pdf');
          final isVideo = lowerPath.endsWith('.mp4') || 
                          lowerPath.endsWith('.mov') || 
                          lowerPath.endsWith('.avi');

          return GestureDetector(
            onTap: () => _handleTap(context, path, isImage),
            child: Container(
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
                    Hero(
                      tag: path,
                      child: Image.file(File(path), fit: BoxFit.cover),
                    )
                  else if (isAudio)
                    _buildGenericTile(Icons.audiotrack_rounded, 'Audio', const Color(0xFF0061A4))
                  else if (isPdf)
                    _buildGenericTile(Icons.picture_as_pdf_rounded, 'PDF', Colors.red.shade700)
                  else if (isVideo)
                    _buildGenericTile(Icons.videocam_rounded, 'Video', Colors.purple.shade700)
                  else
                    _buildGenericTile(Icons.insert_drive_file_rounded, 'File', Colors.black45),
                  
                  // Label for generic files
                  if (!isImage)
                    Positioned(
                      bottom: 8,
                      left: 4,
                      right: 4,
                      child: Text(
                        fileName,
                        style: const TextStyle(fontSize: 8, overflow: TextOverflow.ellipsis),
                        textAlign: TextAlign.center,
                      ),
                    ),

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
            ),
          );
        },
      ),
    );
  }

  void _handleTap(BuildContext context, String path, bool isImage) {
    if (isImage) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => AttachmentViewerPage(
            path: path,
            title: p.basename(path),
          ),
        ),
      );
    } else {
      // For Audio, it might be better to use OpenFile as well if we want system player,
      // but the app already has AudioService. Let's prioritize AudioService for m4a/mp3.
      if (path.toLowerCase().endsWith('.m4a') || path.toLowerCase().endsWith('.mp3')) {
        AudioService.playAudio(path);
      } else {
        OpenFile.open(path);
      }
    }
  }

  Widget _buildGenericTile(IconData icon, String label, Color color) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon, size: 32, color: color),
        const SizedBox(height: 4),
        Text(
          label, 
          style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: color.withValues(alpha: 0.8))
        ),
      ],
    );
  }
}
