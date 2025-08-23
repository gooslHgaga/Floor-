import 'dart:io';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:uuid/uuid.dart';
import '../models/image_item.dart';

class StorageService {
  static const String boxName = 'images_box';

  /// تهيئة Hive وفتح الـ Box
  static Future<void> init() async {
    await Hive.initFlutter();
    await Hive.openBox(boxName);
  }

  /// حفظ الصورة في مجلد التطبيق وإنشاء ImageItem جديد
  static Future<ImageItem> saveImageFile(File file) async {
    final appDir = await getApplicationDocumentsDirectory();
    final uuid = const Uuid().v4();
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

  /// تحميل كل الصور من Hive وترتيبها حسب الأحدث أولاً
  static List<ImageItem> loadAllImages() {
    final box = Hive.box(boxName);
    final List<ImageItem> list = [];
    for (var key in box.keys) {
      final map = box.get(key);
      if (map != null && map is Map) {
        list.add(ImageItem.fromMap(Map<String, dynamic>.from(map)));
      }
    }
    list.sort((a, b) => b.capturedAt.compareTo(a.capturedAt));
    return list;
  }

  /// تحديث بيانات صورة موجودة
  static Future<void> updateImage(ImageItem item) async {
    final box = Hive.box(boxName);
    await box.put(item.id, item.toMap());
  }

  /// حذف صورة من الجهاز ومن Hive
  static Future<void> deleteImage(ImageItem item) async {
    try {
      final file = File(item.path);
      if (await file.exists()) {
        await file.delete();
      }
    } catch (e) {
      // ممكن تطبع الخطأ أو تتجاهله
    }
    final box = Hive.box(boxName);
    await box.delete(item.id);
  }
}
