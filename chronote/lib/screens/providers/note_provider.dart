import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:chronote/screens/models/note.dart';
import 'package:chronote/services/theme_service.dart';
import 'package:chronote/services/note_service.dart';
import 'package:chronote/screens/models/tema.dart';

/// Provider que gestiona el estado de los temas y notas en la aplicación
/// Extiende ChangeNotifier para notificar cambios a los widgets listeners
class NoteProvider extends ChangeNotifier {
  // Lista de temas disponibles
  List<Tema> themes = [];
  
  // Lista de notas cargadas
  List<Nota> notes = [];

  /// Carga los temas asociados a un usuario desde el servicio
  /// [userId] El ID del usuario cuyos temas se van a cargar
  Future<void> fetchThemes(int userId) async {
    try {
      final temas = await ThemeService.viewThemes(userId);
      themes = temas;
      notifyListeners(); // Notifica a los widgets suscritos
    } catch (e) {
      print("Error al cargar temas: $e");
    }
  }

  /// Carga las notas asociadas a un tema específico
  /// [temaId] El ID del tema cuyas notas se van a cargar
  Future<void> fetchNotasPorTema(int temaId) async {
    try {
      final notasObtenidas = await NoteService.getNotasPorTema(temaId);
      notes = notasObtenidas;
      notifyListeners();
    } catch (e) {
      print("Error al cargar notas: $e");
    }
  }

  /// Carga todos los temas y todas las notas de un usuario
  /// [userId] El ID del usuario cuyos datos se van a cargar
  Future<void> fetchAllThemesAndNotes(int userId) async {
    try {
      // 1. Cargar todos los temas del usuario
      final temasObtenidos = await ThemeService.viewThemes(userId);
      themes = temasObtenidos;

      List<Nota> todasLasNotas = [];

      // 2. Para cada tema, cargar sus notas
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

  /// Elimina una nota específica
  /// [temaId] ID del tema al que pertenece la nota
  /// [notaId] ID de la nota a eliminar
  Future<void> deleteNota(int temaId, int notaId) async {
    try {
      await NoteService.deleteNota(temaId, notaId);
      await fetchNotasPorTema(temaId); // Recarga las notas del tema
    } catch (e) {
      throw Exception("Error al eliminar nota: $e");
    }
  }

  /// Agrega un nuevo tema
  /// [userId] ID del usuario dueño del tema
  /// [nombre] Nombre del nuevo tema
  /// [poseeCalendario] Indica si el tema tendrá calendario asociado
  Future<void> addTema(int userId, String nombre, bool poseeCalendario) async {
    try {
      await ThemeService.addTheme(userId, nombre, poseeCalendario);
      await fetchThemes(userId); // Actualiza la lista de temas
    } catch (e) {
      throw Exception("Error al agregar tema: $e");
    }
  }

  /// Actualiza un tema existente
  /// [userId] ID del usuario dueño del tema
  /// [themeId] ID del tema a actualizar
  /// [nombre] Nuevo nombre para el tema
  /// [posee_calendario] Nuevo valor para el indicador de calendario
  Future<void> updateTheme(int userId, int themeId, String nombre, bool posee_calendario) async {
    try {
      await ThemeService.updateTheme(userId, themeId, nombre, posee_calendario);
      await fetchThemes(userId); // Actualiza la lista de temas
    } catch (e) {
      throw Exception("Error al actualizar nota: $e");
    }
  }

  /// Elimina un tema específico
  /// [userid] ID del usuario dueño del tema
  /// [temaId] ID del tema a eliminar
  Future<void> deleteTema(int userid, int temaId) async {
    try {
      await ThemeService.deleteTheme(userid, temaId);
      // Elimina el tema de la lista local sin necesidad de recargar
      themes.removeWhere((tema) => tema.id == temaId);
      notifyListeners();
    } catch (e) {
      throw Exception("Error al eliminar tema: $e");
    }
  }

  /// (Método no utilizado actualmente)
  /// Genera una cadena con el formato de fecha compatible con MariaDB
  static String fechaMariaDB() {
    final now = DateTime.now();
    final formatter = DateFormat('yyyy-MM-dd HH:mm:ss');
    return formatter.format(now);
  }
}