import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// import 'screens/main_screen.dart';
import 'package:chronote/screens/providers/note_provider.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:chronote/utils/session_manager.dart';
import 'package:chronote/screens/splash_screen.dart';
import 'package:timezone/data/latest.dart' as tz;



final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  tz.initializeTimeZones();
  const AndroidInitializationSettings androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');
  const InitializationSettings initSettings = InitializationSettings(android: androidInit);
  await flutterLocalNotificationsPlugin.initialize(initSettings);
  await SessionManager.init();
  runApp(
    ChangeNotifierProvider(
      create: (_) => NoteProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const SplashScreen(),
    );
  }
}
