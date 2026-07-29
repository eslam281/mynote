import 'dart:io';
import 'package:record/record.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

class AudioService {
  static final AudioRecorder _recorder = AudioRecorder();
  static final AudioPlayer _player = AudioPlayer();
  
  static Future<bool> startRecording() async {
    if (await _recorder.hasPermission()) {
      final directory = await getApplicationDocumentsDirectory();
      final audioDir = Directory(p.join(directory.path, 'audio'));
      if (!await audioDir.exists()) {
        await audioDir.create(recursive: true);
      }
      
      final path = p.join(audioDir.path, '${DateTime.now().millisecondsSinceEpoch}.m4a');
      
      await _recorder.start(const RecordConfig(), path: path);
      return true;
    }
    return false;
  }

  static Future<String?> stopRecording() async {
    return await _recorder.stop();
  }

  static Future<void> playAudio(String path) async {
    await _player.play(DeviceFileSource(path));
  }

  static Future<void> pauseAudio() async {
    await _player.pause();
  }

  static Future<void> stopAudio() async {
    await _player.stop();
  }
}
