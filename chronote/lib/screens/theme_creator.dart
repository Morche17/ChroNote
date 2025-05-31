import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:chronote/utils/session_manager.dart';
import 'package:chronote/screens/models/tema.dart';
import 'package:chronote/screens/providers/note_provider.dart';

class ThemeCreator extends StatefulWidget {
  final Tema? tema;

  const ThemeCreator({super.key, this.tema});

  @override
  State<ThemeCreator> createState() => _ThemeCreatorState();
}

class _ThemeCreatorState extends State<ThemeCreator> {
  late TextEditingController nameController;
  bool poseeCalendario = false;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.tema?.nombre ?? '');
    poseeCalendario = widget.tema?.poseeCalendario ?? false;
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.tema != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          isEditing ? "Editar Tema" : "Crear Tema",
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
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
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: nameController,
              decoration: InputDecoration(
                labelText: "Nombre del tema",
                filled: true,
                fillColor: Colors.grey[100],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Checkbox(
                  value: poseeCalendario,
                  onChanged: (value) {
                    setState(() {
                      poseeCalendario = value ?? false;
                    });
                  },
                ),
                const Text("Posee calendario"),
              ],
            ),
            const Spacer(),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                padding: const EdgeInsets.symmetric(vertical: 16),
                minimumSize: const Size(double.infinity, 48),
              ),
              onPressed: _saveTheme,
              child: const Text(
                "Guardar Tema",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
      backgroundColor: Colors.white,
    );
  }

  Future<void> _saveTheme() async {
    final nombre = nameController.text.trim();
    final calendario = poseeCalendario;
    final noteProvider = Provider.of<NoteProvider>(context, listen: false);
    final userId = await SessionManager.getUserId();

    if (userId == null) {
      _showMessage("ID de usuario no disponible", isError: true);
      return;
    }

    if (nombre.isEmpty) {
      _showMessage("El nombre del tema no puede estar vacío", isError: true);
      return;
    }

    try {
      if (widget.tema == null) {
        await noteProvider.addTema(userId, nombre, calendario);
        _showMessage("Tema creado exitosamente");
      } else {
        await noteProvider.updateTheme(userId, widget.tema!.id, nombre, calendario);
        _showMessage("Tema actualizado exitosamente");
      }

      if (mounted) Navigator.pop(context);
    } catch (e) {
      _showMessage("Error: $e", isError: true);
    }
  }

  void _showMessage(String mensaje, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(mensaje),
        backgroundColor: isError ? Colors.red : Colors.green,
      ),
    );
  }
}
