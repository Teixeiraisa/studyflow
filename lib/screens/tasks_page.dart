
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../services/study_data.dart';
import 'add_task_page.dart';

class TasksPage extends StatefulWidget {
  const TasksPage({super.key});

  @override
  State<TasksPage> createState() => _TasksPageState();
}

class _TasksPageState extends State<TasksPage> {
  Future<void> abrirCadastro({
    String? id,
    Map<String, String>? tarefa,
  }) async {
    final resultado = await Navigator.push<Map<String, String>>(
      context,
      MaterialPageRoute(
        builder: (context) => AddTaskPage(tarefa: tarefa),
      ),
    );

    if (resultado == null || !mounted) return;

    try {
      final dados = <String, dynamic>{
        ...resultado,
        'concluida': false,
      };

      if (id == null) {
        await StudyData.tarefasBanco.add(dados);
      } else {
        // Preserva o estado de conclusão ao editar.
        final documento = await StudyData.tarefasBanco.doc(id).get();
        dados['concluida'] = documento.data()?['concluida'] ?? false;

        await StudyData.tarefasBanco.doc(id).update(dados);
      }
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Não foi possível salvar a tarefa.'),
        ),
      );
    }
  }

  Future<void> excluirTarefa(String id) async {
    try {
      await StudyData.tarefasBanco.doc(id).delete();

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Tarefa excluída.')),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Não foi possível excluir a tarefa.'),
        ),
      );
    }
  }

  Future<void> alternarConclusao(
    String id,
    bool concluida,
  ) async {
    try {
      await StudyData.tarefasBanco.doc(id).update({
        'concluida': !concluida,
      });
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Não foi possível atualizar a tarefa.'),
        ),
      );
    }
  }

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
            const Text('Acompanhe suas atividades e provas.'),
            const SizedBox(height: 25),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () => abrirCadastro(),
                icon: const Icon(Icons.add),
                label: const Text('Adicionar tarefa'),
              ),
            ),

            const SizedBox(height: 20),

            Expanded(
              child: StreamBuilder<
                  QuerySnapshot<Map<String, dynamic>>>(
                stream: StudyData.tarefasBanco.snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return const Center(
                      child: Text('Erro ao carregar tarefas.'),
                    );
                  }

                  if (snapshot.connectionState ==
                      ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  final documentos = snapshot.data?.docs ?? [];

                  if (documentos.isEmpty) {
                    return const Center(
                      child: Text(
                        'Nenhuma tarefa cadastrada.',
                        style: TextStyle(fontSize: 16),
                      ),
                    );
                  }

                  return ListView.builder(
                    itemCount: documentos.length,
                    itemBuilder: (context, index) {
                      final documento = documentos[index];
                      final dados = documento.data();

                      final nome = dados['nome']?.toString() ?? '';
                      final materia =
                          dados['materia']?.toString() ?? '';
                      final tipo = dados['tipo']?.toString() ?? '';
                      final data = dados['data']?.toString() ?? '';
                      final concluida =
                          dados['concluida'] == true;

                      final tarefa = <String, String>{
                        'nome': nome,
                        'materia': materia,
                        'tipo': tipo,
                        'data': data,
                      };

                      return Card(
                        child: ListTile(
                          leading: Checkbox(
                            value: concluida,
                            activeColor: const Color(0xFF5E35B1),
                            onChanged: (_) => alternarConclusao(
                              documento.id,
                              concluida,
                            ),
                          ),
                          title: Text(
                            nome,
                            style: TextStyle(
                              decoration: concluida
                                  ? TextDecoration.lineThrough
                                  : TextDecoration.none,
                            ),
                          ),
                          subtitle: Text(
                            'Matéria: $materia\n'
                            'Tipo: $tipo\n'
                            'Data: $data',
                          ),
                          isThreeLine: true,
                          trailing: PopupMenuButton<String>(
                            onSelected: (opcao) {
                              if (opcao == 'editar') {
                                abrirCadastro(
                                  id: documento.id,
                                  tarefa: tarefa,
                                );
                              } else if (opcao == 'excluir') {
                                excluirTarefa(documento.id);
                              }
                            },
                            itemBuilder: (context) => const [
                              PopupMenuItem(
                                value: 'editar',
                                child: Text('Editar'),
                              ),
                              PopupMenuItem(
                                value: 'excluir',
                                child: Text('Excluir'),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
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
