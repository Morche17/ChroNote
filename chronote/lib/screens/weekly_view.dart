import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:chronote/screens/providers/note_provider.dart';
import 'package:chronote/utils/session_manager.dart';

/// Pantalla que muestra las notas agrupadas por día de la semana actual.
class WeeklyViewScreen extends StatefulWidget {
  const WeeklyViewScreen({super.key});

  @override
  State<WeeklyViewScreen> createState() => _WeeklyViewScreenState();
}

class _WeeklyViewScreenState extends State<WeeklyViewScreen> {
  bool loading = true; // Indica si se están cargando los datos

  @override
  void initState() {
    super.initState();
    cargarNotasSemana(); // Cargar datos al iniciar
  }

  /// Carga todas las notas del usuario para la semana actual.
  Future<void> cargarNotasSemana() async {
    final userId = await SessionManager.getUserId();
    if (userId != null) {
      await Provider.of<NoteProvider>(context, listen: false)
          .fetchAllThemesAndNotes(userId);
    }
    if (mounted) {
      setState(() => loading = false); // Finaliza el estado de carga
    }
  }

  /// Agrupa las notas que tienen fecha de notificación dentro de la semana actual.
  Map<String, List<String>> agruparNotasPorDia(List notes) {
    final ahora = DateTime.now();

    // Calcular inicio (lunes) y fin (domingo) de la semana actual
    final inicioSemana = ahora.subtract(Duration(days: ahora.weekday - 1));
    final finSemana = inicioSemana.add(const Duration(days: 6));

    // Mapa de días con listas vacías inicialmente
    Map<String, List<String>> semana = {
      'Lunes': [],
      'Martes': [],
      'Miércoles': [],
      'Jueves': [],
      'Viernes': [],
      'Sábado': [],
      'Domingo': [],
    };

    // Iterar sobre todas las notas
    for (var nota in notes) {
      if (nota.fechaNotificacion == null) continue;

      final soloFecha = DateUtils.dateOnly(nota.fechaNotificacion!);
      if (soloFecha.isBefore(inicioSemana) || soloFecha.isAfter(finSemana)) {
        continue; // Fuera del rango de la semana actual
      }

      final diaSemana = soloFecha.weekday; // 1 = lunes, ..., 7 = domingo
      final nombreDia = [
        'Lunes',
        'Martes',
        'Miércoles',
        'Jueves',
        'Viernes',
        'Sábado',
        'Domingo'
      ][diaSemana - 1];

      // Agrega el nombre de la nota al día correspondiente
      semana[nombreDia]?.add(nota.nombre);
    }

    return semana;
  }

  @override
  Widget build(BuildContext context) {
    final notes = Provider.of<NoteProvider>(context).notes;
    final semana = agruparNotasPorDia(notes); // Agrupar las notas por día

    return Scaffold(
      appBar: AppBar(title: const Text('Esta Semana')),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16),
              child: ListView(
                children: semana.entries.map((dia) {
                  final tareas = dia.value;
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          // Checkbox decorativo, sin funcionalidad por ahora
                          Checkbox(value: false, onChanged: (_) {}),
                          Text(
                            dia.key, // Nombre del día (ej. Lunes)
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color:
                                  tareas.isEmpty ? Colors.grey : Colors.black,
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 40),
                        child: tareas.isEmpty
                            ? const Text(
                                'Disponible',
                                style: TextStyle(color: Colors.grey),
                              )
                            : Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: tareas
                                    .map((tarea) => Text("• $tarea"))
                                    .toList(),
                              ),
                      ),
                      const SizedBox(height: 16),
                    ],
                  );
                }).toList(),
              ),
            ),
    );
  }
}
