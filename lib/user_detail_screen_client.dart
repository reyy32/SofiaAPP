import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserDetailScreenClient extends StatelessWidget {
  final String userId;

  UserDetailScreenClient({required this.userId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Detalles del Usuario')),
      body: FutureBuilder<DocumentSnapshot>(
        future: FirebaseFirestore.instance.collection('usuarios').doc(userId).get(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return Center(child: CircularProgressIndicator());
          final user = snapshot.data!.data() as Map<String, dynamic>? ?? {};
          final fechaCreacion = (user['fechaCreacion'] as Timestamp?)?.toDate() ?? DateTime.now();

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Nombre: ${user['nombre'] ?? 'Sin nombre'}', style: TextStyle(fontSize: 18)),
                Text('Apellido: ${user['apellido'] ?? 'Sin apellido'}', style: TextStyle(fontSize: 18)),
                Text('Email: ${user['email'] ?? 'Sin email'}', style: TextStyle(fontSize: 18)),
                Text('Puntos: ${user['puntos'] ?? 0}', style: TextStyle(fontSize: 18)),
                Text('Fecha de Creación: ${fechaCreacion.toLocal()}', style: TextStyle(fontSize: 18)),
              ],
            ),
          );
        },
      ),
    );
  }
}