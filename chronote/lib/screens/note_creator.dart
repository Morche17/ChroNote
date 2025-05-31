import 'package:chronote/services/note_service.dart';
import 'package:chronote/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;

class NoteCreator extends StatefulWidget {
  final int idTema;
  const NoteCreator({super.key, required this.idTema});

  @override
  State<NoteCreator> createState() => _NoteCreatorState();
}

class _NoteCreatorState extends State<NoteCreator> {
  TextEditingController noteController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  TextEditingController timeController = TextEditingController();
  DateTime? selectedDate;
  TimeOfDay? selectedTime;

  void _saveNote() async {
<<<<<<< HEAD
  final String nombre = nameController.text;
  final String descripcion = noteController.text;
  final String fecha = dateController.text + ' ' + timeController.text;

  if (nombre.isNotEmpty && descripcion.isNotEmpty && fecha.isNotEmpty) {
    await NoteService.addNote(widget.idTema, nombre, descripcion, fecha);
=======
    final String nombre = nameController.text;
    final String descripcion = noteController.text;
    final String fecha = dateController.text;

    if (nombre.isNotEmpty && descripcion.isNotEmpty) {
      try {
        await NoteService.addNote(widget.idTema, nombre, descripcion, fecha);
>>>>>>> 9c11d6cb3bf6692ac8ddc4aa15b3daa02ab38de7

        if (fecha.isNotEmpty && selectedDate != null && selectedTime != null) {
          final DateTime fechaBase = DateTime(
            selectedDate!.year,
            selectedDate!.month,
            selectedDate!.day,
            selectedTime!.hour,
            selectedTime!.minute,
          );

          final tz.TZDateTime fechaZonificada =
              tz.TZDateTime.from(fechaBase, tz.local);

          const AndroidNotificationDetails androidDetails =
              AndroidNotificationDetails(
            'recordatorio_channel',
            'Recordatorios',
            channelDescription: 'Canal para recordatorios',
            importance: Importance.max,
            priority: Priority.high,
          );

          const NotificationDetails notificationDetails = NotificationDetails(
            android: androidDetails,
          );

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

        if (mounted) {
          showDialog(
            context: context,
            builder: (_) => AlertDialog(
              title: const Text('Nota guardada'),
              content: const Text('La nota se ha guardado exitosamente.'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('OK'),
                ),
              ],
            ),
          );
        }

        // Limpiar todos los campos
        nameController.clear();
        noteController.clear();
        dateController.clear();
        timeController.clear();
        setState(() {
          selectedDate = null;
          selectedTime = null;
        });
      } catch (e) {
        if (mounted) {
          showDialog(
            context: context,
            builder: (_) => AlertDialog(
              title: const Text('Error'),
              content: Text(e.toString()),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('OK'),
                ),
              ],
            ),
          );
        }
      }
    } else {
      if (mounted) {
        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: const Text('Campos requeridos'),
            content: const Text('Nombre y contenido son obligatorios'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('OK'),
              ),
            ],
          ),
        );
      }
    }
  }

<<<<<<< HEAD
  nameController.clear();
  noteController.clear();
  dateController.clear();
  timeController.clear();

  ScaffoldMessenger.of(context).showSnackBar(
    const SnackBar(content: Text("Nota creada.")),
  );

  Navigator.pop(context); // cerrar la pantalla
}


=======
>>>>>>> 9c11d6cb3bf6692ac8ddc4aa15b3daa02ab38de7
  @override
  void dispose() {
    dateController.dispose();
    timeController.dispose();
    noteController.dispose();
    nameController.dispose();
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
                  const Text("Fecha del recordatorio"),
                  const SizedBox(height: 8),
                  TextField(
                    controller: dateController,
                    readOnly: true,
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
                  const Text("Hora del recordatorio"),
                  const SizedBox(height: 8),
                  TextField(
                    controller: timeController,
                    readOnly: true,
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
