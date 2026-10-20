
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../services/study_data.dart';

class AgendaPage extends StatefulWidget {
  const AgendaPage({super.key});

  @override
  State<AgendaPage> createState() => _AgendaPageState();
}

class _AgendaPageState extends State<AgendaPage> {
  final TextEditingController tituloController =
      TextEditingController();

  final TextEditingController descricaoController =
      TextEditingController();

  DateTime? dataSelecionada;

  final Color roxo = const Color(0xFF5E35B1);

  Future<void> selecionarData(
    BuildContext contexto,
    void Function(void Function()) atualizar,
  ) async {
    final data = await showDatePicker(
      context: contexto,
      initialDate: dataSelecionada ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2035),
      locale: const Locale('pt', 'BR'),
    );

    if (data != null) {
      atualizar(() {
        dataSelecionada = data;
      });
    }
  }

  String formatarData(DateTime data) {
    return '${data.day.toString().padLeft(2, '0')}/'
        '${data.month.toString().padLeft(2, '0')}/'
        '${data.year}';
  }

  String dataISO(DateTime data) {
    return '${data.year}-'
        '${data.month.toString().padLeft(2, '0')}-'
        '${data.day.toString().padLeft(2, '0')}';
  }

  Future<void> abrirFormulario({String? id}) async {
    if (id != null) {
      final documento =
          await StudyData.compromissosBanco.doc(id).get();

      if (!documento.exists || !mounted) return;

      final dados = documento.data()!;

      tituloController.text = dados['titulo'] ?? '';
      descricaoController.text = dados['descricao'] ?? '';
      dataSelecionada = DateTime.parse(dados['dataISO']);
    } else {
      tituloController.clear();
      descricaoController.clear();
      dataSelecionada = null;
    }

    if (!mounted) return;

    await showDialog(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, atualizarDialogo) {
            return AlertDialog(
              title: Text(
                id == null
                    ? 'Novo compromisso'
                    : 'Editar compromisso',
              ),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: tituloController,
                      decoration: const InputDecoration(
                        labelText: 'Título',
                        hintText: 'Ex.: Revisar matemática',
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: descricaoController,
                      maxLines: 3,
                      decoration: const InputDecoration(
                        labelText: 'Descrição',
                        hintText: 'O que você precisa estudar?',
                      ),
                    ),
                    const SizedBox(height: 16),
                    OutlinedButton.icon(
                      onPressed: () => selecionarData(
                        dialogContext,
                        atualizarDialogo,
                      ),
                      icon: const Icon(Icons.calendar_month),
                      label: Text(
                        dataSelecionada == null
                            ? 'Escolher data'
                            : formatarData(dataSelecionada!),
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () =>
                      Navigator.pop(dialogContext),
                  child: const Text('Cancelar'),
                ),
                ElevatedButton(
                  onPressed: () async {
                    if (tituloController.text.trim().isEmpty ||
                        dataSelecionada == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            'Informe o título e escolha uma data.',
                          ),
                        ),
                      );
                      return;
                    }

                    final data = dataSelecionada!;

                    final compromisso = <String, dynamic>{
                      'titulo': tituloController.text.trim(),
                      'descricao':
                          descricaoController.text.trim(),
                      'data': formatarData(data),
                      'dataISO': dataISO(data),
                      'atualizadoEm':
                          FieldValue.serverTimestamp(),
                    };

                    try {
                      if (id == null) {
                        compromisso['criadoEm'] =
                            FieldValue.serverTimestamp();

                        await StudyData.compromissosBanco
                            .add(compromisso);
                      } else {
                        await StudyData.compromissosBanco
                            .doc(id)
                            .update(compromisso);
                      }

                      if (dialogContext.mounted) {
                        Navigator.pop(dialogContext);
                      }
                    } catch (erro) {
                      if (!mounted) return;

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            'Erro ao salvar compromisso: $erro',
                          ),
                        ),
                      );
                    }
                  },
                  child: const Text('Salvar'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Future<void> excluirCompromisso(String id) async {
    try {
      await StudyData.compromissosBanco.doc(id).delete();
    } catch (erro) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erro ao excluir compromisso: $erro'),
        ),
      );
    }
  }

  @override
  void dispose() {
    tituloController.dispose();
    descricaoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F3FA),
      appBar: AppBar(
        title: const Text('Minha agenda'),
        backgroundColor: roxo,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Agenda de estudos',
              style: TextStyle(
                fontSize: 27,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Organize suas revisões e seus horários de estudo.',
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () => abrirFormulario(),
                icon: const Icon(Icons.add),
                label: const Text('Novo compromisso'),
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                stream: StudyData.compromissosBanco.snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return const Center(
                      child: Text(
                        'Não foi possível carregar a agenda.',
                      ),
                    );
                  }

                  if (snapshot.connectionState ==
                      ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  final documentos =
                      snapshot.data?.docs.toList() ?? [];

                  documentos.sort((a, b) {
                    final dataA =
                        a.data()['dataISO'] as String? ?? '';
                    final dataB =
                        b.data()['dataISO'] as String? ?? '';

                    return dataA.compareTo(dataB);
                  });

                  if (documentos.isEmpty) {
                    return const Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.event_note,
                            size: 65,
                            color: Color(0xFF5E35B1),
                          ),
                          SizedBox(height: 12),
                          Text(
                            'Sua agenda está vazia.',
                            style: TextStyle(fontSize: 17),
                          ),
                          Text(
                            'Adicione seu primeiro compromisso!',
                          ),
                        ],
                      ),
                    );
                  }

                  return ListView.builder(
                    itemCount: documentos.length,
                    itemBuilder: (context, index) {
                      final documento = documentos[index];
                      final item = documento.data();

                      final titulo =
                          item['titulo'] as String? ?? '';
                      final descricao =
                          item['descricao'] as String? ?? '';
                      final data =
                          item['data'] as String? ?? '';

                      return Card(
                        margin:
                            const EdgeInsets.only(bottom: 12),
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor:
                                const Color(0xFFEDE7F6),
                            child: Icon(
                              Icons.event,
                              color: roxo,
                            ),
                          ),
                          title: Text(titulo),
                          subtitle: Text(
                            '$data\n'
                            '${descricao.isEmpty ? 'Sem descrição' : descricao}',
                          ),
                          isThreeLine: true,
                          trailing: PopupMenuButton<String>(
                            onSelected: (opcao) {
                              if (opcao == 'editar') {
                                abrirFormulario(id: documento.id);
                              } else if (opcao == 'excluir') {
                                excluirCompromisso(documento.id);
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
