import 'package:flutter/material.dart';

class ScheduleView extends StatefulWidget {
  const ScheduleView({super.key});

  @override
  State<ScheduleView> createState() => _ScheduleViewState();
}

class _ScheduleViewState extends State<ScheduleView> {
  bool editMode = false;

  final List<String> days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
  final Map<String, List<Map<String, dynamic>>> schedule = {
    'Mon': [],
    'Tue': [],
    'Wed': [],
    'Thu': [],
    'Fri': [],
    'Sat': [],
    'Sun': [],
  };

  void toggleEditMode() {
    setState(() {
      editMode = !editMode;
    });
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
        leading: const Icon(Icons.arrow_back),
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
