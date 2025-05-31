import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:chronote/screens/providers/note_provider.dart';
import 'package:chronote/utils/session_manager.dart';
import 'package:intl/intl.dart';

class DailyViewScreen extends StatefulWidget {
  const DailyViewScreen({super.key});

  @override
  State<DailyViewScreen> createState() => _DailyViewScreenState();
}

class _DailyViewScreenState extends State<DailyViewScreen> {
  bool loading = true;

  @override
  void initState() {
    super.initState();
    cargarNotasDelDia();
  }

  Future<void> cargarNotasDelDia() async {
    final userId = await SessionManager.getUserId();

    if (userId != null) {
      await Provider.of<NoteProvider>(context, listen: false)
          .fetchAllThemesAndNotes(userId);
    } else {
      print("ID de usuario no disponible");
    }

    if (mounted) {
      setState(() {
        loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final noteProvider = Provider.of<NoteProvider>(context);
    final hoy = DateUtils.dateOnly(DateTime.now());

    final notasDeHoy = noteProvider.notes.where((nota) {
      if (nota.fechaNotificacion == null) return false;
      final fechaNota = DateUtils.dateOnly(nota.fechaNotificacion!);
      return fechaNota == hoy;
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Notas de Hoy'),
      ),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: notasDeHoy.isEmpty
                  ? const Center(child: Text("No hay notas para hoy"))
                  : ListView.builder(
                      itemCount: notasDeHoy.length,
                      itemBuilder: (context, index) {
                        final nota = notasDeHoy[index];
                        return Card(
                          elevation: 4,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          margin: const EdgeInsets.only(bottom: 16),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    const Icon(Icons.event_note,
                                        color: Colors.blue),
                                    const SizedBox(width: 8),
                                    Text(
                                      nota.nombre ?? 'Sin nombre',
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                if (nota.descripcion != null)
                                  Text(
                                    nota.descripcion!,
                                    style: const TextStyle(fontSize: 16),
                                  ),
                                const SizedBox(height: 8),
                                Text(
                                  "Hora: ${DateFormat.Hm().format(nota.fechaNotificacion!)}",
                                  style: const TextStyle(
                                      fontSize: 14, color: Colors.grey),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ),
    );
  }
}
