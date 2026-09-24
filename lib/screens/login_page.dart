import 'package:flutter/material.dart';
import 'cadastro_page.dart';
import 'home_page.dart';


class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F3FA),

      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(25),

          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,

            children: [
              const Text(
                'StudyFlow',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF5E35B1),
                ),
              ),

              const SizedBox(height: 10),

              const Text(
                'Organize seus estudos de forma simples',
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 40),

              TextField(
                decoration: InputDecoration(
                  labelText: 'E-mail',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),

              const SizedBox(height: 15),

              TextField(
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Senha',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),

              const SizedBox(height: 25),

           SizedBox(
  width: double.infinity,
  child: ElevatedButton(
    onPressed: () {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const HomePage(),
        ),
      );
    },
    child: const Text('Entrar'),
  ),
),

              const SizedBox(height: 10),

             TextButton(
              onPressed: () {
             Navigator.push(
              context,
             MaterialPageRoute(
              builder: (context) => const CadastroPage(),
      ),
    );
  },
  child: const Text('Criar uma conta'),
),
            ],
          ),
        ),
      ),
    );
  }
}