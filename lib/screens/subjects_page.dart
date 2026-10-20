
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../services/study_data.dart';
import 'add_subject_page.dart';

class SubjectsPage extends StatefulWidget {
  const SubjectsPage({super.key});

  @override
  State<SubjectsPage> createState() => _SubjectsPageState();
}

class _SubjectsPageState extends State<SubjectsPage> {
  Future<void> abrirCadastro({String? id, Map<String, String>? materia}) async {
    final resultado = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddSubjectPage(materia: materia),
      ),
    );

    if (resultado == null || !mounted) return;

    try {
      final dados = <String, dynamic>{
        'nome': resultado['nome'] ?? '',
        'professor': resultado['professor'] ?? '',
        'cor': resultado['cor'] ?? '0xFF5E35B1',
      };

      if (id == null) {
        await StudyData.materias.add(dados);
      } else {
        await StudyData.materias.doc(id).update(dados);
      }
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Não foi possível salvar a matéria.'),
        ),
      );
    }
  }

  Future<void> excluirMateria(String id) async {
    try {
      await StudyData.materias.doc(id).delete();

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Matéria excluída!'),
        ),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Não foi possível excluir a matéria.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F3FA),
      appBar: AppBar(
        title: const Text('Minhas matérias'),
        backgroundColor: const Color(0xFF5E35B1),
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Matérias',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'Organize suas matérias e acompanhe seus estudos.',
            ),
            const SizedBox(height: 25),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () => abrirCadastro(),
                icon: const Icon(Icons.add),
                label: const Text('Adicionar matéria'),
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                stream: StudyData.materias.snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return const Center(
                      child: Text('Erro ao carregar matérias.'),
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
                      child: Text('Nenhuma matéria cadastrada ainda.'),
                    );
                  }

                  return ListView.builder(
                    itemCount: documentos.length,
                    itemBuilder: (context, index) {
                      final documento = documentos[index];
                      final dados = documento.data();

                      final materia = <String, String>{
                        'nome': dados['nome']?.toString() ?? '',
                        'professor':
                            dados['professor']?.toString() ?? '',
                        'cor': dados['cor']?.toString() ??
                            '0xFF5E35B1',
                      };

                      final valorCor = int.tryParse(materia['cor']!) ??
                          0xFF5E35B1;

                      return Card(
                        child: ListTile(
                          leading: Icon(
                            Icons.book,
                            color: Color(valorCor),
                          ),
                          title: Text(materia['nome']!),
                          subtitle: Text(
                            'Professor: ${materia['professor']}',
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.edit),
                                onPressed: () => abrirCadastro(
                                  id: documento.id,
                                  materia: materia,
                                ),
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete),
                                onPressed: () => excluirMateria(
                                  documento.id,
                                ),
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
