import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:chronote/utils/session_manager.dart';
import 'package:chronote/screens/models/tema.dart';
import 'package:chronote/screens/providers/note_provider.dart';

/// Pantalla para crear o editar un tema.
/// Si [tema] es proporcionado, se está editando un tema existente.
/// Si [tema] es null, se está creando uno nuevo.
class ThemeCreator extends StatefulWidget {
  final Tema? tema;

  const ThemeCreator({super.key, this.tema});

  @override
  State<ThemeCreator> createState() => _ThemeCreatorState();
}

class _ThemeCreatorState extends State<ThemeCreator> {
  late TextEditingController nameController; // Controlador del campo de nombre
  bool poseeCalendario = false; // Valor del checkbox "Posee calendario"

  @override
  void initState() {
    super.initState();
    // Si se está editando un tema, inicializa los valores
    nameController = TextEditingController(text: widget.tema?.nombre ?? '');
    poseeCalendario = widget.tema?.poseeCalendario ?? false;
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.tema != null; // Saber si es modo edición

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
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Campo de texto para el nombre del tema
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

            // Checkbox para indicar si el tema tiene calendario
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

            // Botón para guardar el tema
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
    );
  }

  /// Guarda el tema actual (creación o edición)
  Future<void> _saveTheme() async {
    final nombre = nameController.text.trim();
    final calendario = poseeCalendario;
    final noteProvider = Provider.of<NoteProvider>(context, listen: false);
    final userId = await SessionManager.getUserId(); // Obtiene el ID del usuario logueado

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
        // Si es un nuevo tema
        await noteProvider.addTema(userId, nombre, calendario);
        _showMessage("Tema creado exitosamente");
      } else {
        // Si es una edición de tema existente
        await noteProvider.updateTheme(userId, widget.tema!.id, nombre, calendario);
        _showMessage("Tema actualizado exitosamente");
      }

      if (mounted) Navigator.pop(context); // Vuelve a la pantalla anterior
    } catch (e) {
      _showMessage("Error: $e", isError: true); // Muestra error
    }
  }

  /// Muestra un mensaje en pantalla inferior con color según éxito o error
  void _showMessage(String mensaje, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(mensaje),
        backgroundColor: isError ? Colors.red : Colors.green,
      ),
    );
  }
}
