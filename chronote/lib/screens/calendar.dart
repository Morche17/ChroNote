import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'home_screen.dart';

class CalendarView extends StatelessWidget {
  const CalendarView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Calendario 2025",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: SfCalendar(
                view: CalendarView.year,
                showDatePickerButton: true,
                yearCellBuilder: (context, details) {
                  return Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey[300]!),
                    ),
                    child: Center(
                      child: Text(
                        details.date.day.toString(),
                        style: TextStyle(
                          color: details.isToday ? Colors.white : null,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              "Eventos Importantes 2025",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: ListView(
                children: const [
                  ListTile(
                    leading: Icon(Icons.circle, color: Colors.blue),
                    title: Text("Inicio de Clases"),
                    subtitle: Text("13 de Enero"),
                  ),
                  ListTile(
                    leading: Icon(Icons.circle, color: Colors.red),
                    title: Text("Vacaciones de Semana Santa"),
                    subtitle: Text("14-20 de Abril"),
                  ),
                  ListTile(
                    leading: Icon(Icons.circle, color: Colors.green),
                    title: Text("Exámenes Finales"),
                    subtitle: Text("2-13 de Junio"),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today),
            label: "Daily View",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_view_week),
            label: "Weekly View",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_month),
            label: "Monthly View",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: "Search",
          ),
        ],
      ),
    );
  }
}