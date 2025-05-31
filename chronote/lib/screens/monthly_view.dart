import 'package:chronote/utils/session_manager.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:chronote/screens/providers/note_provider.dart';
import 'package:intl/intl.dart';

class MonthlyViewScreen extends StatefulWidget {
  const MonthlyViewScreen({super.key});

  @override
  State<MonthlyViewScreen> createState() => _MonthlyViewScreenState();
}

class _MonthlyViewScreenState extends State<MonthlyViewScreen> {
  DateTime _focusedDay = DateTime.now();
  Map<DateTime, List<dynamic>> notasPorDia = {};

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final userId = await SessionManager.getUserId();
      if (userId != null) {
        await Provider.of<NoteProvider>(context, listen: false)
            .fetchAllThemesAndNotes(userId);
        agruparNotasPorDia();
      } else {
        print("ID de usuario no disponible");
      }
    });
  }

  void agruparNotasPorDia() {
    final provider = Provider.of<NoteProvider>(context, listen: false);
    final notas = provider.notes;

    final Map<DateTime, List<dynamic>> agrupadas = {};

    for (var nota in notas) {
      if (nota.fechaNotificacion != null) {
        final fecha = DateTime(
          nota.fechaNotificacion!.year,
          nota.fechaNotificacion!.month,
          nota.fechaNotificacion!.day,
        );

        agrupadas.putIfAbsent(fecha, () => []);
        agrupadas[fecha]!.add(nota.nombre ?? "Sin nombre");
      }
    }

    setState(() {
      notasPorDia = agrupadas;
    });
  }

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
            TableCalendar(
              firstDay: DateTime.utc(2020, 1, 1),
              lastDay: DateTime.utc(2030, 12, 31),
              focusedDay: _focusedDay,
              calendarFormat: CalendarFormat.month,
              selectedDayPredicate: (day) =>
                  isSameDay(day, _focusedDay),
              onDaySelected: (selectedDay, focusedDay) {
                setState(() {
                  _focusedDay = selectedDay;
                });
              },
              eventLoader: (day) {
                final key = DateTime(day.year, day.month, day.day);
                return notasPorDia[key] ?? [];
              },
              headerStyle: const HeaderStyle(
                formatButtonVisible: false,
                titleCentered: true,
                titleTextStyle:
                    TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
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
                markerDecoration: BoxDecoration(
                  color: Colors.red, // Marca roja para días con notas
                  shape: BoxShape.circle,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Notas del día ${DateFormat('dd/MM/yyyy').format(_focusedDay)}',
              style: const TextStyle(
                  fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: _getNotasDelDia(_focusedDay).isEmpty
                  ? const Center(child: Text("No hay notas para este día"))
                  : ListView.builder(
                      itemCount: _getNotasDelDia(_focusedDay).length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: Text(_getNotasDelDia(_focusedDay)[index]),
                          leading: const Icon(Icons.note),
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
