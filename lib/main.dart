import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:sofia_app/shared/auth/auth_gate.dart';
import 'firebase_options.dart'; // Archivo generado con flutterfire configure

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const SofiaApp());
}

class SofiaApp extends StatelessWidget {
  const SofiaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Sofía Napolitani',
      theme: ThemeData(
        primarySwatch: Colors.pink,
        useMaterial3: true,
      ),
      home: const AuthGate(), // Tu AuthGate ahora es el punto de entrada
    );
  }
}
