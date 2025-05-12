import 'dart:convert';
import 'package:http/http.dart' as http;

class NoteService {
  static const String baseUrl = 'https://barnacle-selected-toad.ngrok-free.app/api/v1';

  static Future<Map<String, dynamic>> addNote(
      int temaId, String nombre, String descripcion, String fecha_notificacion ) async {
    final response = await http.post(
      Uri.parse("$baseUrl/temas/$temaId/notas"),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'nota': {'nombre': nombre, 'descripcion': descripcion, 'fecha_notificacion': fecha_notificacion}
      }),
    );

    if (response.statusCode == 201) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Error en registro de nota: ${response.body}');
    }
  }

}

