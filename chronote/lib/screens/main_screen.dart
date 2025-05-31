import 'package:flutter/material.dart';
import 'home_screen.dart';
import 'daily_view.dart';
import 'weekly_view.dart';
import 'monthly_view.dart';
import 'search_view.dart';

/// Pantalla principal que contiene la estructura base de navegación de la aplicación
/// con un sistema de bottom navigation bar para cambiar entre las diferentes vistas
class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  // Índice de la pantalla actual seleccionada
  int _selectedIndex = 0;

  // Lista de todas las pantallas disponibles en la navegación inferior
  final List<Widget> _screens = const [
    HomeScreen(),          // Pantalla de inicio
    DailyViewScreen(),     // Vista diaria
    WeeklyViewScreen(),    // Vista semanal
    MonthlyViewScreen(),   // Vista mensual
    SearchScreen()         // Pantalla de búsqueda
  ];

  /// Método que maneja el cambio de pantalla al seleccionar un ítem en la barra de navegación
  /// [index] El índice de la pantalla seleccionada
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index; // Actualiza el índice seleccionado
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Muestra la pantalla correspondiente al índice seleccionado
      body: _screens[_selectedIndex],
      
      // Barra de navegación inferior
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Colors.black,    // Color del ítem seleccionado
        unselectedItemColor: Colors.grey,  // Color de los ítems no seleccionados
        currentIndex: _selectedIndex,       // Índice actual seleccionado
        onTap: _onItemTapped,              // Callback al tocar un ítem
        type: BottomNavigationBarType.fixed, // Tipo de barra de navegación
        items: const [
          // Ítems de la barra de navegación
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.calendar_today), label: "Daily View"),
          BottomNavigationBarItem(icon: Icon(Icons.calendar_view_week), label: "Weekly View"),
          BottomNavigationBarItem(icon: Icon(Icons.calendar_month), label: "Monthly View"),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: "Search"),
        ],
      ),
    );
  }
}