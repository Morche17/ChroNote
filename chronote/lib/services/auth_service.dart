import 'dart:convert'; // Para codificar/decodificar JSON
import 'package:http/http.dart' as http; // Cliente HTTP para peticiones a API REST

/// Servicio de autenticación que gestiona login y registro de usuarios.
class AuthService {
  // URL base del backend
  static const String baseUrl = 'https://clever-globally-doberman.ngrok-free.app/api/v1';

  /// Inicia sesión con el correo y contraseña proporcionados.
  ///
  /// Devuelve un [Map] con los datos de la respuesta si es exitosa.
  /// Lanza una excepción si hay un error en la petición.
  static Future<Map<String, dynamic>> login(String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/login'), // Endpoint de login
      headers: {'Content-Type': 'application/json'}, // Cabecera JSON
      body: jsonEncode({
        'correo': email,
        'password': password,
      }), // Cuerpo con credenciales codificadas en JSON
    );

    // Si la respuesta es exitosa, decodifica y retorna el cuerpo como mapa
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      // En caso de error, lanza una excepción con el mensaje del servidor
      throw Exception('Error en login: ${response.body}');
    }
  }

  /// Registra un nuevo usuario con nombre, correo y contraseña.
  ///
  /// Devuelve un [Map] con los datos del usuario registrado si es exitoso.
  /// Lanza una excepción si hay un error.
  static Future<Map<String, dynamic>> register(
    String name,
    String email,
    String password,
  ) async {
    final response = await http.post(
      Uri.parse('$baseUrl/usuarios'), // Endpoint de registro
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'usuario': {
          'nombre': name,
          'correo': email,
          'contrasena': password,
        },
      }), // JSON con los datos del nuevo usuario
    );

    // Si el registro fue exitoso (código 201), retorna los datos
    if (response.statusCode == 201) {
      return jsonDecode(response.body);
    } else {
      // En caso de error, lanza una excepción con el mensaje del servidor
      throw Exception('Error en registro: ${response.body}');
    }
  }
}
