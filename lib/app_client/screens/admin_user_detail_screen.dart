import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AdminUserDetailScreen extends StatefulWidget {
  final String userId;

  const AdminUserDetailScreen({super.key, required this.userId});

  @override
  State<AdminUserDetailScreen> createState() => _AdminUserDetailScreenState();
}

class _AdminUserDetailScreenState extends State<AdminUserDetailScreen> {
  DocumentSnapshot? userDoc;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  Future<void> _loadUser() async {
    final doc = await FirebaseFirestore.instance
        .collection('usuarios')
        .doc(widget.userId)
        .get();

    if (mounted) {
      setState(() {
        userDoc = doc;
        _isLoading = false;
      });
    }
  }

  Future<void> _updateField(String field, dynamic value) async {
    await FirebaseFirestore.instance
        .collection('usuarios')
        .doc(widget.userId)
        .update({field: value});

    await _loadUser();

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Campo "$field" actualizado.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading || userDoc == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final data = userDoc!.data() as Map<String, dynamic>;

    final Timestamp? timestamp = data['fechaCreacion'];
    final String fechaCreacion = timestamp != null
        ? timestamp.toDate().toString()
        : 'No disponible';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalle de Usuario'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            Text('Nombre: ${data['nombre'] ?? ''}', style: const TextStyle(fontSize: 18)),
            Text('Apellido: ${data['apellido'] ?? ''}', style: const TextStyle(fontSize: 18)),
            Text('Email: ${data['email'] ?? ''}', style: const TextStyle(fontSize: 18)),
            Text('Teléfono: ${data['telefono'] ?? ''}', style: const TextStyle(fontSize: 18)),
            Text('Documento: ${data['documento'] ?? ''}', style: const TextStyle(fontSize: 18)),
            Text('Fecha de creación: $fechaCreacion', style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 20),
            SwitchListTile(
              title: const Text('Usuario Activo'),
              value: data['activo'] == true,
              onChanged: (value) => _updateField('activo', value),
            ),
            SwitchListTile(
              title: const Text('Usuario VIP'),
              value: data['isVip'] == true,
              onChanged: (value) => _updateField('isVip', value),
            ),
            SwitchListTile(
              title: const Text('Administrador'),
              value: data['isAdmin'] == true,
              onChanged: (value) => _updateField('isAdmin', value),
            ),
          ],
        ),
      ),
    );
  }
}
