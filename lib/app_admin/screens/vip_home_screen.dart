import 'package:flutter/material.dart';

class VipHomeScreen extends StatelessWidget {
  const VipHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Pantalla VIP')),
      body: const Center(child: Text('Bienvenido a la pantalla VIP')),
    );
  }
}