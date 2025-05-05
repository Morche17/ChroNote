import 'package:flutter/material.dart';
import 'package:chronote/widgets/theme_card.dart';
import 'package:chronote/screens/note_creator.dart';
import 'package:chronote/utils/session_manager.dart';
import 'package:chronote/screens/login_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Home",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              IconButton(
                icon: const Icon(Icons.edit),
                onPressed: () {
                  Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const NoteCreator()),
                );
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
          ),
          const SizedBox(height: 16),
          Expanded(
            child: ListView(
              children: const [
                TemaCard(
                  titulo: "Escuela",
                  descripcion: "Última Nota: Exposición para el lunes",
                  showHorario: true,
                ),
                TemaCard(
                  titulo: "Trabajo",
                  descripcion: "Última Nota: Junta con los Inversores",
                  showHorario: true,
                ),
                TemaCard(
                  titulo: "Compras",
                  descripcion: "Última Nota: Comprar comida para perros",
                  showHorario: false,
                ),
                TemaCard(
                  titulo: "choclo",
                  descripcion: "Última Nota: Comprar comida para perros",
                  showHorario: false,
                ),
              ],
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
  }
}
