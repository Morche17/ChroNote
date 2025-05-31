import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:chronote/screens/models/note.dart';
import 'package:chronote/utils/session_manager.dart';

class NoteService {
  static const String baseUrl = 'https://clever-globally-doberman.ngrok-free.app/api/v1';

  static Future<Map<String, dynamic>> addNote(
    int temaId, String nombre, String descripcion, String fecha_notificacion) async {
    final token = await SessionManager.getToken();
    
    final response = await http.post(
      Uri.parse("$baseUrl/usuarios/${await SessionManager.getUserId()}/temas/$temaId/notas"),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'nota': {
          'nombre': nombre, 
          'descripcion': descripcion, 
          'fecha_notificacion': fecha_notificacion
        }
      }),
    );

    if (response.statusCode == 201) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Error en registro de nota: ${response.body}');
    }
  }
  
  static Future<List<Nota>> getNotasPorTema(int temaId) async {
    final token = await SessionManager.getToken();
    
    final response = await http.get(
      Uri.parse('$baseUrl/usuarios/${await SessionManager.getUserId()}/temas/$temaId/notas'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => Nota.fromJson(json)).toList();
    } else {
      throw Exception('Error al obtener notas: ${response.body}');
    }
  }
  
  static Future<void> deleteNota(int temaId, int notaId) async {
    final token = await SessionManager.getToken();
    
    final response = await http.delete(
      Uri.parse('$baseUrl/usuarios/${await SessionManager.getUserId()}/temas/$temaId/notas/$notaId'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
  }
}

