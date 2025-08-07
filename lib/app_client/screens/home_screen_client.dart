import 'package:flutter/material.dart';

class UserHomeScreen extends StatelessWidget {
  const UserHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bienvenido Usuario'),
      ),
      body: const Center(
        child: Text(
          'Bienvenido a la app de Sofía Napolitani',
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
