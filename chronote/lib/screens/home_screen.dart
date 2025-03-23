import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Home",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              // Acción al presionar el ícono de editar
            },
          ),
        ],
      ),
      body: Padding(
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
                    titulo: "Gimnasio",
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
      ),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today),
            label: "Daily View",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_view_week),
            label: "Weekly View",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_month),
            label: "Monthly View",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: "Search",
          ),
        ],
      ),
    );
  }
}

class TemaCard extends StatelessWidget {
  final String titulo;
  final String descripcion;
  final bool showHorario;

  const TemaCard({
    super.key,
    required this.titulo,
    required this.descripcion,
    required this.showHorario,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              titulo,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              descripcion,
              style: const TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                OutlinedButton(
                  onPressed: () {
                    // Acción para agregar nota
                  },
                  child: const Text("Agregar Nota"),
                ),
                const SizedBox(width: 8),
                if (showHorario)
                  OutlinedButton(
                    onPressed: () {
                      // Acción para ver horario
                    },
                    child: const Text("Horario"),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
