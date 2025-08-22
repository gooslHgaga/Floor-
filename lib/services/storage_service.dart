import 'dart:io';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:uuid/uuid.dart';
import '../models/image_item.dart';

class StorageService {
  static const String boxName = 'images_box';
  static Future<void> init() async {
    await Hive.initFlutter();
    await Hive.openBox(boxName);
  }

  static Future<ImageItem> saveImageFile(File file) async {
    final appDir = await getApplicationDocumentsDirectory();
    final uuid = Uuid().v4();
    final ext = p.extension(file.path);
    final filename = 'img_$uuid$ext';
    final savedPath = p.join(appDir.path, filename);
    final savedFile = await file.copy(savedPath);

    final item = ImageItem(
      id: uuid,
      path: savedFile.path,
      capturedAt: DateTime.now(),
    );

    final box = Hive.box(boxName);
    await box.put(item.id, item.toMap());
    return item;
  }

  static List<ImageItem> loadAllImages() {
    final box = Hive.box(boxName);
    final List<ImageItem> list = [];
    for (var key in box.keys) {
      final map = box.get(key);
      if (map != null && map is Map) {
        list.add(ImageItem.fromMap(map));
      }
    }
    // sort: newest first (so the first image in list is the most recent)
    list.sort((a, b) => b.capturedAt.compareTo(a.capturedAt));
    return list;
  }

  static Future<void> updateImage(ImageItem item) async {
    final box = Hive.box(boxName);
    await box.put(item.id, item.toMap());
  }

  static Future<void> deleteImage(ImageItem item) async {
    try {
      final file = File(item.path);
      if (await file.exists()) await file.delete();
    } catch (e) {
      // ignore
    }
    final box = Hive.box(boxName);
    await box.delete(item.id);
  }
}
