import 'package:flutter/material.dart';
import 'add_task_page.dart';

class TasksPage extends StatefulWidget {
  const TasksPage({super.key});

  @override
  State<TasksPage> createState() => _TasksPageState();
}

class _TasksPageState extends State<TasksPage> {
  List<Map<String, String>> tarefas = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F3FA),

      appBar: AppBar(
        title: const Text('Minhas tarefas'),
        backgroundColor: const Color(0xFF5E35B1),
        foregroundColor: Colors.white,
      ),

      body: Padding(
        padding: const EdgeInsets.all(20),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Tarefas',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 10),

            const Text(
              'Acompanhe suas atividades e provas.',
            ),

            const SizedBox(height: 25),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () async {
                  final tarefa = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const AddTaskPage(),
                    ),
                  );

                  if (tarefa != null) {
                    setState(() {
                      tarefas.add({
                        'nome': tarefa['nome'],
                        'materia': tarefa['materia'],
                        'tipo': tarefa['tipo'],
                        'data': tarefa['data'],
                      });
                    });
                  }
                },
                icon: const Icon(Icons.add),
                label: const Text('Adicionar tarefa'),
              ),
            ),

            const SizedBox(height: 20),

            Expanded(
              child: tarefas.isEmpty
                  ? const Center(
                      child: Text(
                        'Nenhuma tarefa cadastrada.',
                        style: TextStyle(fontSize: 16),
                      ),
                    )
                  : ListView.builder(
                      itemCount: tarefas.length,
                      itemBuilder: (context, index) {
                        final tarefa = tarefas[index];

                        return Card(
                          child: ListTile(
                            leading: const Icon(
                              Icons.assignment,
                              color: Color(0xFF5E35B1),
                            ),

                            title: Text(
                              tarefa['nome']!,
                            ),

                            subtitle: Text(
                              'Matéria: ${tarefa['materia']}\n'
                              'Tipo: ${tarefa['tipo']}\n'
                              'Data: ${tarefa['data']}',
                            ),

                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                // EDITAR
                                IconButton(
                                  icon: const Icon(Icons.edit),
                                  onPressed: () async {
                                    final tarefaEditada =
                                        await Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => AddTaskPage(
                                          tarefa: tarefa,
                                        ),
                                      ),
                                    );

                                    if (tarefaEditada != null) {
                                      setState(() {
                                        tarefas[index] = {
                                          'nome': tarefaEditada['nome'],
                                          'materia':
                                              tarefaEditada['materia'],
                                          'tipo': tarefaEditada['tipo'],
                                          'data': tarefaEditada['data'],
                                        };
                                      });
                                    }
                                  },
                                ),

                                // EXCLUIR
                                IconButton(
                                  icon: const Icon(Icons.delete),
                                  onPressed: () {
                                    setState(() {
                                      tarefas.removeAt(index);
                                    });

                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(
                                      const SnackBar(
                                        content:
                                            Text('Tarefa excluída.'),
                                      ),
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}