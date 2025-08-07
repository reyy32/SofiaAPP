import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AdminUsersScreen extends StatelessWidget {
  const AdminUsersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Usuarios registrados')),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('users').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No hay usuarios registrados.'));
          }

          final docs = snapshot.data!.docs;

          return ListView.builder(
            itemCount: docs.length,
            itemBuilder: (context, index) {
              final data = docs[index].data() as Map<String, dynamic>;
              final nombre = data['nombre'] ?? '';
              final apellido = data['apellido'] ?? '';
              final email = data['email'] ?? '';
              final activo = data['activo'] == true;

              return ListTile(
                leading: Icon(
                  activo ? Icons.check_circle : Icons.block,
                  color: activo ? Colors.green : Colors.red,
                ),
                title: Text('$nombre $apellido'),
                subtitle: Text(email),
                onTap: () {
                  if (!context.mounted) return;
                  Navigator.pushNamed(
                    context,
                    '/admin_user_detail',
                    arguments: docs[index].id,
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
