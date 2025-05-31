import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:chronote/utils/session_manager.dart';
import 'package:chronote/screens/providers/note_provider.dart';
import 'package:chronote/screens/models/note.dart';
import 'package:chronote/screens/models/tema.dart';

/// Pantalla para buscar notas existentes organizadas por temas
class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  // Consulta actual del campo de búsqueda
  String searchQuery = '';

  @override
  void initState() {
    super.initState();
    _loadNotasYTemas(); // Cargar notas y temas al iniciar la pantalla
  }

  /// Carga las notas y temas desde el backend usando el ID del usuario
  void _loadNotasYTemas() async {
    final userId = await SessionManager.getUserId();
    if (userId != null) {
      final provider = Provider.of<NoteProvider>(context, listen: false);
      await provider.fetchAllThemesAndNotes(userId); // Obtener datos
    } else {
      print("ID de usuario no disponible");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<NoteProvider>(
      builder: (context, noteProvider, child) {
        // Mapa de ID de tema a nombre del tema
        final temasMap = {
          for (var tema in noteProvider.themes) tema.id: tema.nombre
        };

        // Lista de notas filtradas por la consulta de búsqueda
        final filteredNotes = noteProvider.notes.where((nota) {
          final query = searchQuery.toLowerCase();
          return (nota.nombre ?? '').toLowerCase().contains(query);
        }).toList();

        // Agrupar notas por nombre del tema
        final notasPorTema = <String, List<Nota>>{};
        for (var nota in filteredNotes) {
          final nombreTema = temasMap[nota.temaId] ?? 'Sin Tema';
          notasPorTema.putIfAbsent(nombreTema, () => []);
          notasPorTema[nombreTema]!.add(nota);
        }

        return Scaffold(
          appBar: AppBar(
            title: const Text('Buscar Notas'),
          ),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                // Campo de búsqueda
                TextField(
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.search),
                    hintText: "Buscar Nota",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    filled: true,
                    fillColor: Colors.grey[200],
                  ),
                  onChanged: (value) {
                    setState(() {
                      searchQuery = value; // Actualizar consulta de búsqueda
                    });
                  },
                ),
                const SizedBox(height: 16),
                // Lista de resultados de búsqueda agrupados por tema
                Expanded(
                  child: notasPorTema.isEmpty
                      ? const Center(child: Text("No se encontraron notas"))
                      : ListView(
                          children: notasPorTema.entries.map((entry) {
                            final nombreTema = entry.key;
                            final notas = entry.value;
                            return Card(
                              margin: const EdgeInsets.only(bottom: 12),
                              child: Padding(
                                padding: const EdgeInsets.all(16),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Nombre del tema
                                    Text(
                                      nombreTema,
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    // Lista de notas del tema actual
                                    ...notas.map((nota) {
                                      return ListTile(
                                        title: Text(nota.nombre ?? 'Sin título'),
                                        subtitle: nota.descripcion != null
                                            ? Text(nota.descripcion!)
                                            : null,
                                        leading: const Icon(Icons.event_note),
                                      );
                                    }).toList(),
                                  ],
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
