import 'dart:io';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

class FileService {
  static Future<String> saveAttachment(File file) async {
    final directory = await getApplicationDocumentsDirectory();
    final attachmentsDir = Directory(p.join(directory.path, 'attachments'));
    
    if (!await attachmentsDir.exists()) {
      await attachmentsDir.create(recursive: true);
    }
    
    final fileName = '${DateTime.now().millisecondsSinceEpoch}_${p.basename(file.path)}';
    final savedFile = await file.copy(p.join(attachmentsDir.path, fileName));
    
    return savedFile.path;
  }

  static Future<void> deleteAttachment(String path) async {
    final file = File(path);
    if (await file.exists()) {
      await file.delete();
    }
  }
}
