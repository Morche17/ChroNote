import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:chronote/utils/session_manager.dart';
import 'package:chronote/screens/providers/note_provider.dart';
import 'package:chronote/screens/models/note.dart';
import 'package:chronote/screens/models/tema.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  String searchQuery = '';

  @override
  void initState() {
    super.initState();
    _loadNotasYTemas();
  }

  void _loadNotasYTemas() async {
    final userId = await SessionManager.getUserId();
    if (userId != null) {
      final provider = Provider.of<NoteProvider>(context, listen: false);
      await provider.fetchAllThemesAndNotes(userId);
    } else {
      print("ID de usuario no disponible");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<NoteProvider>(
      builder: (context, noteProvider, child) {
        final temasMap = {
          for (var tema in noteProvider.themes) tema.id: tema.nombre
        };

        final filteredNotes = noteProvider.notes.where((nota) {
          final query = searchQuery.toLowerCase();
          return (nota.nombre ?? '').toLowerCase().contains(query);
        }).toList();

        // Agrupar notas por tema
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
                      searchQuery = value;
                    });
                  },
                ),
                const SizedBox(height: 16),
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
                                    Text(
                                      nombreTema,
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
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
