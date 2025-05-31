import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:chronote/screens/providers/note_provider.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:chronote/utils/session_manager.dart';
import 'package:chronote/screens/splash_screen.dart';
import 'package:timezone/data/latest.dart' as tz;

// Instancia global para notificaciones locales
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Inicializar zonas horarias para las notificaciones programadas
  tz.initializeTimeZones();

  // Configuración inicial para Android (icono de notificación)
  const AndroidInitializationSettings androidInit =
      AndroidInitializationSettings('@mipmap/ic_launcher');

  const InitializationSettings initSettings =
      InitializationSettings(android: androidInit);

  // Inicializar plugin de notificaciones
  await flutterLocalNotificationsPlugin.initialize(initSettings);

  // Inicializar gestor de sesión para persistencia
  await SessionManager.init();

  // Ejecutar la app con proveedor de estado NoteProvider
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
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
    );
  }
}
