import 'package:flutter/material.dart';
import 'package:chronote/screens/login_screen.dart';
import 'package:chronote/screens/main_screen.dart';
import 'package:chronote/utils/session_manager.dart';

/// Pantalla de inicio (splash screen) que se muestra al abrir la app.
/// Realiza tareas de inicialización y redirige al usuario a la pantalla correspondiente.
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _initializeApp(); // Lanza la inicialización al iniciar el widget
  }

  /// Realiza la inicialización de la app y espera al menos 2 segundos
  Future<void> _initializeApp() async {
    final startTime = DateTime.now(); // Marca el inicio para medir duración

    try {
      // Ejecuta en paralelo la inicialización y el tiempo mínimo de espera
      await Future.wait([
        _performInitializationTasks(),
        Future.delayed(const Duration(seconds: 2)),
      ]);
    } catch (e) {
      _handleError(e); // Maneja cualquier error que ocurra
      return;
    }

    // Calcula si se necesita esperar más tiempo para completar los 2 segundos
    final elapsed = DateTime.now().difference(startTime);
    if (elapsed < const Duration(seconds: 2)) {
      await Future.delayed(const Duration(seconds: 2) - elapsed);
    }

    _navigateToApp(); // Navega a la pantalla correspondiente
  }

  /// Realiza las tareas de inicialización necesarias antes de mostrar la app
  Future<void> _performInitializationTasks() async {
    await SessionManager.init(); // Inicializa la sesión del usuario
    // Aquí puedes agregar más tareas de inicialización si lo necesitas
  }

  /// Redirige al usuario a MainScreen si está logueado, o a LoginScreen si no
  Future<void> _navigateToApp() async {
    if (!mounted) return; // Verifica que el widget aún está en pantalla

    final isLoggedIn = await SessionManager.isLoggedIn();
    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => isLoggedIn ? const MainScreen() : const LoginScreen(),
        ),
      );
    }
  }

  /// Muestra un diálogo de error si falla la inicialización
  void _handleError(dynamic error) {
    debugPrint('Error durante la inicialización: $error');
    if (!mounted) return;

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Error crítico'),
        content: const Text('No se pudo inicializar la aplicación'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Cierra el diálogo
              _initializeApp(); // Reintenta la inicialización
            },
            child: const Text('Reintentar'),
          ),
        ],
      ),
    );
  }

  /// Interfaz del splash screen con animación, logo y cargador
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Animación de aparición y escalado del logo
            TweenAnimationBuilder(
              tween: Tween<double>(begin: 0, end: 1),
              duration: const Duration(milliseconds: 1500),
              builder: (context, value, child) {
                return Opacity(
                  opacity: value,
                  child: Transform.scale(scale: value, child: child),
                );
              },
              child: Image.asset('assets/logo.png', width: 80, height: 80),
            ),
            const SizedBox(height: 20),

            // Nombre de la app
            const Text(
              'ChroNote',
              style: TextStyle(
                color: Colors.white,
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),

            // Descripción corta
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 40),
              child: Text(
                'Empieza a manejar tu tiempo de forma eficiente con nosotros!',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white70, fontSize: 16),
              ),
            ),
            const SizedBox(height: 20),

            // Indicador de carga
            const CircularProgressIndicator(color: Colors.white),
          ],
        ),
      ),
    );
  }
}
