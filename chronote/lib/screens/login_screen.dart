import 'package:flutter/material.dart';
import 'package:chronote/services/auth_service.dart';
import 'package:chronote/utils/session_manager.dart';
import 'package:chronote/screens/main_screen.dart';
import 'package:chronote/screens/sign_up_screen.dart';

/// Pantalla de inicio de sesión que permite a los usuarios autenticarse
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // Clave global para el formulario de login
  final _formKey = GlobalKey<FormState>();
  
  // Controladores para los campos de texto
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  
  // Estado para controlar la visualización del indicador de carga
  bool _isLoading = false;

  /// Método para realizar el proceso de autenticación
  Future<void> _login() async {
    // Valida los campos del formulario
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true); // Activa el indicador de carga
      
      try {
        // Intenta autenticar al usuario mediante el AuthService
        final response = await AuthService.login(
          _emailController.text,
          _passwordController.text,
        );

        // Guarda la sesión del usuario si la autenticación es exitosa
        await SessionManager.saveSession(
          response['token'],
          response['usuario'],
        );

        // Navega a la pantalla principal
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const MainScreen()),
        );
      } catch (e) {
        // Muestra un diálogo de error si falla la autenticación
        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: const Text('Error'),
            content: Text(e.toString()),
          ),
        );
      } finally {
        // Desactiva el indicador de carga
        if (mounted) setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Título de la pantalla
              const Text(
                "Iniciar Sesión",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              // Subtítulo descriptivo
              const Text(
                "Inicia Sesión para continuar",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
              const SizedBox(height: 24),
              
              // Campo de entrada para el email
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.email),
                  labelText: "Dirección de Correo Electrónico",
                  border: OutlineInputBorder(),
                ),
                validator: (value) => value!.isEmpty ? 'Ingrese su email' : null,
              ),
              const SizedBox(height: 16),
              
              // Campo de entrada para la contraseña
              TextFormField(
                controller: _passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.lock),
                  labelText: "Contraseña",
                  border: OutlineInputBorder(),
                ),
                validator: (value) => value!.isEmpty ? 'Ingrese su contraseña' : null,
              ),
              const SizedBox(height: 8),
              
              // Checkbox para recordar sesión (actualmente no funcional)
              Row(
                children: [
                  Checkbox(value: true, onChanged: (value) {}),
                  const Text("Recordar sesión"),
                ],
              ),
              
              // Botón de login o indicador de carga
              _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      onPressed: _login,
                      child: const Text(
                        "Iniciar Sesión",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
              const SizedBox(height: 16),
              
              // Enlace para redirigir a la pantalla de registro
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const SignUpScreen()),
                  );
                },
                child: const Text(
                  "¿No estás registrado? Regístrate",
                  style: TextStyle(color: Colors.blue),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}