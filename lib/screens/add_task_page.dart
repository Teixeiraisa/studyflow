
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

  bool get editando => widget.tarefa != null;

  @override
  void initState() {
    super.initState();

    final tarefa = widget.tarefa;

    if (tarefa != null) {
      nomeController.text = tarefa['nome'] ?? '';
      materiaController.text = tarefa['materia'] ?? '';

      final tipo = tarefa['tipo'];
      if (tipo == 'Tarefa' || tipo == 'Prova') {
        tipoSelecionado = tipo!;
      }

      // Recupera a data salva no formato dia/mês/ano.
      final partes = (tarefa['data'] ?? '').split('/');

      if (partes.length == 3) {
        final dia = int.tryParse(partes[0]);
        final mes = int.tryParse(partes[1]);
        final ano = int.tryParse(partes[2]);

        if (dia != null && mes != null && ano != null) {
          dataSelecionada = DateTime.tryParse(
            '${ano.toString().padLeft(4, '0')}-'
            '${mes.toString().padLeft(2, '0')}-'
            '${dia.toString().padLeft(2, '0')}',
          );
        }
      }
    }
  }

  @override
  void dispose() {
    nomeController.dispose();
    materiaController.dispose();
    super.dispose();
  }

  String formatarData(DateTime data) {
    return '${data.day.toString().padLeft(2, '0')}/'
        '${data.month.toString().padLeft(2, '0')}/'
        '${data.year}';
  }

  Future<void> escolherData() async {
    final hoje = DateUtils.dateOnly(DateTime.now());
    final inicial = dataSelecionada ?? hoje;

    final data = await showDatePicker(
      context: context,
      initialDate: inicial.isBefore(hoje) ? hoje : inicial,
      firstDate: hoje,
      lastDate: DateTime(2035),
    );

    if (data != null && mounted) {
      setState(() {
        dataSelecionada = data;
      });
    }
  }

  void salvarTarefa() {
    final nome = nomeController.text.trim();
    final materia = materiaController.text.trim();

    if (nome.isEmpty ||
        materia.isEmpty ||
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
      <String, String>{
        'nome': nome,
        'materia': materia,
        'tipo': tipoSelecionado,
        'data': formatarData(dataSelecionada!),
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F3FA),
      appBar: AppBar(
        title: Text(editando ? 'Editar tarefa' : 'Adicionar tarefa'),
        backgroundColor: const Color(0xFF5E35B1),
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              editando ? 'Editar tarefa' : 'Nova tarefa',
              style: const TextStyle(
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
                if (valor != null) {
                  setState(() {
                    tipoSelecionado = valor;
                  });
                }
              },
            ),
            const SizedBox(height: 15),

            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: escolherData,
                icon: const Icon(Icons.calendar_today),
                label: Text(
                  dataSelecionada == null
                      ? 'Escolher data'
                      : formatarData(dataSelecionada!),
                ),
              ),
            ),
            const SizedBox(height: 25),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: salvarTarefa,
                child: Text(
                  editando ? 'Salvar alterações' : 'Cadastrar tarefa',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
