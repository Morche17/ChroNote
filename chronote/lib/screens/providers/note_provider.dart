import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:chronote/screens/models/note.dart';
import 'package:chronote/services/theme_service.dart';
import 'package:chronote/services/note_service.dart';
import 'package:chronote/screens/models/tema.dart';

class NoteProvider extends ChangeNotifier {
  List<Tema> themes = [];
  List<Nota> notes = [];

  Future<void> fetchThemes(int userId) async {
    try {
      final temas = await ThemeService.viewThemes(userId);
      themes = temas;
      notifyListeners();
    } catch (e) {
      print("Error al cargar temas: $e");
    }
  }

  Future<void> fetchNotasPorTema(int temaId) async {
    try {
      final notasObtenidas = await NoteService.getNotasPorTema(temaId);
      notes = notasObtenidas;
      notifyListeners();
    } catch (e) {
      print("Error al cargar notas: $e");
    }
  }

  Future<void> fetchAllThemesAndNotes(int userId) async {
    try {
      final temasObtenidos = await ThemeService.viewThemes(userId);
      themes = temasObtenidos;

      List<Nota> todasLasNotas = [];

      for (final tema in temasObtenidos) {
        try {
          final notasDelTema = await NoteService.getNotasPorTema(tema.id);
          todasLasNotas.addAll(notasDelTema);
        } catch (e) {
          print("Error al cargar notas del tema ${tema.id}: $e");
        }
      }

      notes = todasLasNotas;
      notifyListeners();
    } catch (e) {
      print("Error al cargar temas y notas: $e");
    }
  }

  Future<void> deleteNota(int temaId, int notaId) async {
    try {
      await NoteService.deleteNota(temaId, notaId);
      await fetchNotasPorTema(temaId);
    } catch (e) {
      throw Exception("Error al eliminar nota: $e");
    }
  }

  Future<void> addTema(int userId, String nombre, bool poseeCalendario) async {
    try {
      await ThemeService.addTheme(userId, nombre, poseeCalendario);
      await fetchThemes(userId); // Refresca la lista de temas
    } catch (e) {
      throw Exception("Error al agregar tema: $e");
    }
  }

  Future<void> updateTheme( int userId, int themeId, String nombre, bool posee_calendario ) async {
    try {
      await ThemeService.updateTheme(userId, themeId, nombre, posee_calendario);
      await fetchThemes(userId); // Refresca la lista
    } catch (e) {
      throw Exception("Error al actualizar nota: $e");
    }
  }

  Future<void> deleteTema(int userid, int temaId) async {
    try {
      await ThemeService.deleteTheme(userid, temaId);
      themes.removeWhere((tema) => tema.id == temaId);
      notifyListeners();
    } catch (e) {
      throw Exception("Error al eliminar tema: $e");
    }
  }

  //al final no se necesito
  static String fechaMariaDB() {
    final now = DateTime.now();
    final formatter = DateFormat('yyyy-MM-dd HH:mm:ss');
    return formatter.format(now);
  }

}
