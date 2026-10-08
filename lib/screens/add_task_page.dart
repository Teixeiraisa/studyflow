import 'package:flutter/material.dart';

class AddTaskPage extends StatefulWidget {
  final Map<String, String>? tarefa;

  const AddTaskPage({
    super.key,
    this.tarefa,
  });

  @override
  State<AddTaskPage> createState() => _AddTaskPageState();
}

class _AddTaskPageState extends State<AddTaskPage> {
  final nomeController = TextEditingController();
  final materiaController = TextEditingController();

  String tipoSelecionado = 'Tarefa';
  DateTime? dataSelecionada;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F3FA),

      appBar: AppBar(
        title: const Text('Adicionar tarefa'),
        backgroundColor: const Color(0xFF5E35B1),
        foregroundColor: Colors.white,
      ),

      body: Padding(
        padding: const EdgeInsets.all(20),

        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Nova tarefa',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 30),

            TextField(
              controller: nomeController,
              decoration: InputDecoration(
                labelText: 'Nome da tarefa',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),

            const SizedBox(height: 15),

            TextField(
              controller: materiaController,
              decoration: InputDecoration(
                labelText: 'Matéria',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),

            const SizedBox(height: 15),

            DropdownButtonFormField<String>(
              value: tipoSelecionado,
              decoration: InputDecoration(
                labelText: 'Tipo',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              items: const [
                DropdownMenuItem(
                  value: 'Tarefa',
                  child: Text('Tarefa'),
                ),
                DropdownMenuItem(
                  value: 'Prova',
                  child: Text('Prova'),
                ),
              ],
              onChanged: (valor) {
                setState(() {
                  tipoSelecionado = valor!;
                });
              },
            ),

            const SizedBox(height: 15),

            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () async {
                  final hoje = DateTime.now();

                  final data = await showDatePicker(
                    context: context,
                    initialDate: hoje,
                    firstDate: hoje,
                    lastDate: DateTime(2035),
                  );

                  if (data != null) {
                    setState(() {
                      dataSelecionada = data;
                    });
                  }
                },
                icon: const Icon(Icons.calendar_today),
                label: Text(
                  dataSelecionada == null
                      ? 'Escolher data'
                      : '${dataSelecionada!.day}/${dataSelecionada!.month}/${dataSelecionada!.year}',
                ),
              ),
            ),

            const SizedBox(height: 25),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  if (nomeController.text.trim().isEmpty ||
                      materiaController.text.trim().isEmpty ||
                      dataSelecionada == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          'Preencha todos os campos e escolha uma data.',
                        ),
                      ),
                    );
                    return;
                  }

                  Navigator.pop(
                    context,
                    {
                      'nome': nomeController.text.trim(),
                      'materia': materiaController.text.trim(),
                      'tipo': tipoSelecionado,
                      'data':
                          '${dataSelecionada!.day}/${dataSelecionada!.month}/${dataSelecionada!.year}',
                    },
                  );
                },
                child: const Text('Cadastrar tarefa'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}