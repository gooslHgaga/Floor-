import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:jhijri/jHijri.dart';
import 'prayer_times_service.dart';
import 'notification_service.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final prayerTimesService = Provider.of<PrayerTimesService>(context);
    final todayHijri = JHijri.now();

    return Scaffold(
      appBar: AppBar(
        title: Text('أوقات الصلاة - ${todayHijri.toFormat("dd/MM/yyyy")}'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          ListTile(
            leading: const Icon(Icons.wb_sunny),
            title: const Text('الفجر'),
            trailing: Text(prayerTimesService.fajrTime ?? '--:--'),
          ),
          ListTile(
            leading: const Icon(Icons.wb_sunny),
            title: const Text('الظهر'),
            trailing: Text(prayerTimesService.dhuhrTime ?? '--:--'),
          ),
          // أضف باقي الصلوات هنا بنفس الطريقة
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          NotificationService.schedulePrayerNotifications(prayerTimesService);
        },
        child: const Icon(Icons.notifications),
      ),
    );
  }
}
