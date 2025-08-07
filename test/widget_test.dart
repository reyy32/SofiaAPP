import 'package:flutter_test/flutter_test.dart';
import 'package:sofia_app/main.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:sofia_app/firebase_options.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  });

  testWidgets('Renderiza la pantalla de login', (WidgetTester tester) async {
    await tester.pumpWidget(const SofiaApp());
    await tester.pumpAndSettle(); // Espera a que cargue Firebase/AuthGate

    expect(find.text('Iniciar sesión con Google'), findsOneWidget);
  });
}
