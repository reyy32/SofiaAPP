import 'package:flutter/material.dart';

class UserHomeScreen extends StatelessWidget {
  const UserHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Inicio Cliente (alternativo)'),
      ),
      body: const Center(
        child: Text(
          'Pantalla alternativa de cliente',
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
