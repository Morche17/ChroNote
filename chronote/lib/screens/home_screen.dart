import 'package:flutter/material.dart';
import 'package:chronote/widgets/theme_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
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
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.black,
              padding: const EdgeInsets.symmetric(vertical: 16),
              minimumSize: const Size(double.infinity, 48),
            ),
            onPressed: () {
              // Acción para cerrar sesión
            },
            child: const Text(
              "Cerrar Sesión",
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
