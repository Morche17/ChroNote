import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:chronote/screens/models/tema.dart';
import 'package:chronote/utils/session_manager.dart';
import 'package:chronote/screens/models/note.dart';
import 'package:chronote/screens/providers/note_provider.dart';
import 'theme_creator.dart';

/// Pantalla que muestra los detalles de un tema y su lista de notas.
/// Permite editar o eliminar el tema, así como eliminar notas individuales.
class ThemeViewer extends StatefulWidget {
  final int idTema; // ID del tema a mostrar
  final Tema tema; // Objeto Tema con los datos actuales

  const ThemeViewer({super.key, required this.idTema, required this.tema});

  @override
  State<ThemeViewer> createState() => _ThemeViewerState();
}

class _ThemeViewerState extends State<ThemeViewer> {
  bool loading = true; // Estado de carga
  String error = ''; // Mensaje de error (si hay)

  @override
  void initState() {
    super.initState();
    fetchNotas(); // Cargar notas al inicio
  }

  /// Carga las notas asociadas al tema
  Future<void> fetchNotas() async {
    try {
      await Provider.of<NoteProvider>(context, listen: false)
          .fetchNotasPorTema(widget.idTema);
    } catch (e) {
      error = "Error al cargar notas: $e";
    } finally {
      setState(() {
        loading = false;
      });
    }
  }

  /// Elimina el tema actual
  Future<void> eliminarTema() async {
    try {
      final userId = await SessionManager.getUserId();
      if (userId == null) {
        _showMessage("ID de usuario no disponible", isError: true);
        return;
      }
      await Provider.of<NoteProvider>(context, listen: false)
          .deleteTema(userId, widget.idTema);
      if (mounted) {
        Navigator.pop(context); // Regresa a la pantalla anterior
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error al eliminar tema: $e")),
      );
    }
  }

  /// Elimina una nota específica y recarga la lista
  Future<void> eliminarNota(int notaId) async {
    try {
      await Provider.of<NoteProvider>(context, listen: false)
          .deleteNota(widget.idTema, notaId);
      await fetchNotas(); // Refrescar la lista de notas
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error al eliminar nota: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final notas = Provider.of<NoteProvider>(context).notes;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Detalles del Tema"),
        actions: [
          // Botón para editar el tema
          IconButton(
            icon: const Icon(Icons.edit),
            tooltip: "Editar Tema",
            onPressed: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => ThemeCreator(tema: widget.tema),
                ),
              );
              await fetchNotas(); // Refrescar datos al volver
              setState(() {}); // Forzar reconstrucción
            },
          ),
          // Botón para eliminar el tema
          IconButton(
            icon: const Icon(Icons.delete),
            tooltip: "Eliminar Tema",
            onPressed: () => showDialog(
              context: context,
              builder: (ctx) => AlertDialog(
                title: const Text("¿Eliminar tema?"),
                content: const Text("Esta acción no se puede deshacer."),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(ctx),
                    child: const Text("Cancelar"),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pop(ctx);
                      eliminarTema();
                    },
                    child: const Text("Eliminar", style: TextStyle(color: Colors.red)),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      body: loading
          ? const Center(child: CircularProgressIndicator()) // Indicador de carga
          : error.isNotEmpty
              ? Center(child: Text(error)) // Mostrar error
              : Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Título del tema
                      Text(
                        widget.tema.nombre,
                        style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),

                      // Texto si tiene calendario
                      Text(
                        widget.tema.poseeCalendario
                            ? 'Con calendario'
                            : 'Sin calendario',
                        style: const TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                      const SizedBox(height: 24),

                      // Encabezado de notas
                      const Text(
                        "Notas:",
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),

                      // Lista de notas o mensaje si no hay
                      if (notas.isEmpty)
                        const Text("Este tema aún no tiene notas.")
                      else
                        ...notas.map((nota) => Card(
                              margin: const EdgeInsets.symmetric(vertical: 4),
                              child: ListTile(
                                title: Text(nota.nombre ?? 'Sin nombre'),
                                subtitle: Text(nota.descripcion ?? 'Sin descripción'),
                                trailing: IconButton(
                                  icon: const Icon(Icons.delete, color: Colors.red),
                                  tooltip: "Eliminar nota",
                                  onPressed: () => showDialog(
                                    context: context,
                                    builder: (ctx) => AlertDialog(
                                      title: const Text("¿Eliminar nota?"),
                                      content: const Text("Esta acción no se puede deshacer."),
                                      actions: [
                                        TextButton(
                                          onPressed: () => Navigator.pop(ctx),
                                          child: const Text("Cancelar"),
                                        ),
                                        TextButton(
                                          onPressed: () {
                                            Navigator.pop(ctx);
                                            eliminarNota(nota.id!);
                                          },
                                          child: const Text("Eliminar", style: TextStyle(color: Colors.red)),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            )),
                    ],
                  ),
                ),
    );
  }

  /// Muestra un snackbar de mensaje en la parte inferior
  void _showMessage(String mensaje, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(mensaje),
        backgroundColor: isError ? Colors.red : Colors.green,
      ),
    );
  }
}
