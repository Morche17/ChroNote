import 'package:flutter/material.dart';
import 'package:chronote/services/auth_service.dart';
import 'package:chronote/screens/login_screen.dart';

/// Pantalla de registro de nuevos usuarios
class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  // Clave global para validar el formulario
  final _formKey = GlobalKey<FormState>();

  // Controladores para los campos de texto
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  // Estado de carga y aceptación de términos
  bool _isLoading = false;
  bool _acceptTerms = false;

  /// Intenta registrar al usuario usando AuthService
  Future<void> _register() async {
    // Validar formulario y aceptar términos
    if (_formKey.currentState!.validate() && _acceptTerms) {
      setState(() => _isLoading = true);
      try {
        // Llamada al servicio de autenticación para registrar
        await AuthService.register(
          _nameController.text,
          _emailController.text,
          _passwordController.text,
        );

        // Volver a la pantalla anterior después del registro exitoso
        Navigator.pop(context);
      } catch (e) {
        // Mostrar un diálogo de error en caso de fallo
        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: const Text('Error'),
            content: Text(e.toString()),
          ),
        );
      } finally {
        // Restablecer el estado de carga si el widget aún está montado
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
              // Título
              const Text(
                "Crear Cuenta",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text(
                "Crea tu cuenta para empezar",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
              const SizedBox(height: 24),

              // Campo: Nombre
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.person),
                  labelText: "Nombre",
                  border: OutlineInputBorder(),
                ),
                validator: (value) =>
                    value!.isEmpty ? 'Ingrese su nombre' : null,
              ),
              const SizedBox(height: 16),

              // Campo: Correo electrónico
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.email),
                  labelText: "Dirección de Correo Electrónico",
                  border: OutlineInputBorder(),
                ),
                validator: (value) =>
                    value!.isEmpty ? 'Ingrese su email' : null,
              ),
              const SizedBox(height: 16),

              // Campo: Contraseña
              TextFormField(
                controller: _passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.lock),
                  labelText: "Crear Contraseña",
                  border: OutlineInputBorder(),
                ),
                validator: (value) =>
                    value!.isEmpty ? 'Ingrese su contraseña' : null,
              ),
              const SizedBox(height: 16),

              // Campo: Repetir contraseña
              TextFormField(
                obscureText: true,
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.lock),
                  labelText: "Repetir Contraseña",
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value != _passwordController.text) {
                    return 'Las contraseñas no coinciden';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 8),

              // Checkbox de términos y condiciones
              CheckboxListTile(
                title: const Text("Acepto Términos y Condiciones"),
                value: _acceptTerms,
                onChanged: (value) =>
                    setState(() => _acceptTerms = value!),
                controlAffinity: ListTileControlAffinity.leading,
              ),

              // Botón de carga o de registro
              _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      onPressed: _register,
                      child: const Text(
                        "Crear Cuenta",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
              const SizedBox(height: 16),

              // Enlace para ir a la pantalla de inicio de sesión
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const LoginScreen()),
                  );
                },
                child: const Text(
                  "¿Ya estás registrado? Iniciar Sesión",
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
