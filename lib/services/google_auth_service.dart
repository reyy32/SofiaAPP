import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class GoogleAuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: ['email', 'profile'], // Añadido 'profile' para nombre completo
  );

  Future<UserCredential?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        print('Inicio de sesión con Google cancelado por el usuario');
        return null;
      }

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      if (googleAuth.accessToken == null || googleAuth.idToken == null) {
        print('Error: No se pudieron obtener las credenciales de autenticación');
        throw FirebaseAuthException(
          code: 'google-auth-failed',
          message: 'Fallo al obtener tokens de autenticación',
        );
      }

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      try {
        final UserCredential userCredential = await _auth.signInWithCredential(credential);
        final uid = userCredential.user?.uid;
        if (uid == null) {
          print('Error: UID no disponible');
          return userCredential;
        }

        final user = userCredential.user!;
        final userDoc = await _firestore.collection('usuarios').doc(uid).get();
        if (!userDoc.exists) {
          final nameParts = user.displayName?.split(' ') ?? [''];
          await _firestore.collection('usuarios').doc(uid).set({
            'nombre': nameParts.isNotEmpty ? nameParts.first : '',
            'apellido': nameParts.length > 1 ? nameParts.skip(1).join(' ') : '',
            'email': user.email ?? '',
            'telefono': '',
            'documento': '',
            'puntos': 0,
            'isVip': false,
            'isAdmin': false,
            'activo': true,
            'fechaCreacion': FieldValue.serverTimestamp(),
          });
        }

        return userCredential;
      } on FirebaseAuthException catch (e) {
        print('Error de Firebase Authentication: ${e.code} - ${e.message}');
        rethrow;
      }
    } catch (e) {
      print('Error al iniciar sesión con Google: $e');
      if (e is FirebaseAuthException) {
        rethrow;
      }
      throw Exception('Error inesperado durante la autenticación con Google: $e');
    }
  }
}