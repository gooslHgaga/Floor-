import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:photo/main.dart'; // غيّر اسم الباكج حسب مشروعك

void main() {
  testWidgets('App starts and shows home screen', (WidgetTester tester) async {
    // تشغيل التطبيق
    await tester.pumpWidget(const MyApp());

    // التأكد أن أول شاشة ظهرت تحتوي على نص أو ويدجت معين
    expect(find.byType(MaterialApp), findsOneWidget);

    // مثال: لو عندك AppBar فيه عنوان
    expect(find.text('MyApp'), findsOneWidget);
  });

  testWidgets('Navigate to next screen works', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    // البحث عن زر أو أيقونة للتنقل
    final Finder button = find.byType(ElevatedButton);

    // الضغط على الزر
    await tester.tap(button);
    await tester.pumpAndSettle(); // مهم لحل مشكلة async gaps

    // التحقق من ظهور الشاشة التالية
    expect(find.text('Next Screen'), findsOneWidget);
  });
}
