
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'cadastro_page.dart';
import 'main_navigation.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController senhaController = TextEditingController();

  bool carregando = false;
  bool mostrarSenha = false;

  Future<void> entrar() async {
    final email = emailController.text.trim();
    final senha = senhaController.text;

    if (email.isEmpty || senha.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Preencha o e-mail e a senha.'),
        ),
      );
      return;
    }

    setState(() => carregando = true);

    try {
     final resultado = await FirebaseAuth.instance
    .signInWithEmailAndPassword(
  email: email,
  password: senha,
);

final usuario = resultado.user;

if (usuario != null) {
  await usuario.reload();

  final usuarioAtualizado = FirebaseAuth.instance.currentUser;

  if (usuarioAtualizado == null ||
      !usuarioAtualizado.emailVerified) {
    await FirebaseAuth.instance.signOut();

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'Confirme seu e-mail pelo link enviado antes de entrar.',
        ),
      ),
    );

    return;
  }
}

      if (!mounted) return;

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const MainNavigation(),
        ),
      );
    } on FirebaseAuthException catch (e) {
      if (!mounted) return;

      String mensagem = 'Não foi possível fazer login.';

      if (e.code == 'user-not-found' ||
          e.code == 'invalid-credential') {
        mensagem = 'E-mail ou senha incorretos.';
      } else if (e.code == 'wrong-password') {
        mensagem = 'Senha incorreta.';
      } else if (e.code == 'invalid-email') {
        mensagem = 'Digite um e-mail válido.';
      } else if (e.code == 'too-many-requests') {
        mensagem = 'Muitas tentativas. Tente novamente mais tarde.';
      } else if (e.code == 'network-request-failed') {
        mensagem = 'Verifique sua conexão com a internet.';
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(mensagem)),
      );
    } catch (_) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Ocorreu um erro. Tente novamente.'),
        ),
      );
    } finally {
      if (mounted) {
        setState(() => carregando = false);
      }
    }
  }

  @override
  void dispose() {
    emailController.dispose();
    senhaController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F3FA),
      body: Center(
        child: SingleChildScrollView(
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
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                autofillHints: const [AutofillHints.email],
                decoration: InputDecoration(
                  labelText: 'E-mail',
                  prefixIcon: const Icon(Icons.email_outlined),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 15),

              TextField(
                controller: senhaController,
                obscureText: !mostrarSenha,
                autofillHints: const [AutofillHints.password],
                decoration: InputDecoration(
                  labelText: 'Senha',
                  prefixIcon: const Icon(Icons.lock_outline),
                  suffixIcon: IconButton(
                    icon: Icon(
                      mostrarSenha
                          ? Icons.visibility_off
                          : Icons.visibility,
                    ),
                    onPressed: () {
                      setState(() => mostrarSenha = !mostrarSenha);
                    },
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onSubmitted: (_) => entrar(),
              ),
              const SizedBox(height: 25),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF5E35B1),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: carregando ? null : entrar,
                  child: carregando
                      ? const SizedBox(
                          height: 22,
                          width: 22,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : const Text('Entrar'),
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
                child: const Text(
                  'Criar uma conta',
                  style: TextStyle(
                    color: Color(0xFF5E35B1),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
