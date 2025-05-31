import 'package:chronote/services/note_service.dart';
import 'package:chronote/main.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:chronote/screens/providers/note_provider.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;

/// Pantalla para crear nuevas notas con recordatorios programados
class NoteCreator extends StatefulWidget {
  final int idTema;  // ID del tema al que pertenecerá la nota
  const NoteCreator({super.key, required this.idTema});

  @override
  State<NoteCreator> createState() => _NoteCreatorState();
}

class _NoteCreatorState extends State<NoteCreator> {
  // Controladores para los campos del formulario
  TextEditingController noteController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  TextEditingController timeController = TextEditingController();
  
  // Variables para almacenar fecha y hora seleccionadas
  DateTime? selectedDate;
  TimeOfDay? selectedTime;

  /// Guarda la nota y programa la notificación local
  void _saveNote() async {
    final String nombre = nameController.text;
    final String descripcion = noteController.text;
    final String fecha = dateController.text + ' ' + timeController.text;

    // Validación de campos requeridos
    if (nombre.isNotEmpty && descripcion.isNotEmpty && 
        dateController.text.isNotEmpty && timeController.text.isNotEmpty) {
      
      // Guarda la nota en el servidor
      await NoteService.addNote(widget.idTema, nombre, descripcion, fecha);

      // Programa la notificación local si hay fecha/hora seleccionada
      if (fecha.isNotEmpty && selectedDate != null && selectedTime != null) {
        final DateTime fechaBase = DateTime(
          selectedDate!.year,
          selectedDate!.month,
          selectedDate!.day,
          selectedTime!.hour,
          selectedTime!.minute,
        );

        // Convierte la fecha a la zona horaria local
        final tz.TZDateTime fechaZonificada = tz.TZDateTime.from(fechaBase, tz.local);

        // Configuración de la notificación para Android
        const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
          'recordatorio_channel',
          'Recordatorios',
          channelDescription: 'Canal para recordatorios',
          importance: Importance.max,
          priority: Priority.high,
        );

        const NotificationDetails notificationDetails = NotificationDetails(
          android: androidDetails,
        );
        
        // Programa la notificación
        await flutterLocalNotificationsPlugin.zonedSchedule(
          DateTime.now().millisecondsSinceEpoch ~/ 1000,
          'Nota programada',
          nombre,
          fechaZonificada,
          notificationDetails,
          androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
          matchDateTimeComponents: DateTimeComponents.dateAndTime,
        );
      }
    }

    // Limpia los campos del formulario
    nameController.clear();
    noteController.clear();
    dateController.clear();
    timeController.clear();

    // Muestra feedback al usuario
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Nota creada y recordatorio programado.")),
    );

    // Cierra la pantalla
    Navigator.pop(context);
  }

  @override
  void dispose() {
    // Limpia los controladores cuando el widget se destruye
    dateController.dispose();
    super.dispose();
  } 

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
                  // Campo para el nombre de la nota
                  TextField(
                    controller: nameController,
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
                  const SizedBox(height: 8),

                  // Campo para el contenido de la nota
                  const Text("Contenido de la nota"),
                  const SizedBox(height: 8),
                  TextField(
                    controller: noteController,
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
                  const SizedBox(height: 8),
                  
                  // Selector de fecha
                  const Text("Fecha del recordatorio"),
                  const SizedBox(height: 8),
                  TextField(
                    controller: dateController,
                    readOnly: true, // Solo selección mediante date picker
                    decoration: InputDecoration(
                      hintText: 'Selecciona una fecha',
                      suffixIcon: Icon(Icons.calendar_today),
                      border: OutlineInputBorder(),
                    ),
                    onTap: () async {
                      DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2100),
                      );

                      if (pickedDate != null) {
                        setState(() {
                          selectedDate = pickedDate;
                          dateController.text = 
                            "${pickedDate.year}-${pickedDate.month.toString().padLeft(2, '0')}-${pickedDate.day.toString().padLeft(2, '0')}";
                        });
                      }
                    },
                  ),
                  const SizedBox(height: 8),
                  
                  // Selector de hora
                  const Text("Hora del recordatorio"),
                  const SizedBox(height: 8),
                  TextField(
                    controller: timeController,
                    readOnly: true, // Solo selección mediante time picker
                    decoration: InputDecoration(
                      hintText: 'Selecciona una hora',
                      suffixIcon: Icon(Icons.access_time),
                      border: OutlineInputBorder(),
                    ),
                    onTap: () async {
                      TimeOfDay? pickedTime = await showTimePicker(
                        context: context,
                        initialTime: TimeOfDay(hour: 0, minute: 0),
                      );
                      if (pickedTime != null) {
                        setState(() {
                          selectedTime = pickedTime;
                          timeController.text =
                          '${pickedTime.hour.toString().padLeft(2, '0')}:${pickedTime.minute.toString().padLeft(2, '0')}';
                        });
                      }
                    }, 
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            
            // Botón para guardar la nota
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                padding: const EdgeInsets.symmetric(vertical: 16),
                minimumSize: const Size(double.infinity, 48),
              ),
              onPressed: _saveNote,
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