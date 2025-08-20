// lib/core/services/audio_service.dart
// نسخة معدّلة: اختيار ملف صوت من الهاتف فقط (بدون أذان افتراضي)

import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:audioplayers/audioplayers.dart';

final AudioPlayer _player = AudioPlayer();

class AudioService {
  /// لا يُشغَّل أذان افتراضي
  static Future<void> playAdan() async {}

  /// اختيار ملف صوت من الهاتف وتشغيله
  static Future<void> pickExternal() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.audio,
      allowCompression: false,
    );

    if (result != null && result.files.single.path != null) {
      await _player.stop(); // إيقاف أي تشغيل سابق
      await _player.play(DeviceFileSource(result.files.single.path!));
    }
  }
}
