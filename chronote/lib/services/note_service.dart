import 'dart:convert'; // Para codificar y decodificar JSON
import 'package:http/http.dart' as http; // Cliente HTTP para hacer peticiones al backend
import 'package:chronote/screens/models/note.dart'; // Modelo de datos de Nota
import 'package:chronote/utils/session_manager.dart'; // Utilidad para manejar la sesión del usuario

/// Servicio que gestiona las operaciones relacionadas con las notas.
class NoteService {
  // URL base de la API
  static const String baseUrl = 'https://clever-globally-doberman.ngrok-free.app/api/v1';

  /// Crea una nueva nota en un tema específico del usuario actual.
  ///
  /// Requiere el [temaId], el [nombre], la [descripcion] y la [fecha_notificacion] en formato String.
  /// Devuelve un mapa con los datos de la nota creada si la operación es exitosa.
  static Future<Map<String, dynamic>> addNote(
    int temaId,
    String nombre,
    String descripcion,
    String fecha_notificacion,
  ) async {
    final token = await SessionManager.getToken(); // Token de sesión para autorización

    // Petición POST al endpoint correspondiente con el cuerpo en JSON
    final response = await http.post(
      Uri.parse(
        "$baseUrl/usuarios/${await SessionManager.getUserId()}/temas/$temaId/notas",
      ),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'nota': {
          'nombre': nombre,
          'descripcion': descripcion,
          'fecha_notificacion': fecha_notificacion,
        },
      }),
    );

    // Si fue creada exitosamente (201), retorna los datos
    if (response.statusCode == 201) {
      return jsonDecode(response.body);
    } else {
      // Si hay error, lanza una excepción con el mensaje del backend
      throw Exception('Error en registro de nota: ${response.body}');
    }
  }

  /// Obtiene todas las notas asociadas a un [temaId] específico del usuario.
  ///
  /// Devuelve una lista de objetos [Nota] si la respuesta es exitosa.
  static Future<List<Nota>> getNotasPorTema(int temaId) async {
    final token = await SessionManager.getToken(); // Token para autorización

    final response = await http.get(
      Uri.parse('$baseUrl/usuarios/${await SessionManager.getUserId()}/temas/$temaId/notas'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    // Si la respuesta fue exitosa (200), decodifica y transforma los datos en objetos Nota
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => Nota.fromJson(json)).toList();
    } else {
      // Si hay error, lanza una excepción con el mensaje recibido
      throw Exception('Error al obtener notas: ${response.body}');
    }
  }

  /// Elimina una nota específica usando su [notaId] y el [temaId] al que pertenece.
  ///
  /// No retorna nada. Lanza una excepción si hay un error.
  static Future<void> deleteNota(int temaId, int notaId) async {
    final token = await SessionManager.getToken(); // Obtener token de sesión

    final response = await http.delete(
      Uri.parse(
        '$baseUrl/usuarios/${await SessionManager.getUserId()}/temas/$temaId/notas/$notaId',
      ),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    // Aquí no se valida el código de estado porque no hay retorno.
    // Se podría agregar manejo de errores si es necesario.
  }
}
