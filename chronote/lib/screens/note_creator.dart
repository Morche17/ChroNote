import 'package:flutter/material.dart';

class NoteCreator extends StatelessWidget {
  const NoteCreator({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Note Creator",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
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
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: [
            Expanded(
              child: ListView(
                children: [
                  TextField(
                    decoration: InputDecoration(
                      hintText: "Nombre",
                      filled: true,
                      fillColor: Colors.grey[100],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  const Text("Seleccionar Fecha a Guardar"),
                  const SizedBox(height: 8),
                  Row(
                    children: const [
                      Icon(Icons.calendar_today_outlined),
                      SizedBox(width: 12),
                      Text("15 Sep 2025"),
                    ],
                  ),
                  const SizedBox(height: 24),

                  const Text("Seleccionar Hora"),
                  const SizedBox(height: 8),
                  Row(
                    children: const [
                      Icon(Icons.access_time_outlined),
                      SizedBox(width: 12),
                      Text("13:00 - 14:00"),
                    ],
                  ),
                  const SizedBox(height: 24),

                  const Text("Recordar"),
                  const SizedBox(height: 8),
                  Row(
                    children: const [
                      Icon(Icons.calendar_today_outlined),
                      SizedBox(width: 12),
                      Text("20 de Mayo"),
                    ],
                  ),
                  const SizedBox(height: 24),

                  const Text("Tema"),
                  const SizedBox(height: 8),
                  TextField(
                    enabled: false,
                    decoration: InputDecoration(
                      hintText: "Seleccionar Tema",
                      filled: true,
                      fillColor: Colors.grey[100],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  const Text("Contenido de la nota"),
                  const SizedBox(height: 8),
                  TextField(
                    maxLines: 6,
                    decoration: InputDecoration(
                      hintText: "Ingresa tu nota",
                      filled: true,
                      fillColor: Colors.grey[100],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide.none,
                      ),
                    ),
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
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Nota creada correctamente')),
                );
              },
              child: const Text(
                "Crear Nota",
                style: TextStyle(color: Colors.white),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
      backgroundColor: Colors.white,
    );
  }
}
