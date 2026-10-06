import 'package:flutter/material.dart';
import 'screens/login_page.dart';

void main() {
  runApp(const StudyFlow());
}

class StudyFlow extends StatelessWidget {
  const StudyFlow({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,

      title: 'StudyFlow',

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

      home: const LoginPage(),
    );
  }
}