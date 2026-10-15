
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CadastroPage extends StatefulWidget {
  const CadastroPage({super.key});

  @override
  State<CadastroPage> createState() => _CadastroPageState();
}

class _CadastroPageState extends State<CadastroPage> {
  final nomeController = TextEditingController();
  final emailController = TextEditingController();
  final senhaController = TextEditingController();
  final confirmarSenhaController = TextEditingController();

  bool carregando = false;
  bool mostrarSenha = false;

  Future<void> cadastrar() async {
    final nome = nomeController.text.trim();
    final email = emailController.text.trim();
    final senha = senhaController.text;
    final confirmarSenha = confirmarSenhaController.text;

    if (nome.isEmpty ||
        email.isEmpty ||
        senha.isEmpty ||
        confirmarSenha.isEmpty) {
      mostrarMensagem('Preencha todos os campos.');
      return;
    }

    if (senha.length < 6) {
      mostrarMensagem('A senha deve ter pelo menos 6 caracteres.');
      return;
    }

    if (senha != confirmarSenha) {
      mostrarMensagem('As senhas não são iguais.');
      return;
    }

    setState(() => carregando = true);

    try {
      // Cria a conta no Firebase Authentication.
      final resultado = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
        email: email,
        password: senha,
      );

      final usuario = resultado.user;

      if (usuario == null) {
        throw Exception('Não foi possível criar a conta.');
        
      }
      // Envia o e-mail para confirmar que o endereço é acessível.
      await usuario.sendEmailVerification();

      // Encerra a sessão até a pessoa verificar o e-mail.
      await FirebaseAuth.instance.signOut();

      // Salva o nome do estudante no Firestore.
      await FirebaseFirestore.instance
          .collection('users')
          .doc(usuario.uid)
          .set({
        'nome': nome,
        'email': email,
        'criadoEm': FieldValue.serverTimestamp(),
      });

      // Atualiza o nome do perfil no Firebase Authentication.
      await usuario.updateDisplayName(nome);

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Conta criada com sucesso! Faça seu login.'),
        ),
      );

      Navigator.pop(context);
    } on FirebaseAuthException catch (e) {
      String mensagem = 'Não foi possível criar a conta.';

      if (e.code == 'email-already-in-use') {
        mensagem = 'Este e-mail já está cadastrado.';
      } else if (e.code == 'invalid-email') {
        mensagem = 'Digite um e-mail válido.';
      } else if (e.code == 'weak-password') {
        mensagem = 'Escolha uma senha mais forte.';
      } else if (e.code == 'network-request-failed') {
        mensagem = 'Verifique sua conexão com a internet.';
      }

      if (mounted) mostrarMensagem(mensagem);
    } on FirebaseException catch (e) {
      // A conta pode ter sido criada mesmo se o Firestore falhar.
      if (mounted) {
        mostrarMensagem(
          e.code == 'permission-denied'
              ? 'Conta criada, mas o banco bloqueou o salvamento do perfil. Precisamos configurar as regras do Firestore.'
              : 'A conta foi criada, mas não foi possível salvar o perfil.',
        );
      }
    } catch (_) {
      if (mounted) {
        mostrarMensagem('Ocorreu um erro. Tente novamente.');
      }
    } finally {
      if (mounted) {
        setState(() => carregando = false);
      }
    }
  }

  void mostrarMensagem(String mensagem) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(mensagem)),
    );
  }

  @override
  void dispose() {
    nomeController.dispose();
    emailController.dispose();
    senhaController.dispose();
    confirmarSenhaController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F3FA),
      appBar: AppBar(
        title: const Text('Criar conta'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(25),
        child: Column(
          children: [
            const SizedBox(height: 20),
            const Text(
              'Criar sua conta',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Color(0xFF5E35B1),
              ),
            ),
            const SizedBox(height: 30),

            TextField(
              controller: nomeController,
              textCapitalization: TextCapitalization.words,
              decoration: InputDecoration(
                labelText: 'Nome',
                prefixIcon: const Icon(Icons.person_outline),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 15),

            TextField(
              controller: emailController,
              keyboardType: TextInputType.emailAddress,
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
              decoration: InputDecoration(
                labelText: 'Senha',
                prefixIcon: const Icon(Icons.lock_outline),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 15),

            TextField(
              controller: confirmarSenhaController,
              obscureText: !mostrarSenha,
              decoration: InputDecoration(
                labelText: 'Confirmar senha',
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
            ),
            const SizedBox(height: 25),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: carregando ? null : cadastrar,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF5E35B1),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: carregando
                    ? const SizedBox(
                        height: 22,
                        width: 22,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : const Text('Cadastrar'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
