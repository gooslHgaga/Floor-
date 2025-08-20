import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:adan/providers/settings_provider.dart';
import 'package:adan/providers/prayer_times_provider.dart';
import 'package:adan/views/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => SettingsProvider()),
        ChangeNotifierProvider(create: (_) => PrayerTimesProvider()),
      ],
      child: const AdanApp(),
    ),
  );
}

class AdanApp extends StatelessWidget {
  const AdanApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'أوقات الأذن',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        colorScheme: ColorScheme.dark(
          primary: const Color(0xff1e3a8a),
          secondary: const Color(0xff34d399),
        ),
      ),
      home: const HomeScreen(),
    );
  }
}
