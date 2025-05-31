import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:chronote/screens/models/tema.dart';
import 'package:chronote/utils/session_manager.dart';
import 'package:chronote/screens/models/note.dart';
import 'package:chronote/screens/providers/note_provider.dart';
import 'theme_creator.dart';

class ThemeViewer extends StatefulWidget {
  final int idTema;
  final Tema tema;

  const ThemeViewer({super.key, required this.idTema, required this.tema});

  @override
  State<ThemeViewer> createState() => _ThemeViewerState();
}

class _ThemeViewerState extends State<ThemeViewer> {
  bool loading = true;
  String error = '';

  @override
  void initState() {
    super.initState();
    fetchNotas();
  }

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

  Future<void> eliminarTema() async {
    try {
      final userId = await SessionManager.getUserId();
      if (userId == null) {
      _showMessage("ID de usuario no disponible", isError: true);
      return;
    }
      await Provider.of<NoteProvider>(context, listen: false)
          .deleteTema(userId,widget.idTema);
      if (mounted) {
        Navigator.pop(context); // Regresa al home
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error al eliminar tema: $e")),
      );
    }
  }

  Future<void> eliminarNota(int notaId) async {
    try {
      await Provider.of<NoteProvider>(context, listen: false)
          .deleteNota(widget.idTema,notaId);
      await fetchNotas(); // Refrescar la lista
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
              await fetchNotas();
              setState(() {}); // Refrescar
            },
          ),
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
          ? const Center(child: CircularProgressIndicator())
          : error.isNotEmpty
              ? Center(child: Text(error))
              : Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.tema.nombre,
                        style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        widget.tema.poseeCalendario
                            ? 'Con calendario'
                            : 'Sin calendario',
                        style: const TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                      const SizedBox(height: 24),
                      const Text(
                        "Notas:",
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
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
  
  void _showMessage(String mensaje, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(mensaje),
        backgroundColor: isError ? Colors.red : Colors.green,
      ),
    );
  }
}
