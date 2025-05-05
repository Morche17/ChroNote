import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class MonthlyViewScreen extends StatelessWidget {
  const MonthlyViewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final categorias = [
      {'nombre': 'Escuela', 'color': Colors.lightBlue},
      {'nombre': 'Trabajo', 'color': Colors.green},
      {'nombre': 'Gimnasio', 'color': Colors.red},
      {'nombre': 'Compras', 'color': Colors.grey},
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Monthly View'),
        centerTitle: true,
        leading: const Icon(Icons.arrow_back),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 16),
            child: Icon(Icons.edit),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(  // Hacemos que toda la vista sea desplazable
          child: Column(
            children: [
              TableCalendar(
                firstDay: DateTime.utc(2020, 1, 1),
                lastDay: DateTime.utc(2030, 12, 31),
                focusedDay: DateTime.now(),
                headerStyle: const HeaderStyle(
                  formatButtonVisible: false,
                  titleCentered: true,
                  titleTextStyle: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                calendarStyle: const CalendarStyle(
                  todayDecoration: BoxDecoration(
                    color: Colors.blue,
                    shape: BoxShape.circle,
                  ),
                  selectedDecoration: BoxDecoration(
                    color: Colors.black,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
              const SizedBox(height: 24),
              // Lista de Categorías
              ListView.builder(
                shrinkWrap: true,  // Para que no ocupe más espacio del necesario
                itemCount: categorias.length,
                itemBuilder: (context, index) {
                  final categoria = categorias[index];
                  return Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      border: Border.all(color: categoria['color'] as Color),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          categoria['nombre'] as String,
                          style: TextStyle(
                            color: categoria['color'] as Color,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Switch(
                          value: false,
                          onChanged: (value) {},
                        ),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
