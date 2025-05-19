import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:chronote/screens/models/tema.dart';

class ThemeService {
  static const String baseUrl = 'https://clever-globally-doberman.ngrok-free.app/api/v1';

  static Future<List<Tema>> viewThemes(int userId) async {
    final response = await http.get(Uri.parse("$baseUrl/usuarios/$userId/temas"));
    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      return data.map((json) => Tema.fromJson(json)).toList();
    } else {
      throw Exception("Fallo al obtener temas");
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

}

