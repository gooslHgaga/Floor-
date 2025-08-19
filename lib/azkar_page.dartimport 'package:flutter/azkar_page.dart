import 'package:flutter/material.dart';

class AzkarPage extends StatelessWidget {
  final String prayerName;
  const AzkarPage({super.key, required this.prayerName});

  @override
  Widget build(BuildContext context) {
    final azkar = {
      'الفجر': ['سبحان الله', 'الحمد لله', 'لا إله إلا الله'],
      'الظهر': ['أستغفر الله', 'اللهم زدني', 'الحمد لله'],
      'العصر': ['سبحان الله', 'الحمد لله', 'اللهم اجعلنا'],
      'المغرب': ['سبحان الله', 'الحمد لله', 'أستغفر الله'],
      'العشاء': ['سبحان الله', 'الحمد لله', 'لا إله إلا الله'],
    };

    return Scaffold(
      appBar: AppBar(title: Text('أذكار $prayerName')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: azkar[prayerName]?.length ?? 0,
          itemBuilder: (_, index) {
            return Card(
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Text(
                  azkar[prayerName]![index],
                  style: const TextStyle(fontSize: 18),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
