import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:photo/main.dart'; // غيّر اسم الباكج حسب مشروعك

void main() {
  testWidgets('App starts and shows home screen', (WidgetTester tester) async {
    // تشغيل التطبيق
    await tester.pumpWidget(const MyApp());

    // التأكد من وجود MaterialApp
    expect(find.byType(MaterialApp), findsOneWidget);

    // التأكد من ظهور AppBar مع العنوان الصحيح
    expect(find.text('معرض الصور - استخراج الأرقام'), findsOneWidget);

    // التأكد من وجود FloatingActionButton
    expect(find.byType(FloatingActionButton), findsOneWidget);

    // التأكد من وجود النص السفلي
    expect(find.text('تصميم التطبيق بواسطة على التواصل 77'), findsOneWidget);
  });

  // حذف أو تجاوز اختبار التنقل لأنه غير موجود في التطبيق الحالي
}
