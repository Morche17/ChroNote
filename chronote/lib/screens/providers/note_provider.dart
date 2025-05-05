import 'package:flutter/material.dart';
import 'package:chronote/screens/models/note.dart';

class NoteProvider extends ChangeNotifier {
  List<String> themes = ['Trabajo', 'Personal', 'Estudio'];
  List<Note> notes = [];

  void addNote(String name, String content, List<String> selectedThemes) {
    for (var theme in selectedThemes) {
      if (!themes.contains(theme)) {
        themes.add(theme);
      }
      notes.add(Note(name: name, content: content, theme: theme));
    }
    notifyListeners();
  }

  void addTheme(String theme) {
    if (!themes.contains(theme)) {
      themes.add(theme);
      notifyListeners();
    }
  }
}
