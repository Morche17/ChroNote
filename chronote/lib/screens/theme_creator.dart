import 'package:chronote/services/theme_service.dart';
import 'package:chronote/utils/session_manager.dart';
import 'package:flutter/material.dart';


class ThemeCreator extends StatefulWidget {
  const ThemeCreator({super.key});

  @override
  State<ThemeCreator> createState() => _ThemeCreatorState();
}

class _ThemeCreatorState extends State<ThemeCreator> {
  TextEditingController nameController = TextEditingController();
  bool poseeCalendario = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Crear Tema",
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
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: nameController,
              decoration: InputDecoration(
                labelText: "Nombre del tema",
                filled: true,
                fillColor: Colors.grey[100],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Checkbox(
                  value: poseeCalendario,
                  onChanged: (value) {
                    setState(() {
                      poseeCalendario = value ?? false;
                    });
                  },
                ),
                const Text("Posee calendario"),
              ],
            ),
            const Spacer(),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                padding: const EdgeInsets.symmetric(vertical: 16),
                minimumSize: const Size(double.infinity, 48),
              ),
              onPressed: _saveTheme,
              child: const Text(
                "Guardar Tema",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
      backgroundColor: Colors.white,
    );
  }

  Future<void> _saveTheme() async {
    final nombre = nameController.text;
    final calendario = poseeCalendario;
    final userId = await SessionManager.getUserId();

    if (mounted && userId != null) {
      try{
        await ThemeService.addTheme(userId, nombre, calendario);
        showDialog(
          context: context, 
          builder: (_) => AlertDialog(
            title: const Text("Tema guardado"),
            content: const Text("Su tema se a guardado exitosamente en la base de datos"),
          )
        );
      }
      catch (e) {
        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: const Text('Error'),
            content: Text(e.toString()),
          ),
        );
      }
    } else {
      
      print("ID de usuario no disponible");
    }
  }
}

