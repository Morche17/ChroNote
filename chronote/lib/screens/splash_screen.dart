import 'package:flutter/material.dart';
import 'package:chronote/screens/login_screen.dart';
import 'package:chronote/screens/main_screen.dart';
import 'package:chronote/utils/session_manager.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    final startTime = DateTime.now();

    try {
      // Ejecutar en paralelo: inicialización + delay mínimo de 2 segundos
      await Future.wait([
        _performInitializationTasks(),
        Future.delayed(const Duration(seconds: 2)),
      ]);
    } catch (e) {
      _handleError(e);
      return;
    }

    // Calcular tiempo restante para completar los 2 segundos mínimos
    final elapsed = DateTime.now().difference(startTime);
    if (elapsed < const Duration(seconds: 2)) {
      await Future.delayed(const Duration(seconds: 2) - elapsed);
    }

    _navigateToApp();
  }

  Future<void> _performInitializationTasks() async {
    await SessionManager.init();
    // Aquí se pueden añadir otras inicializaciones necesarias
  }

  Future<void> _navigateToApp() async {
    if (!mounted) return;

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

  void _handleError(dynamic error) {
    debugPrint('Error durante la inicialización: $error');
    if (!mounted) return;

    showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
            title: const Text('Error crítico'),
            content: const Text('No se pudo inicializar la aplicación'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  _initializeApp(); // Reintentar
                },
                child: const Text('Reintentar'),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
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
            const Text(
              'ChroNote',
              style: TextStyle(
                color: Colors.white,
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 40),
              child: Text(
                'Empieza a manejar tu tiempo de forma eficiente con nosotros!',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white70, fontSize: 16),
              ),
            ),
            const SizedBox(height: 20),
            const CircularProgressIndicator(color: Colors.white),
          ],
        ),
      ),
    );
  }
}
