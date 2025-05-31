import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Vista de horario que permite agregar, editar y eliminar bloques por día.
/// Los datos se guardan localmente usando SharedPreferences.
class ScheduleView extends StatefulWidget {
  final int temaId; // Identificador del tema para guardar el horario

  const ScheduleView({super.key, required this.temaId});

  @override
  State<ScheduleView> createState() => _ScheduleViewState();
}

class _ScheduleViewState extends State<ScheduleView> {
  bool editMode = false; // Modo edición activado o no

  // Lista de los días de la semana
  final List<String> days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];

  // Estructura del horario: cada día tiene una lista de bloques
  Map<String, List<Map<String, dynamic>>> schedule = {
    'Mon': [],
    'Tue': [],
    'Wed': [],
    'Thu': [],
    'Fri': [],
    'Sat': [],
    'Sun': [],
  };

  @override
  void initState() {
    super.initState();
    _loadSchedule(); // Cargar el horario al iniciar
  }

  /// Carga el horario desde SharedPreferences
  Future<void> _loadSchedule() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(widget.temaId.toString());
    if (jsonString != null) {
      final decoded = jsonDecode(jsonString) as Map<String, dynamic>;
      setState(() {
        // Reconstruye el horario desde el JSON
        schedule = decoded.map((key, value) => MapEntry(
              key,
              List<Map<String, dynamic>>.from(
                (value as List).map((e) => Map<String, dynamic>.from(e)),
              ),
            ));
      });
    }
  }

  /// Guarda el horario en SharedPreferences
  Future<void> _saveSchedule() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = jsonEncode(schedule);
    await prefs.setString(widget.temaId.toString(), jsonString);

    // Muestra mensaje de éxito
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Horario guardado')),
    );
  }

  /// Alterna entre modo de edición y visualización
  void toggleEditMode() {
    setState(() {
      editMode = !editMode;
    });
    if (!editMode) _saveSchedule(); // Guarda cambios al salir de edición
  }

  /// Muestra un cuadro de diálogo para editar o eliminar un bloque
  void showEditDialog(String day, int index) {
    String content = schedule[day]![index]['content'];

    TextEditingController controller = TextEditingController(text: content);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Editar bloque'),
          content: TextField(
            autofocus: true,
            controller: controller,
            decoration: const InputDecoration(labelText: 'Contenido'),
            onChanged: (value) {
              content = value;
            },
          ),
          actions: [
            TextButton(
              onPressed: () {
                setState(() {
                  schedule[day]!.removeAt(index); // Eliminar bloque
                });
                Navigator.pop(context);
              },
              child: const Text('Eliminar', style: TextStyle(color: Colors.red)),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Cancelar edición
              },
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  schedule[day]![index]['content'] = content; // Guardar cambios
                });
                Navigator.pop(context);
              },
              child: const Text('Guardar'),
            ),
          ],
        );
      },
    );
  }

  /// Agrega un bloque vacío a un día
  void addEmptyBlock(String day) {
    setState(() {
      schedule[day]!.add({'content': '', 'height': 60.0});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Schedule'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context), // Volver atrás
        ),
        actions: [
          // Botón para activar/desactivar modo edición
          IconButton(
            icon: Icon(editMode ? Icons.check : Icons.edit),
            onPressed: toggleEditMode,
          ),
        ],
      ),
      body: Column(
        children: [
          const SizedBox(height: 10),
          // Encabezado con los días de la semana
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: days
                .map((day) => Text(day, style: const TextStyle(fontWeight: FontWeight.bold)))
                .toList(),
          ),
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: days.map((day) {
                return Expanded(
                  child: ListView.builder(
                    itemCount: schedule[day]!.length + (editMode ? 1 : 0),
                    itemBuilder: (context, index) {
                      // Muestra botón de añadir bloque al final si está en modo edición
                      if (editMode && index == schedule[day]!.length) {
                        return GestureDetector(
                          onTap: () => addEmptyBlock(day),
                          child: Container(
                            margin: const EdgeInsets.all(4),
                            height: 40,
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey),
                              borderRadius: BorderRadius.circular(8),
                              color: Colors.grey[200],
                            ),
                            child: const Center(child: Icon(Icons.add)),
                          ),
                        );
                      }

                      final block = schedule[day]![index];

                      return GestureDetector(
                        // Permite editar bloque si está en modo edición
                        onTap: () {
                          if (editMode) {
                            showEditDialog(day, index);
                          }
                        },
                        child: GestureDetector(
                          // Permite ajustar la altura del bloque con arrastre vertical
                          onVerticalDragUpdate: (details) {
                            setState(() {
                              block['height'] += details.delta.dy;
                              if (block['height'] < 40.0) block['height'] = 40.0;
                            });
                          },
                          child: Container(
                            margin: const EdgeInsets.all(4),
                            padding: const EdgeInsets.all(8),
                            height: block['height'],
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.black),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Center(
                              child: Text(
                                block['content'],
                                style: const TextStyle(color: Colors.black),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
