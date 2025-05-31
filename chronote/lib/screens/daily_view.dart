import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:chronote/screens/providers/note_provider.dart';
import 'package:chronote/utils/session_manager.dart';
import 'package:intl/intl.dart';

/// Pantalla que muestra las notas programadas para el día actual
class DailyViewScreen extends StatefulWidget {
  const DailyViewScreen({super.key});

  @override
  State<DailyViewScreen> createState() => _DailyViewScreenState();
}

class _DailyViewScreenState extends State<DailyViewScreen> {
  // Estado para controlar la carga de datos
  bool loading = true;

  @override
  void initState() {
    super.initState();
    cargarNotasDelDia(); // Carga las notas al iniciar la pantalla
  }

  /// Carga las notas del día desde el proveedor de estado
  Future<void> cargarNotasDelDia() async {
    // Obtiene el ID del usuario desde SessionManager
    final userId = await SessionManager.getUserId();

    if (userId != null) {
      // Usa el NoteProvider para cargar todos los temas y notas
      await Provider.of<NoteProvider>(context, listen: false)
          .fetchAllThemesAndNotes(userId);
    } else {
      print("ID de usuario no disponible");
    }

    // Actualiza el estado de carga solo si el widget está montado
    if (mounted) {
      setState(() {
        loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Obtiene la instancia del NoteProvider
    final noteProvider = Provider.of<NoteProvider>(context);
    // Obtiene la fecha de hoy sin hora
    final hoy = DateUtils.dateOnly(DateTime.now());

    // Filtra las notas para obtener solo las del día actual
    final notasDeHoy = noteProvider.notes.where((nota) {
      if (nota.fechaNotificacion == null) return false;
      final fechaNota = DateUtils.dateOnly(nota.fechaNotificacion!);
      return fechaNota == hoy;
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Notas de Hoy'), // Título de la AppBar
      ),
      body: loading
          ? const Center(child: CircularProgressIndicator()) // Indicador de carga
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: notasDeHoy.isEmpty
                  ? const Center(child: Text("No hay notas para hoy")) // Mensaje cuando no hay notas
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
                                // Fila con icono y nombre de la nota
                                Row(
                                  children: [
                                    const Icon(Icons.event_note,
                                        color: Colors.blue),
                                    const SizedBox(width: 8),
                                    Text(
                                      nota.nombre ?? 'Sin nombre', // Nombre por defecto si es null
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                // Descripción de la nota (si existe)
                                if (nota.descripcion != null)
                                  Text(
                                    nota.descripcion!,
                                    style: const TextStyle(fontSize: 16),
                                  ),
                                const SizedBox(height: 8),
                                // Hora de la nota formateada
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