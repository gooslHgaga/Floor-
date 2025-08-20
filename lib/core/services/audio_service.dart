// بدون صوت افتراضي، فقط اختيار ملف من الهاتف
import 'package:file_picker/file_picker.dart';
import 'package:audioplayers/audioplayers.dart';

final AudioPlayer _player = AudioPlayer();

class AudioService {
  static Future<void> playAdan() async {}
  static Future<void> pickExternal() async {
    final res = await FilePicker.platform.pickFiles(type: FileType.audio);
    if (res != null && res.files.single.path != null) {
      await _player.play(DeviceFileSource(res.files.single.path!));
    }
  }
}
