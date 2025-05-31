import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:chronote/screens/providers/note_provider.dart';
import 'package:chronote/utils/session_manager.dart';

class WeeklyViewScreen extends StatefulWidget {
  const WeeklyViewScreen({super.key});

  @override
  State<WeeklyViewScreen> createState() => _WeeklyViewScreenState();
}

class _WeeklyViewScreenState extends State<WeeklyViewScreen> {
  bool loading = true;

  @override
  void initState() {
    super.initState();
    cargarNotasSemana();
  }

  Future<void> cargarNotasSemana() async {
    final userId = await SessionManager.getUserId();
    if (userId != null) {
      await Provider.of<NoteProvider>(context, listen: false)
          .fetchAllThemesAndNotes(userId);
    }
    if (mounted) {
      setState(() => loading = false);
    }
  }

  Map<String, List<String>> agruparNotasPorDia(List notes) {
    final ahora = DateTime.now();
    final inicioSemana = ahora.subtract(Duration(days: ahora.weekday - 1)); // Lunes
    final finSemana = inicioSemana.add(const Duration(days: 6)); // Domingo

    Map<String, List<String>> semana = {
      'Lunes': [],
      'Martes': [],
      'Miércoles': [],
      'Jueves': [],
      'Viernes': [],
      'Sábado': [],
      'Domingo': [],
    };

    for (var nota in notes) {
      if (nota.fechaNotificacion == null) continue;

      final soloFecha = DateUtils.dateOnly(nota.fechaNotificacion!);
      if (soloFecha.isBefore(inicioSemana) || soloFecha.isAfter(finSemana)) continue;

      final diaSemana = soloFecha.weekday;
      final nombreDia = [
        'Lunes',
        'Martes',
        'Miércoles',
        'Jueves',
        'Viernes',
        'Sábado',
        'Domingo'
      ][diaSemana - 1];

      semana[nombreDia]?.add(nota.nombre);
    }

    return semana;
  }

  @override
  Widget build(BuildContext context) {
    final notes = Provider.of<NoteProvider>(context).notes;
    final semana = agruparNotasPorDia(notes);

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
                          Checkbox(value: false, onChanged: (_) {}),
                          Text(
                            dia.key,
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
