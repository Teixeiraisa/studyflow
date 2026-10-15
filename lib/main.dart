
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

import 'firebase_options.dart';
import 'screens/login_page.dart';

Future<void> main() async {
  // Prepara o Flutter antes de inicializar o Firebase.
  WidgetsFlutterBinding.ensureInitialized();

  // Conecta o aplicativo ao projeto Firebase.
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Inicia o aplicativo depois da conexão.
  runApp(const StudyFlow());
}

class StudyFlow extends StatelessWidget {
  const StudyFlow({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'StudyFlow',

      // Mantém o tema original do aplicativo.
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
        ),
        scaffoldBackgroundColor: const Color(0xFFF5F3FA),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF5E35B1),
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(
              vertical: 15,
            ),
          ),
        ),
      ),

      // Mantém a tela de login como página inicial.
      home: const LoginPage(),
    );
  }
}
