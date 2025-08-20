import 'package:audioplayers/audioplayers.dart';
import 'package:file_picker/file_picker.dart';

final AudioPlayer _player = AudioPlayer();

class AudioService {
  static Future<void> playAdan() async {
    await _player.play(AssetSource('sounds/adan.mp3'));
  }

  static Future<void> pickExternal() async {
    final result = await FilePicker.platform.pickFiles(type: FileType.audio);
    if (result != null) {
      await _player.play(DeviceFileSource(result.files.single.path!));
    }
  }
}
