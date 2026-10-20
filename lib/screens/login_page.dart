
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
  final TextEditingController emailController =
      TextEditingController();

  final TextEditingController senhaController =
      TextEditingController();

  bool carregando = false;
  bool mostrarSenha = false;

  static const Color roxo = Color(0xFF5E35B1);
  static const Color roxoEscuro = Color(0xFF302344);
  static const Color fundo = Color(0xFFF5F3FA);

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

        final usuarioAtualizado =
            FirebaseAuth.instance.currentUser;

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
          e.code == 'invalid-credential' ||
          e.code == 'wrong-password') {
        mensagem = 'E-mail ou senha incorretos.';
      } else if (e.code == 'invalid-email') {
        mensagem = 'Digite um e-mail válido.';
      } else if (e.code == 'too-many-requests') {
        mensagem =
            'Muitas tentativas. Tente novamente mais tarde.';
      } else if (e.code == 'network-request-failed') {
        mensagem = 'Verifique sua conexão com a internet.';
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(mensagem)),
      );
    } catch (e) {
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
      backgroundColor: fundo,
      body: SafeArea(
        child: Stack(
          children: [
            // Formas decorativas no fundo.
            const Positioned(
              top: -45,
              left: -45,
              child: _FormaDecorativa(
                tamanho: 190,
                cor: Color(0xFF9575CD),
              ),
            ),
            const Positioned(
              top: 110,
              right: -75,
              child: _FormaDecorativa(
                tamanho: 220,
                cor: Color(0xFF7E57C2),
              ),
            ),
            const Positioned(
              top: 390,
              left: -90,
              child: _FormaDecorativa(
                tamanho: 230,
                cor: Color(0xFFB39DDB),
              ),
            ),
            const Positioned(
              bottom: -100,
              right: -55,
              child: _FormaDecorativa(
                tamanho: 250,
                cor: Color(0xFF9575CD),
              ),
            ),

            // Conteúdo da tela.
            Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 20,
                ),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(
                    maxWidth: 420,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Logo oficial.
                      Image.asset(
                        'assets/logo_studyflow.png',
                        width: 190,
                        height: 190,
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            width: 130,
                            height: 130,
                            decoration: BoxDecoration(
                              color: roxo,
                              borderRadius: BorderRadius.circular(30),
                            ),
                            child: const Icon(
                              Icons.menu_book_rounded,
                              color: Colors.white,
                              size: 75,
                            ),
                          );
                        },
                      ),

                      const SizedBox(height: 8),

                      const Text(
                        'Welcome to StudyFlow',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 27,
                          fontWeight: FontWeight.bold,
                          color: roxo,
                        ),
                      ),

                      const SizedBox(height: 10),

                      const Text(
                        'Organize seus estudos e acompanhe seu progresso.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 14,
                          color: Color(0xFF6E6478),
                        ),
                      ),

                      const SizedBox(height: 30),

                      // Cartão de login.
                      Container(
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(24),
                          border: Border.all(
                            color: const Color(0xFFEDE7F6),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: roxo.withValues(alpha: 0.12),
                              blurRadius: 28,
                              offset: const Offset(0, 10),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment:
                              CrossAxisAlignment.stretch,
                          children: [
                            const Text(
                              'Entre na sua conta',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 21,
                                fontWeight: FontWeight.bold,
                                color: roxoEscuro,
                              ),
                            ),

                            const SizedBox(height: 24),

                            TextField(
                              controller: emailController,
                              keyboardType:
                                  TextInputType.emailAddress,
                              autofillHints: const [
                                AutofillHints.email,
                              ],
                              decoration: InputDecoration(
                                labelText: 'E-mail',
                                prefixIcon: const Icon(
                                  Icons.email_outlined,
                                  color: roxo,
                                ),
                                filled: true,
                                fillColor: fundo,
                                border: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.circular(14),
                                  borderSide: BorderSide.none,
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.circular(14),
                                  borderSide: BorderSide.none,
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.circular(14),
                                  borderSide: const BorderSide(
                                    color: roxo,
                                    width: 1.5,
                                  ),
                                ),
                              ),
                            ),

                            const SizedBox(height: 16),

                            TextField(
                              controller: senhaController,
                              obscureText: !mostrarSenha,
                              autofillHints: const [
                                AutofillHints.password,
                              ],
                              onSubmitted: (_) => entrar(),
                              decoration: InputDecoration(
                                labelText: 'Senha',
                                prefixIcon: const Icon(
                                  Icons.lock_outline,
                                  color: roxo,
                                ),
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    mostrarSenha
                                        ? Icons.visibility_off
                                        : Icons.visibility,
                                    color: roxo,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      mostrarSenha = !mostrarSenha;
                                    });
                                  },
                                ),
                                filled: true,
                                fillColor: fundo,
                                border: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.circular(14),
                                  borderSide: BorderSide.none,
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.circular(14),
                                  borderSide: BorderSide.none,
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.circular(14),
                                  borderSide: const BorderSide(
                                    color: roxo,
                                    width: 1.5,
                                  ),
                                ),
                              ),
                            ),

                            const SizedBox(height: 24),

                            SizedBox(
                              height: 52,
                              child: ElevatedButton(
                                onPressed:
                                    carregando ? null : entrar,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: roxo,
                                  foregroundColor: Colors.white,
                                  elevation: 2,
                                  shape: RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.circular(14),
                                  ),
                                ),
                                child: carregando
                                    ? const SizedBox(
                                        width: 23,
                                        height: 23,
                                        child:
                                            CircularProgressIndicator(
                                          color: Colors.white,
                                          strokeWidth: 2,
                                        ),
                                      )
                                    : const Text(
                                        'Entrar',
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                              ),
                            ),

                            const SizedBox(height: 12),

                            TextButton(
                              onPressed: carregando
                                  ? null
                                  : () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              const CadastroPage(),
                                        ),
                                      );
                                    },
                              child: const Text(
                                'Ainda não tem conta? Cadastre-se',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: roxo,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 22),

                      const Text(
                        'Seu próximo passo começa aqui.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 12,
                          color: Color(0xFF80758D),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Formas roxas suaves para decorar o fundo.
class _FormaDecorativa extends StatelessWidget {
  final double tamanho;
  final Color cor;

  const _FormaDecorativa({
    required this.tamanho,
    required this.cor,
  });

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Container(
        width: tamanho,
        height: tamanho,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: RadialGradient(
            colors: [
              cor.withValues(alpha: 0.22),
              cor.withValues(alpha: 0.10),
              cor.withValues(alpha: 0.0),
            ],
          ),
        ),
      ),
    );
  }
}
