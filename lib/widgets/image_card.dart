import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // لإصلاح Clipboard
import 'package:intl/intl.dart';
import '../models/image_item.dart';

typedef OnUpdate = void Function(ImageItem item);
typedef OnDelete = void Function(ImageItem item);
typedef OnExtract = void Function(ImageItem item);
typedef OnCopy = void Function(String text); // ✅ إضافة onCopy

class ImageCard extends StatelessWidget {
  final ImageItem item;
  final OnUpdate onUpdate;
  final OnDelete onDelete;
  final OnExtract onExtract;
  final OnCopy? onCopy; // اختياري

  const ImageCard({
    super.key,
    required this.item,
    required this.onUpdate,
    required this.onDelete,
    required this.onExtract,
    this.onCopy,
  });

  String arabicWeekday(DateTime dt) {
    const names = {
      1: 'الاثنين',
      2: 'الثلاثاء',
      3: 'الأربعاء',
      4: 'الخميس',
      5: 'الجمعة',
      6: 'السبت',
      7: 'الأحد',
    };
    final name = names[dt.weekday] ?? '';
    return 'يوم $name';
  }

  @override
  Widget build(BuildContext context) {
    final dt = item.capturedAt;
    final dateStr = DateFormat('yyyy-MM-dd – HH:mm').format(dt);

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // معاينة الصورة
            AspectRatio(
              aspectRatio: 16 / 9,
              child: Image.file(
                File(item.path),
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) =>
                    const Center(child: Icon(Icons.broken_image)),
              ),
            ),
            const SizedBox(height: 8),
            // التاريخ واليوم بالعربية
            Text(
              '$dateStr — ${arabicWeekday(dt)}',
              style: const TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 8),
            // الرقم المستخرج + زر النسخ والاستخراج
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    'الرقم: ${item.extractedNumber.isEmpty ? '-' : item.extractedNumber}',
                  ),
                ),
                Row(
                  children: [
                    IconButton(
                      tooltip: 'استخراج الرقم',
                      onPressed: () => onExtract(item),
                      icon: const Icon(Icons.find_in_page),
                    ),
                    IconButton(
                      tooltip: 'نسخ الرقم',
                      onPressed: item.extractedNumber.isEmpty
                          ? null
                          : () {
                              if (onCopy != null) {
                                onCopy!(item.extractedNumber);
                              } else {
                                Clipboard.setData(
                                  ClipboardData(text: item.extractedNumber),
                                );
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('تم نسخ الرقم'),
                                  ),
                                );
                              }
                            },
                      icon: const Icon(Icons.copy),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 8),
            // ثلاثة صناديق الاختيار
            Row(
              children: [
                Expanded(
                  child: CheckboxListTile(
                    contentPadding: EdgeInsets.zero,
                    title: const Text('كرت عبد الله'),
                    value: item.cardAbdullah,
                    onChanged: (v) {
                      final newItem = ImageItem.fromMap(item.toMap());
                      newItem.cardAbdullah = v ?? false;
                      onUpdate(newItem);
                    },
                  ),
                ),
                Expanded(
                  child: CheckboxListTile(
                    contentPadding: EdgeInsets.zero,
                    title: const Text('كرت وليد'),
                    value: item.cardWalid,
                    onChanged: (v) {
                      final newItem = ImageItem.fromMap(item.toMap());
                      newItem.cardWalid = v ?? false;
                      onUpdate(newItem);
                    },
                  ),
                ),
                Expanded(
                  child: CheckboxListTile(
                    contentPadding: EdgeInsets.zero,
                    title: const Text('كرت عمار'),
                    value: item.cardAmr,
                    onChanged: (v) {
                      final newItem = ImageItem.fromMap(item.toMap());
                      newItem.cardAmr = v ?? false;
                      onUpdate(newItem);
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            // زر الحذف مع تأكيد
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton.icon(
                  icon: const Icon(Icons.delete_forever),
                  label: const Text('حذف'),
                  onPressed: () async {
                    final ok = await showDialog<bool>(
                      context: context,
                      builder: (_) => AlertDialog(
                        title: const Text('تأكيد الحذف'),
                        content: const Text(
                            'هل أنت متأكد أنك تريد حذف هذه الصورة؟'),
                        actions: [
                          TextButton(
                              onPressed: () => Navigator.pop(context, false),
                              child: const Text('إلغاء')),
                          TextButton(
                              onPressed: () => Navigator.pop(context, true),
                              child: const Text('حذف')),
                        ],
                      ),
                    );
                    if (ok == true) onDelete(item);
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
