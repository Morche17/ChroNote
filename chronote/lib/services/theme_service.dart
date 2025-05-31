import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:chronote/screens/models/tema.dart';

class ThemeService {
  static const String baseUrl = 'https://clever-globally-doberman.ngrok-free.app/api/v1';

  static Future<List<Tema>> viewThemes(int userId) async {
  final response = await http.get(
    Uri.parse("$baseUrl/usuarios/$userId/temas"),
    headers: {'Content-Type': 'application/json'},
  );

  if (response.statusCode == 200) {
    final List data = jsonDecode(response.body);
    print(data);
    return data.map((json) => Tema.fromJson(json)).toList();
  } else {
    throw Exception("Fallo al obtener temas: ${response.body}");
  }
}

  static Future<Map<String, dynamic>> addTheme(
      int usuarioId, String nombre, bool poseeCalendario) async {
    final response = await http.post(
      Uri.parse("$baseUrl/usuarios/$usuarioId/temas"),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'tema': {'nombre': nombre, 'posee_calendario': poseeCalendario }
      }),
    );

    if (response.statusCode == 201) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Error en registro de tema: ${response.body}');
    }
  }

  static Future<Map<String, dynamic>> updateTheme(
      int usuarioId, int temaId, String nombre, bool poseeCalendario) async {
      final response = await http.patch(
        Uri.parse("$baseUrl/usuarios/$usuarioId/temas/$temaId"),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'tema': {'nombre': nombre, 'posee_calendario': poseeCalendario}
      }),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Error al actualizar el tema: ${response.body}');
      }
    }

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

