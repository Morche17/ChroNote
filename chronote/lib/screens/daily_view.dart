import 'package:flutter/material.dart';

class DailyViewScreen extends StatelessWidget {
  const DailyViewScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Daily View'),
      ),
      body: Center(
        child: Text(
          'Hola Mundo',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}