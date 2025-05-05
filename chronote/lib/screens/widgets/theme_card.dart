import 'package:flutter/material.dart';
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
