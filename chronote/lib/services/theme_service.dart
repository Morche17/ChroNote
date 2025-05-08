import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:chronote/screens/models/tema.dart';

class ThemeService {
  static const String baseUrl = 'https://barnacle-selected-toad.ngrok-free.app/api/v1';

  static Future<List<Tema>> viewThemes(int userId) async {
    final response = await http.get(Uri.parse("$baseUrl/usuarios/$userId/temas"));
    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      return data.map((json) => Tema.fromJson(json)).toList();
    } else {
      throw Exception("Fallo al obtener temas");
    }
  }

}
