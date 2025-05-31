import 'package:flutter/material.dart';
import 'package:chronote/services/auth_service.dart';
import 'package:chronote/utils/session_manager.dart';
import 'package:chronote/screens/main_screen.dart';
import 'package:chronote/screens/sign_up_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;

  Future<void> _login() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);
      try {
        final response = await AuthService.login(
          _emailController.text,
          _passwordController.text,
        );

        await SessionManager.saveSession(
          response['token'],
          response['usuario'],
        );

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const MainScreen()),
        );
      } catch (e) {
        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: const Text('Error'),
            content: Text(e.toString()),
          ),
        );
      } finally {
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
              const Text(
                "Iniciar Sesión",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text(
                "Inicia Sesión para continuar",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
              const SizedBox(height: 24),
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
              Row(
                children: [
                  Checkbox(value: true, onChanged: (value) {}),
                  const Text("Recordar sesión"),
                ],
              ),
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
