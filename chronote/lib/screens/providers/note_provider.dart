import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:chronote/screens/models/note.dart';
import 'package:chronote/services/theme_service.dart';
import 'package:chronote/screens/models/tema.dart';

class NoteProvider extends ChangeNotifier {
  List<Tema> themes = []; 
  List<Note> notes = [];

  Future<void> fetchThemes(int userId) async {
    try {
      final temas = await ThemeService.viewThemes(userId);
      themes = temas;
      notifyListeners();
    } catch (e) {
      print("Error al cargar temas: $e");
    }
  }
  //al final no se necesito
  static String fechaMariaDB() {
  final now = DateTime.now();
  final formatter = DateFormat('yyyy-MM-dd HH:mm:ss');
  return formatter.format(now);
}

  /* void addNote(String name, String content, List<String> selectedThemes) {
    for (var theme in selectedThemes) {
      // Si el tema no existe en la lista, lo agregamos
      if (!themes.any((t) => t.nombre == theme)) {
        themes.add(Tema(id: -1, nombre: theme)); // id -1 indica que es local
      }
      notes.add(Note(name: name, content: content, theme: theme));
    }
    notifyListeners();
  }


  void addTheme(String theme) {
    if (!themes.any((t) => t.nombre == theme)) {
      themes.add(Tema(id: -1, nombre: theme));
      notifyListeners();
    }
  }
  */
}