import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:chronote/screens/providers/note_provider.dart';

class NoteCreator extends StatefulWidget {
  const NoteCreator({super.key});

  @override
  State<NoteCreator> createState() => _NoteCreatorState();
}

class _NoteCreatorState extends State<NoteCreator> {
  List<String> allThemes = ['Trabajo', 'Personal', 'Estudio'];
  List<String> selectedThemes = [];
  TextEditingController noteController = TextEditingController();
  TextEditingController nameController = TextEditingController();

  /* void _addNewTheme() {
  String newTheme = '';
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Agregar nuevo tema'),
      content: TextField(
        autofocus: true,
        onChanged: (value) => newTheme = value,
        decoration: const InputDecoration(hintText: 'Nombre del tema'),
      ),
      actions: [
        TextButton(
          onPressed: () {
            if (newTheme.isNotEmpty && !allThemes.contains(newTheme)) {
              setState(() {
                allThemes.add(newTheme);
              });
              Provider.of<NoteProvider>(context, listen: false).addTheme(newTheme);
            }
            Navigator.pop(context);
          },
          child: const Text('Agregar'),
        ),
      ],
    ),
  );
}


  void _saveNote() {
    final name = nameController.text;
    final content = noteController.text;

    if (selectedThemes.isNotEmpty && name.isNotEmpty && content.isNotEmpty) {
      // Agregar la nota al NoteProvider
      Provider.of<NoteProvider>(context, listen: false)
          .addNote(name, content, selectedThemes);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Nota "$name" creada con temas: ${selectedThemes.join(", ")}')),
      );

      // Limpiar los campos después de guardar
      nameController.clear();
      noteController.clear();
      setState(() {
        selectedThemes.clear();
      });
    }
  } */

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Note Creator",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        elevation: 0.5,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: [
            Expanded(
              child: ListView(
                children: [
                  TextField(
                    controller: nameController,
                    decoration: InputDecoration(
                      hintText: "Nombre",
                      filled: true,
                      fillColor: Colors.grey[100],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  const Text("Tema"),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    children: allThemes.map((theme) {
                      final isSelected = selectedThemes.contains(theme);
                      return FilterChip(
                        label: Text(theme),
                        selected: isSelected,
                        onSelected: (_) => _toggleThemeSelection(theme),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 8),
                  /* TextButton.icon(
                    onPressed:,
                    icon: const Icon(Icons.add),
                    label: const Text('Agregar nuevo tema'),
                  ),
                  const SizedBox(height: 24), */

                  const Text("Contenido de la nota"),
                  const SizedBox(height: 8),
                  TextField(
                    controller: noteController,
                    maxLines: 6,
                    decoration: InputDecoration(
                      hintText: "Ingresa tu nota",
                      filled: true,
                      fillColor: Colors.grey[100],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            /* ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                padding: const EdgeInsets.symmetric(vertical: 16),
                minimumSize: const Size(double.infinity, 48),
              ),
              onPressed: _saveNote,
              child: const Text(
                "Crear Nota",
                style: TextStyle(color: Colors.white),
              ),
            ), */
            const SizedBox(height: 16),
          ],
        ),
      ),
      backgroundColor: Colors.white,
    );
  }
  void _toggleThemeSelection(String theme) {
  setState(() {
    if (selectedThemes.contains(theme)) {
      selectedThemes.remove(theme);
    } else {
      selectedThemes.add(theme);
    }
  });
}
}
