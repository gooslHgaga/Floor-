import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';

class OcrService {
  final textRecognizer = TextRecognizer(script: TextRecognitionScript.latin);

  /// استخراج النص الكامل من الصورة
  Future<String> extractTextFromFile(String imagePath) async {
    final inputImage = InputImage.fromFilePath(imagePath);
    final result = await textRecognizer.processImage(inputImage);
    final buffer = StringBuffer();
    for (var block in result.blocks) {
      buffer.writeln(block.text);
    }
    return buffer.toString();
  }

  /// استخراج أول نص رقمي (أو سلسلة أرقام) من النص الكامل
  String extractFirstNumber(String text) {
    // regex للبحث عن أرقام عربية-غربية
    final regex = RegExp(r'[\d٠-٩]+', unicode: true);
    final match = regex.firstMatch(text);
    if (match != null) {
      final raw = match.group(0) ?? '';
      return _convertArabicDigitsToWestern(raw);
    }
    return '';
  }

  /// تحويل الأرقام العربية إلى أرقام غربية
  String _convertArabicDigitsToWestern(String input) {
    const arabic = '٠١٢٣٤٥٦٧٨٩';
    const western = '0123456789';
    var out = input;
    for (var i = 0; i < arabic.length; i++) {
      out = out.replaceAll(arabic[i], western[i]);
    }
    return out;
  }

  /// إغلاق الـ TextRecognizer لتفادي استهلاك الذاكرة
  void dispose() {
    textRecognizer.close();
  }
}
