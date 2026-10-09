
import 'package:flutter/material.dart';
import '../services/study_data.dart';

class AgendaPage extends StatefulWidget {
  const AgendaPage({super.key});

  @override
  State<AgendaPage> createState() => _AgendaPageState();
}

class _AgendaPageState extends State<AgendaPage> {
 List<Map<String, String>> get compromissos =>
    StudyData.compromissos;

  final TextEditingController tituloController =
      TextEditingController();

  final TextEditingController descricaoController =
      TextEditingController();

  DateTime? dataSelecionada;

  final Color roxo = const Color(0xFF5E35B1);

  Future<void> selecionarData() async {
    final data = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2035),
      locale: const Locale('pt', 'BR'),
    );

    if (data != null) {
      setState(() {
        dataSelecionada = data;
      });
    }
  }

  void abrirFormulario({int? indice}) {
    if (indice != null) {
      tituloController.text = compromissos[indice]['titulo']!;
      descricaoController.text =
          compromissos[indice]['descricao']!;
      dataSelecionada = DateTime.parse(
        compromissos[indice]['dataISO']!,
      );
    } else {
      tituloController.clear();
      descricaoController.clear();
      dataSelecionada = null;
    }

    showDialog(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, atualizarDialogo) {
            return AlertDialog(
              title: Text(
                indice == null
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
                      onPressed: () async {
                        final data = await showDatePicker(
                          context: dialogContext,
                          initialDate:
                              dataSelecionada ?? DateTime.now(),
                          firstDate: DateTime.now(),
                          lastDate: DateTime(2035),
                          locale: const Locale('pt', 'BR'),
                        );

                        if (data != null) {
                          atualizarDialogo(() {
                            dataSelecionada = data;
                          });
                        }
                      },
                      icon: const Icon(Icons.calendar_month),
                      label: Text(
                        dataSelecionada == null
                            ? 'Escolher data'
                            : '${dataSelecionada!.day.toString().padLeft(2, '0')}/'
                                '${dataSelecionada!.month.toString().padLeft(2, '0')}/'
                                '${dataSelecionada!.year}',
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(dialogContext);
                  },
                  child: const Text('Cancelar'),
                ),
                ElevatedButton(
                  onPressed: () {
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
                    final dataFormatada =
                        '${data.day.toString().padLeft(2, '0')}/'
                        '${data.month.toString().padLeft(2, '0')}/'
                        '${data.year}';

                    final compromisso = <String, String>{
                      'titulo': tituloController.text.trim(),
                      'descricao': descricaoController.text.trim(),
                      'data': dataFormatada,
                      'dataISO':
                          '${data.year}-${data.month.toString().padLeft(2, '0')}-${data.day.toString().padLeft(2, '0')}',
                    };

                    setState(() {
                      if (indice == null) {
                        compromissos.add(compromisso);
                      } else {
                        compromissos[indice] = compromisso;
                      }

                      compromissos.sort(
                        (a, b) => a['dataISO']!.compareTo(
                          b['dataISO']!,
                        ),
                      );
                    });

                    Navigator.pop(dialogContext);
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
              child: compromissos.isEmpty
                  ? const Center(
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
                          Text('Adicione seu primeiro compromisso!'),
                        ],
                      ),
                    )
                  : ListView.builder(
                      itemCount: compromissos.length,
                      itemBuilder: (context, index) {
                        final item = compromissos[index];

                        return Card(
                          margin: const EdgeInsets.only(bottom: 12),
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundColor:
                                  const Color(0xFFEDE7F6),
                              child: Icon(
                                Icons.event,
                                color: roxo,
                              ),
                            ),
                            title: Text(item['titulo']!),
                            subtitle: Text(
                              '${item['data']}\n'
                              '${item['descricao']!.isEmpty ? 'Sem descrição' : item['descricao']}',
                            ),
                            isThreeLine: true,
                            trailing: PopupMenuButton<String>(
                              onSelected: (opcao) {
                                if (opcao == 'editar') {
                                  abrirFormulario(indice: index);
                                } else if (opcao == 'excluir') {
                                  setState(() {
                                    compromissos.removeAt(index);
                                  });
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
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
