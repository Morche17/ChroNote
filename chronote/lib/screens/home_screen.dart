import 'package:chronote/utils/session_manager.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:chronote/screens/providers/note_provider.dart';
import 'theme_creator.dart';
import 'theme_viewer.dart';
import 'note_creator.dart';
import 'login_screen.dart';
import 'schedule_screen.dart'; // Asegúrate de crear esta pantalla

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String searchQuery = '';

  @override
  void initState() {
    super.initState();
    _loadTemas();
  }

  void _loadTemas() async {
    final userId = await SessionManager.getUserId();

    if (mounted && userId != null) {
      Provider.of<NoteProvider>(context, listen: false).fetchThemes(userId);
    } else {
      print("ID de usuario no disponible");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<NoteProvider>(
      builder: (context, noteProvider, child) {
        final filteredThemes = noteProvider.themes
            .where((tema) => tema.nombre.toLowerCase().contains(searchQuery.toLowerCase()))
            .toList();

        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Home",
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                    icon: const Icon(Icons.edit),
                    onPressed: () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const ThemeCreator()),
                      );
                      setState(() {}); // Rebuild to reflect the new note
                    },
                  ),
                ],
              ),
              const SizedBox(height: 16),
              TextField(
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.search),
                  hintText: "Buscar Tema",
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
                child: ListView(
                  children: filteredThemes.map((theme) {
                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              theme.nombre,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                              if (theme.poseeCalendario)
                                IconButton(
                                  icon: const Icon(Icons.calendar_today),
                                  tooltip: 'Ver Calendario',
                                  onPressed: () async {
                                    await Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => ScheduleView(temaId: theme.id),
                                      ),
                                    );
                                  },
                                ),
                                IconButton(
                                  icon: const Icon(Icons.search),
                                  tooltip: 'Ver Tema',
                                  onPressed: () async {
                                    await Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            ThemeViewer(idTema: theme.id, tema: theme),
                                      ),
                                    );
                                    setState(() {});
                                  },
                                ),
                                IconButton(
                                  icon: const Icon(Icons.add),
                                  tooltip: 'Añadir Nota',
                                  onPressed: () async {
                                    await Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => NoteCreator(idTema: theme.id)),
                                    );
                                    setState(() {});
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () async {
                  await SessionManager.clearSession();
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (_) => const LoginScreen()),
                  );
                },
                child: const Text("Cerrar Sesión"),
              ),
            ],
          ),
        );
      },
    );
  }
}
