import 'package:flutter/material.dart';

class UserHomeScreenClient extends StatelessWidget {
  const UserHomeScreenClient({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Pantalla de Usuario')),
      body: const Center(child: Text('Bienvenido a la pantalla de usuario')),
    );
  }
}