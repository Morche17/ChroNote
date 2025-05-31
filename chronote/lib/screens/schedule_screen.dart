import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ScheduleView extends StatefulWidget {
  final int temaId;
  const ScheduleView({super.key, required this.temaId});

  @override
  State<ScheduleView> createState() => _ScheduleViewState();
}

class _ScheduleViewState extends State<ScheduleView> {
  bool editMode = false;

  final List<String> days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
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
    _loadSchedule();
  }

  Future<void> _loadSchedule() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(widget.temaId.toString());
    if (jsonString != null) {
      final decoded = jsonDecode(jsonString) as Map<String, dynamic>;
      setState(() {
        schedule = decoded.map((key, value) => MapEntry(
              key,
              List<Map<String, dynamic>>.from(
                (value as List).map((e) => Map<String, dynamic>.from(e)),
              ),
            ));
      });
    }
  }

  Future<void> _saveSchedule() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = jsonEncode(schedule);
    await prefs.setString(widget.temaId.toString(), jsonString);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Horario guardado')),
    );
  }

  void toggleEditMode() {
    setState(() {
      editMode = !editMode;
    });
    if (!editMode) _saveSchedule(); // Guarda al salir del modo edición
  }

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
                  schedule[day]!.removeAt(index);
                });
                Navigator.pop(context);
              },
              child: const Text('Eliminar', style: TextStyle(color: Colors.red)),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  schedule[day]![index]['content'] = content;
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
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: Icon(editMode ? Icons.check : Icons.edit),
            onPressed: toggleEditMode,
          ),
        ],
      ),
      body: Column(
        children: [
          const SizedBox(height: 10),
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
                        onTap: () {
                          if (editMode) {
                            showEditDialog(day, index);
                          }
                        },
                        child: GestureDetector(
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
