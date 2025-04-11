import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'home_screen.dart';

class WeeklyView extends StatelessWidget {
  const WeeklyView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Vista Semanal",
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
            TableCalendar(
              firstDay: DateTime.utc(2025, 1, 1),
              lastDay: DateTime.utc(2025, 12, 31),
              focusedDay: DateTime.now(),
              calendarFormat: CalendarFormat.week,
              headerStyle: const HeaderStyle(
                formatButtonVisible: false,
                titleCentered: true,
              ),
              calendarStyle: CalendarStyle(
                todayDecoration: BoxDecoration(
                  color: Colors.black,
                  shape: BoxShape.circle,
                ),
                selectedDecoration: BoxDecoration(
                  color: Colors.grey[300],
                  shape: BoxShape.circle,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView(
                children: [
                  _buildDaySchedule("Lunes", [
                    "9:00 AM - Clase de Matemáticas",
                    "2:00 PM - Reunión de equipo"
                  ]),
                  _buildDaySchedule("Martes", [
                    "10:00 AM - Tutoría",
                    "4:00 PM - Gimnasio"
                  ]),
                  _buildDaySchedule("Miércoles", ["Todo el día - Estudio"]),
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

  Widget _buildDaySchedule(String day, List<String> events) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              day,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            const SizedBox(height: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: events
                  .map((event) => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: Text("• $event"),
                      ))
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }
}