import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../screens/admin_user_detail_screen.dart';

class UserListWidget extends StatefulWidget {
  const UserListWidget({super.key});

  @override
  State<UserListWidget> createState() => _UserListWidgetState();
}

class _UserListWidgetState extends State<UserListWidget> {
  String _searchQuery = '';
  String _rolFilter = 'todos';
  String _estadoFilter = 'todos';

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Buscador
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            decoration: const InputDecoration(
              labelText: 'Buscar por nombre, apellido o email',
              prefixIcon: Icon(Icons.search),
            ),
            onChanged: (value) {
              setState(() {
                _searchQuery = value.toLowerCase();
              });
            },
          ),
        ),
        // Filtros
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Row(
            children: [
              Expanded(
                child: DropdownButton<String>(
                  value: _rolFilter,
                  onChanged: (value) {
                    if (value != null) {
                      setState(() => _rolFilter = value);
                    }
                  },
                  items: const [
                    DropdownMenuItem(value: 'todos', child: Text('Todos los roles')),
                    DropdownMenuItem(value: 'admin', child: Text('Solo Admins')),
                    DropdownMenuItem(value: 'vip', child: Text('Solo VIP')),
                    DropdownMenuItem(value: 'comun', child: Text('Solo comunes')),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: DropdownButton<String>(
                  value: _estadoFilter,
                  onChanged: (value) {
                    if (value != null) {
                      setState(() => _estadoFilter = value);
                    }
                  },
                  items: const [
                    DropdownMenuItem(value: 'todos', child: Text('Todos los estados')),
                    DropdownMenuItem(value: 'activos', child: Text('Solo activos')),
                    DropdownMenuItem(value: 'inactivos', child: Text('Solo bloqueados')),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        // Lista
        Expanded(
          child: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance.collection('usuarios').snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return const Center(child: Text('No se encontraron usuarios.'));
              }

              final docs = snapshot.data!.docs.where((doc) {
                final data = doc.data() as Map<String, dynamic>;

                final nombre = (data['nombre'] ?? '').toString().toLowerCase();
                final apellido = (data['apellido'] ?? '').toString().toLowerCase();
                final email = (data['email'] ?? '').toString().toLowerCase();
                final activo = data['activo'] ?? true;
                final isVip = data['isVip'] ?? false;
                final isAdmin = data['isAdmin'] ?? false;

                final matchesSearch = nombre.contains(_searchQuery) ||
                    apellido.contains(_searchQuery) ||
                    email.contains(_searchQuery);

                final matchesRol = switch (_rolFilter) {
                  'admin' => isAdmin,
                  'vip' => isVip && !isAdmin,
                  'comun' => !isVip && !isAdmin,
                  _ => true,
                };

                final matchesEstado = switch (_estadoFilter) {
                  'activos' => activo == true,
                  'inactivos' => activo == false,
                  _ => true,
                };

                return matchesSearch && matchesRol && matchesEstado;
              }).toList();

              if (docs.isEmpty) {
                return const Center(child: Text('No se encontraron usuarios.'));
              }

              return ListView.builder(
                itemCount: docs.length,
                itemBuilder: (context, index) {
                  final data = docs[index].data() as Map<String, dynamic>;
                  final nombre = data['nombre'] ?? '';
                  final apellido = data['apellido'] ?? '';
                  final email = data['email'] ?? '';
                  final activo = data['activo'] != false;

                  return ListTile(
                    title: Text('$nombre $apellido'),
                    subtitle: Text(email),
                    trailing: Icon(
                      activo ? Icons.check_circle : Icons.block,
                      color: activo ? Colors.green : Colors.red,
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => AdminUserDetailScreen(userId: docs[index].id),
                        ),
                      );
                    },
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
