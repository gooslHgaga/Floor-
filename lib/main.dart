import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/services.dart';
import 'models/image_item.dart';
import 'services/storage_service.dart';
import 'services/ocr_service.dart';
import 'widgets/image_card.dart';
import 'package:permission_handler/permission_handler.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await StorageService.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'OCR Gallery',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const HomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final picker = ImagePicker();
  final ocr = OcrService();
  List<ImageItem> images = [];

  @override
  void initState() {
    super.initState();
    _loadImages();
  }

  Future<void> _loadImages() async {
    final list = StorageService.loadAllImages();
    if (!mounted) return;
    setState(() => images = list);
  }

  Future<void> _takePicture() async {
    final pStatus = await Permission.camera.request();
    if (!pStatus.isGranted) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('كاميرا مطلوبة')),
      );
      return;
    }

    final picked = await picker.pickImage(
      source: ImageSource.camera,
      preferredCameraDevice: CameraDevice.rear,
    );
    if (picked == null) return;

    final file = File(picked.path);
    final savedItem = await StorageService.saveImageFile(file);

    // استخراج النص تلقائياً
    final text = await ocr.extractTextFromFile(savedItem.path);
    final number = ocr.extractFirstNumber(text);

    savedItem.extractedText = text;
    savedItem.extractedNumber = number;
    await StorageService.updateImage(savedItem);

    await _loadImages();
  }

  Future<void> _onExtract(ImageItem item) async {
    final text = await ocr.extractTextFromFile(item.path);
    final number = ocr.extractFirstNumber(text);

    final newItem = ImageItem.fromMap(item.toMap());
    newItem.extractedText = text;
    newItem.extractedNumber = number;
    await StorageService.updateImage(newItem);

    await _loadImages();

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('اكتمل استخراج النص/الرقم')),
    );
  }

  Future<void> _onUpdate(ImageItem item) async {
    await StorageService.updateImage(item);
    await _loadImages();
  }

  Future<void> _onDelete(ImageItem item) async {
    await StorageService.deleteImage(item);
    await _loadImages();
  }

  Future<void> _copyToClipboard(String text) async {
    await Clipboard.setData(ClipboardData(text: text));
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('تم نسخ الرقم')),
    );
  }

  @override
  void dispose() {
    ocr.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const bottomText = 'تصميم التطبيق بواسطة على التواصل 77';

    return Scaffold(
      appBar: AppBar(title: const Text('معرض الصور - استخراج الأرقام')),
      body: Column(
        children: [
          Expanded(
            child: images.isEmpty
                ? const Center(
                    child: Text('لا توجد صور بعد. اضغط زر الكاميرا لالتقاط صورة.'),
                  )
                : ListView.builder(
                    itemCount: images.length,
                    itemBuilder: (context, idx) {
                      final item = images[idx];
                      return ImageCard(
                        item: item,
                        onExtract: _onExtract,
                        onUpdate: _onUpdate,
                        onDelete: _onDelete,
                        onCopy: _copyToClipboard, // ✅ إضافة دعم النسخ
                      );
                    },
                  ),
          ),
          Container(
            width: double.infinity,
            color: Colors.transparent,
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: const Text(
              bottomText,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.w900,
                color: Colors.black,
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _takePicture,
        child: const Icon(Icons.camera_alt),
      ),
    );
  }
}
