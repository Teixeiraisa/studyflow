import 'package:flutter/material.dart';
final nomeController = TextEditingController();
final professorController = TextEditingController();

class AddSubjectPage extends StatefulWidget {
  final Map<String, String>? materia;

  const AddSubjectPage({
    super.key,
    this.materia,
  });

  @override
  State<AddSubjectPage> createState() => _AddSubjectPageState();
}

class _AddSubjectPageState extends State<AddSubjectPage> {
  Color corSelecionada = const Color(0xFF5E35B1);

  @override
void initState() {
  super.initState();

  if (widget.materia != null) {
    nomeController.text = widget.materia!['nome']!;
    professorController.text = widget.materia!['professor']!;
  }
}

Widget _botaoCor(Color cor) {
  return GestureDetector(
    onTap: () {
      setState(() {
        corSelecionada = cor;
      });
    },
    child: Container(
      margin: const EdgeInsets.symmetric(horizontal: 6),
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: cor,
        shape: BoxShape.circle,
        border: Border.all(
          color: corSelecionada == cor
              ? Colors.black
              : Colors.transparent,
          width: 3,
        ),
      ),
    ),
  );
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F3FA),
      appBar: AppBar(
        title: Text(
      widget.materia == null
      ? 'Adicionar matéria'
      : 'Editar matéria',
),
        backgroundColor: const Color(0xFF5E35B1),
        foregroundColor: Colors.white,
      ),

      body: Padding(
        padding: const EdgeInsets.all(20),

        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
           Text(
           widget.materia == null
            ? 'Nova matéria'
            : 'Editar matéria',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 30),

            TextField(
                controller: nomeController,
                decoration: InputDecoration(
                 labelText: 'Nome da matéria',
                 border: OutlineInputBorder(
                   borderRadius: BorderRadius.circular(12),
                 ),
              ),
            ),

            const SizedBox(height: 15),

            TextField(
              controller: professorController,    
              decoration: InputDecoration(
                labelText: 'Professor',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),

           const Align(
  alignment: Alignment.centerLeft,
  child: Text(
    'Cor da matéria',
    style: TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.bold,
    ),
  ),
),

const SizedBox(height: 10),

Row(
  mainAxisAlignment: MainAxisAlignment.center,
  children: [
    _botaoCor(const Color(0xFF5E35B1)),
    _botaoCor(Colors.blue),
    _botaoCor(Colors.green),
    _botaoCor(Colors.red),
    _botaoCor(Colors.orange),
  ],
),

const SizedBox(height: 25),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
              onPressed: () {
  if (nomeController.text.trim().isEmpty ||
      professorController.text.trim().isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Preencha todos os campos.'),
      ),
    );
    return;
  }

  Navigator.pop(
    context,
    {
      'nome': nomeController.text.trim(),
      'professor': professorController.text.trim(),
    },
  );
},
                child: Text(
                 widget.materia == null
                  ? 'Cadastrar matéria'
                  : 'Salvar alterações',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}