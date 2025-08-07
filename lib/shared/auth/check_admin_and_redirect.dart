import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../app_admin/screens/admin_home_screen.dart';
import '../app_client/screens/user_home_screen_client.dart';
import '../app_client/screens/vip_home_screen.dart';

class CheckAdminAndRedirect extends StatelessWidget {
  const CheckAdminAndRedirect({super.key});

  Widget _buildLoadingScreen() => const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );

  Widget _buildErrorScreen(String message) => Scaffold(
        body: Center(child: Text(message, textAlign: TextAlign.center)),
      );

  Future<Map<String, dynamic>?> _fetchUserData(String uid) async {
    try {
      final doc = await FirebaseFirestore.instance.collection('usuarios').doc(uid).get();
      return doc.exists ? doc.data() : null;
    } catch (e) {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return _buildErrorScreen('Usuario no autenticado');
    }
    return FutureBuilder<Map<String, dynamic>?>(
      future: _fetchUserData(user.uid),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return _buildLoadingScreen();
        }
        if (snapshot.hasError || !snapshot.hasData) {
          return _buildErrorScreen('Error al cargar datos del usuario');
        }
        final userData = snapshot.data!;
        final isAdmin = userData['isAdmin'] as bool? ?? false;
        final isVip = userData['isVip'] as bool? ?? false;
        if (isAdmin) return const AdminHomeScreen();
        if (isVip) return const VipHomeScreen();
        return const UserHomeScreenClient();
      },
    );
  }
}