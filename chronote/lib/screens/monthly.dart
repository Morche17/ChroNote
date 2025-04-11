import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'home_screen.dart';

class MonthlyView extends StatelessWidget {
  const MonthlyView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Vista Mensual",
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
              calendarFormat: CalendarFormat.month,
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
                children: const [
                  ListTile(
                    leading: Icon(Icons.circle, color: Colors.blue),
                    title: Text("Exposición de Historia"),
                    subtitle: Text("15 de Enero, 10:00 AM"),
                  ),
                  ListTile(
                    leading: Icon(Icons.circle, color: Colors.red),
                    title: Text("Entrega de Proyecto"),
                    subtitle: Text("22 de Enero, 11:59 PM"),
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