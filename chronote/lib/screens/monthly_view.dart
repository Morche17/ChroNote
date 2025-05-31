import 'package:chronote/utils/session_manager.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:chronote/screens/providers/note_provider.dart';
import 'package:intl/intl.dart';

/// Pantalla que muestra un calendario mensual con las notas agrupadas por día
class MonthlyViewScreen extends StatefulWidget {
  const MonthlyViewScreen({super.key});

  @override
  State<MonthlyViewScreen> createState() => _MonthlyViewScreenState();
}

class _MonthlyViewScreenState extends State<MonthlyViewScreen> {
  DateTime _focusedDay = DateTime.now();  // Día actualmente enfocado en el calendario
  Map<DateTime, List<dynamic>> notasPorDia = {};  // Mapa que agrupa notas por fecha

  @override
  void initState() {
    super.initState();
    // Carga las notas después de que el widget se haya construido
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final userId = await SessionManager.getUserId();
      if (userId != null) {
        await Provider.of<NoteProvider>(context, listen: false)
            .fetchAllThemesAndNotes(userId);
        agruparNotasPorDia();  // Procesa las notas para agruparlas por día
      } else {
        print("ID de usuario no disponible");
      }
    });
  }

  /// Agrupa todas las notas por su fecha de notificación
  void agruparNotasPorDia() {
    final provider = Provider.of<NoteProvider>(context, listen: false);
    final notas = provider.notes;

    final Map<DateTime, List<dynamic>> agrupadas = {};

    for (var nota in notas) {
      if (nota.fechaNotificacion != null) {
        // Normaliza la fecha (elimina horas/minutos/segundos)
        final fecha = DateTime(
          nota.fechaNotificacion!.year,
          nota.fechaNotificacion!.month,
          nota.fechaNotificacion!.day,
        );

        // Agrega la nota al mapa agrupado por fecha
        agrupadas.putIfAbsent(fecha, () => []);
        agrupadas[fecha]!.add(nota.nombre ?? "Sin nombre");
      }
    }

    setState(() {
      notasPorDia = agrupadas;  // Actualiza el estado con las notas agrupadas
    });
  }

  /// Obtiene las notas para un día específico
  List<String> _getNotasDelDia(DateTime dia) {
    final key = DateTime(dia.year, dia.month, dia.day);
    return (notasPorDia[key] ?? []).cast<String>();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Vista Mensual'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Widget de calendario mensual
            TableCalendar(
              firstDay: DateTime.utc(2020, 1, 1),  // Fecha mínima mostrada
              lastDay: DateTime.utc(2030, 12, 31),  // Fecha máxima mostrada
              focusedDay: _focusedDay,  // Día actualmente enfocado
              calendarFormat: CalendarFormat.month,  // Formato mensual
              selectedDayPredicate: (day) => isSameDay(day, _focusedDay),
              onDaySelected: (selectedDay, focusedDay) {
                setState(() {
                  _focusedDay = selectedDay;  // Actualiza el día seleccionado
                });
              },
              eventLoader: (day) {
                // Carga los eventos/notas para cada día
                final key = DateTime(day.year, day.month, day.day);
                return notasPorDia[key] ?? [];
              },
              headerStyle: const HeaderStyle(
                formatButtonVisible: false,  // Oculta el botón de cambio de formato
                titleCentered: true,        // Centra el título del mes
                titleTextStyle: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              calendarStyle: const CalendarStyle(
                todayDecoration: BoxDecoration(  // Estilo para el día actual
                  color: Colors.blue,
                  shape: BoxShape.circle,
                ),
                selectedDecoration: BoxDecoration(  // Estilo para el día seleccionado
                  color: Colors.black,
                  shape: BoxShape.circle,
                ),
                markerDecoration: BoxDecoration(  // Estilo para días con notas
                  color: Colors.red,
                  shape: BoxShape.circle,
                ),
              ),
            ),
            const SizedBox(height: 16),
            // Título que muestra la fecha seleccionada
            Text(
              'Notas del día ${DateFormat('dd/MM/yyyy').format(_focusedDay)}',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            // Lista de notas para el día seleccionado
            Expanded(
              child: _getNotasDelDia(_focusedDay).isEmpty
                  ? const Center(child: Text("No hay notas para este día"))
                  : ListView.builder(
                      itemCount: _getNotasDelDia(_focusedDay).length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: Text(_getNotasDelDia(_focusedDay)[index]),
                          leading: const Icon(Icons.note),  // Icono para cada nota
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}