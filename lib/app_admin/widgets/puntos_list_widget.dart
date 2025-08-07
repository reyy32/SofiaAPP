import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PuntosListWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('usuarios')
          .orderBy('puntos', descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return CircularProgressIndicator();
        final users = snapshot.data!.docs;
        return ListView.builder(
          itemCount: users.length,
          itemBuilder: (context, index) {
            final user = users[index];
            return ListTile(
              title: Text('${user['nombre']} ${user['apellido']}'),
              subtitle: Text('Puntos: ${user['puntos'] ?? 0}'),
            );
          },
        );
      },
    );
  }
}