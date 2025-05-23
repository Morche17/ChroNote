import 'package:chronote/utils/session_manager.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:chronote/screens/providers/note_provider.dart';
import 'theme_creator.dart';
import 'note_creator.dart';
import 'login_screen.dart';

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
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              // Espacio adicional arriba del título
              const SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Home",
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  // Icono desplazado hacia abajo
                  Transform.translate(
                    offset: const Offset(0, 10), // Ajusta este valor para mover más/menos
                    child: IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () async {
                        await Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const ThemeCreator()),
                        );
                        setState(() {});
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30), // Espacio aumentado
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
              const SizedBox(height: 20),
              Expanded(
                child: ListView(
                  children: filteredThemes.map((theme) {
                    final themeNotes = noteProvider.notes
                        .where((note) => note.theme == theme)
                        .toList();
                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
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
                                if (themeNotes.isEmpty)
                                  const Text("Sin notas aún", style: TextStyle(color: Colors.grey))
                                else
                                  Column(
                                    children: themeNotes.map((note) {
                                      return Align(
                                        alignment: Alignment.centerLeft,
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(vertical: 2),
                                          child: Text("• ${note.name}"),
                                        ),
                                      );
                                    }).toList(),
                                  ),
                              ],
                            ),
                            IconButton(
                              icon: const Icon(Icons.add),
                              onPressed: () async {
                                await Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => NoteCreator(idTema: theme.id)),
                                );
                                setState(() {});
                              },
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: 20),
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
