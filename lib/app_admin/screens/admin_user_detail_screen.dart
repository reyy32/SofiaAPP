import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AdminUserDetailScreen extends StatelessWidget {
  final String userId;

  const AdminUserDetailScreen({super.key, required this.userId});

  Future<Map<String, dynamic>?> _fetchUserData() async {
    final doc = await FirebaseFirestore.instance.collection('users').doc(userId).get();
    return doc.data();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Detalle de Usuario')),
      body: FutureBuilder<Map<String, dynamic>?>(
        future: _fetchUserData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data == null) {
            return const Center(child: Text('Usuario no encontrado.'));
          }

          final data = snapshot.data!;
          final fechaCreacion = (data['createdAt'] as Timestamp?)?.toDate();
          final puntos = data['puntos'] ?? 0;

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: ListView(
              children: [
                Text('Nombre: ${data['nombre'] ?? ''}', style: const TextStyle(fontSize: 18)),
                Text('Apellido: ${data['apellido'] ?? ''}', style: const TextStyle(fontSize: 18)),
                Text('Email: ${data['email'] ?? ''}', style: const TextStyle(fontSize: 18)),
                Text('Teléfono: ${data['telefono'] ?? ''}', style: const TextStyle(fontSize: 18)),
                Text('Documento: ${data['documento'] ?? ''}', style: const TextStyle(fontSize: 18)),
                Text('Puntos: $puntos', style: const TextStyle(fontSize: 18, color: Colors.green)),
                Text('Fecha de creación: ${fechaCreacion != null ? fechaCreacion.toString() : 'Desconocida'}',
                    style: const TextStyle(fontSize: 18)),
              ],
            ),
          );
        },
      ),
    );
  }
}
