import 'package:flutter/material.dart';

class WeeklyViewScreen extends StatelessWidget {
  const WeeklyViewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final semana = {
      'Lunes': [
        'Terminar Presentación',
        'Exámen de Física',
        'Comprar Verduras',
        'Hacer 15 min. de cardio'
      ],
      'Martes': ['Disponible'],
      'Miércoles': ['Lavar el coche', 'Tarea Trigonometría'],
      'Jueves': ['Conferencia', 'Día de Pierna'],
      'Viernes': ['Lavar el coche', 'Tarea Trigonometría'],
    };

    return Padding(
      padding: const EdgeInsets.all(16),
      child: ListView(
        children: [
          const Text(
            'Esta Semana',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          for (var dia in semana.entries) ...[
            Row(
              children: [
                Checkbox(value: false, onChanged: (value) {}),
                Text(
                  dia.key,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: dia.value.length == 1 &&
                            dia.value.first == 'Disponible'
                        ? Colors.grey
                        : Colors.black,
                  ),
                ),
              ],
            ),
            if (dia.value.first == 'Disponible')
              const Padding(
                padding: EdgeInsets.only(left: 40),
                child: Text(
                  'Disponible',
                  style: TextStyle(color: Colors.grey),
                ),
              )
            else
              Padding(
                padding: const EdgeInsets.only(left: 40),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children:
                      dia.value.map((tarea) => Text("• $tarea")).toList(),
                ),
              ),
            const SizedBox(height: 16),
          ],
        ],
      ),
    );
  }
}
