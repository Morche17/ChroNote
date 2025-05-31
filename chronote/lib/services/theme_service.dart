import 'dart:convert'; // Para manejo de JSON
import 'package:http/http.dart' as http; // Cliente HTTP para peticiones
import 'package:chronote/screens/models/tema.dart'; // Modelo Tema

/// Servicio para manejar operaciones relacionadas con temas (themes).
class ThemeService {
  // URL base de la API
  static const String baseUrl = 'https://clever-globally-doberman.ngrok-free.app/api/v1';

  /// Obtiene la lista de temas de un usuario dado [userId].
  ///
  /// Retorna una lista de objetos Tema.
  static Future<List<Tema>> viewThemes(int userId) async {
    final response = await http.get(
      Uri.parse("$baseUrl/usuarios/$userId/temas"),
      headers: {'Content-Type': 'application/json'},
    );

    // Si la respuesta es exitosa, decodifica la lista y la convierte a objetos Tema
    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      print(data); // Para debug: imprime los datos recibidos
      return data.map((json) => Tema.fromJson(json)).toList();
    } else {
      // Si falla, lanza excepción con el mensaje de error
      throw Exception("Fallo al obtener temas: ${response.body}");
    }
  }

  /// Crea un nuevo tema para un usuario especificado con [usuarioId].
  ///
  /// Se requiere el nombre del tema [nombre] y si posee calendario [poseeCalendario].
  /// Retorna un mapa con la información del tema creado.
  static Future<Map<String, dynamic>> addTheme(
      int usuarioId, String nombre, bool poseeCalendario) async {
    final response = await http.post(
      Uri.parse("$baseUrl/usuarios/$usuarioId/temas"),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'tema': {'nombre': nombre, 'posee_calendario': poseeCalendario}
      }),
    );

    // Si la creación fue exitosa (201), retorna el JSON decodificado
    if (response.statusCode == 201) {
      return jsonDecode(response.body);
    } else {
      // En caso contrario, lanza excepción con el mensaje recibido
      throw Exception('Error en registro de tema: ${response.body}');
    }
  }

  /// Actualiza un tema existente con [temaId] para un usuario [usuarioId].
  ///
  /// Se actualizan el nombre [nombre] y si posee calendario [poseeCalendario].
  /// Retorna un mapa con la información actualizada del tema.
  static Future<Map<String, dynamic>> updateTheme(
      int usuarioId, int temaId, String nombre, bool poseeCalendario) async {
    final response = await http.patch(
      Uri.parse("$baseUrl/usuarios/$usuarioId/temas/$temaId"),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'tema': {'nombre': nombre, 'posee_calendario': poseeCalendario}
      }),
    );

    // Si la actualización fue exitosa (200), retorna el JSON decodificado
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      // Si falla, lanza excepción con mensaje de error
      throw Exception('Error al actualizar el tema: ${response.body}');
    }
  }

  /// Elimina un tema con [temaId] para el usuario [usuarioId].
  ///
  /// No retorna datos, pero lanza excepción si no se recibe el código 204 (sin contenido)
  static Future<void> deleteTheme(int usuarioId, int temaId) async {
    final response = await http.delete(
      Uri.parse("$baseUrl/usuarios/$usuarioId/temas/$temaId"),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode != 204) {
      throw Exception('Error al eliminar el tema: ${response.body}');
    }
  }
}
