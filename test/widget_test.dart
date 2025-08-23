import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:photo/main.dart'; // غيّر اسم الباكج حسب مشروعك

void main() {
  // تهيئة اختبار ويدجت
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    // تهيئة Hive قبل أي اختبار
    await Hive.initFlutter('.');
    // فتح Box وهمي لاختبارات الويدجت
    await Hive.openBox('imagesBox'); // استبدل 'imagesBox' باسم الـ Box الفعلي لديك
  });

  testWidgets('App starts and shows home screen', (WidgetTester tester) async {
    // تشغيل التطبيق
    await tester.pumpWidget(const MyApp());

    // التأكد من وجود MaterialApp
    expect(find.byType(MaterialApp), findsOneWidget);

    // التأكد من ظهور HomePage
    expect(find.byType(HomePage), findsOneWidget);

    // التأكد من ظهور AppBar مع العنوان الصحيح
    expect(find.text('معرض الصور - استخراج الأرقام'), findsOneWidget);

    // التأكد من وجود FloatingActionButton
    expect(find.byType(FloatingActionButton), findsOneWidget);

    // التأكد من وجود النص السفلي
    expect(find.text('تصميم التطبيق بواسطة على التواصل 77'), findsOneWidget);
  });
}
