import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../app_admin/screens/admin_home_screen.dart';
import '../app_client/screens/user_home_screen_client.dart';
import '../app_client/screens/vip_home_screen.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  Widget _buildLoadingScreen() => const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );

  Widget _buildErrorScreen(String message) => Scaffold(
        body: Center(child: Text(message, textAlign: TextAlign.center)),
      );

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return _buildLoadingScreen();
        }
        if (!snapshot.hasData) {
          return _buildErrorScreen('Por favor, inicia sesión');
        }
        final user = snapshot.data!;
        return FutureBuilder<DocumentSnapshot>(
          future: FirebaseFirestore.instance
              .collection('usuarios')
              .doc(user.uid)
              .get(),
          builder: (context, userSnapshot) {
            if (userSnapshot.connectionState == ConnectionState.waiting) {
              return _buildLoadingScreen();
            }
            if (userSnapshot.hasError || !userSnapshot.hasData || !userSnapshot.data!.exists) {
              return _buildErrorScreen('Error al cargar los datos del usuario');
            }
            final userData = userSnapshot.data!.data() as Map<String, dynamic>? ?? {};
            final isAdmin = userData['isAdmin'] as bool? ?? false;
            final isVip = userData['isVip'] as bool? ?? false;
            if (isAdmin) return const AdminHomeScreen();
            if (isVip) return const VipHomeScreen();
            return const UserHomeScreenClient();
          },
        );
      },
    );
  }
}