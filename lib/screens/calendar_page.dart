
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../services/study_data.dart';

class CalendarPage extends StatefulWidget {
  final List<Map<String, String>> tarefas;

  const CalendarPage({
    super.key,
    required this.tarefas,
  });

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  DateTime mesAtual = DateTime.now();
  DateTime diaSelecionado = DateTime.now();

  final Color roxo = const Color(0xFF5E35B1);

  String formatarData(DateTime data) {
    return '${data.day.toString().padLeft(2, '0')}/'
        '${data.month.toString().padLeft(2, '0')}/'
        '${data.year}';
  }

  String formatarISO(DateTime data) {
    return '${data.year}-'
        '${data.month.toString().padLeft(2, '0')}-'
        '${data.day.toString().padLeft(2, '0')}';
  }

  bool mesmoDia(DateTime a, DateTime b) {
    return a.year == b.year &&
        a.month == b.month &&
        a.day == b.day;
  }

  void mudarMes(int quantidade) {
    setState(() {
      mesAtual = DateTime(
        mesAtual.year,
        mesAtual.month + quantidade,
        1,
      );
      diaSelecionado = mesAtual;
    });
  }

  @override
  Widget build(BuildContext context) {
    final primeiroDia = DateTime(
      mesAtual.year,
      mesAtual.month,
      1,
    );

    final quantidadeDias = DateTime(
      mesAtual.year,
      mesAtual.month + 1,
      0,
    ).day;

    final deslocamento = primeiroDia.weekday - 1;

    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
      stream: StudyData.tarefasBanco.snapshots(),
      builder: (context, tarefasSnapshot) {
        if (tarefasSnapshot.hasError) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Meu calendário'),
              backgroundColor: roxo,
              foregroundColor: Colors.white,
            ),
            body: const Center(
              child: Text('Erro ao carregar as tarefas.'),
            ),
          );
        }

        final tarefas = tarefasSnapshot.data?.docs ?? [];

        return StreamBuilder<
            QuerySnapshot<Map<String, dynamic>>>(
          stream: StudyData.compromissosBanco.snapshots(),
          builder: (context, compromissosSnapshot) {
            final compromissos =
                compromissosSnapshot.data?.docs ?? [];

            bool temAtividade(DateTime data) {
              final dataFormatada = formatarData(data);
              final dataISO = formatarISO(data);

              final temTarefa = tarefas.any((doc) {
                return doc.data()['data'] == dataFormatada;
              });

              final temCompromisso = compromissos.any((doc) {
                return doc.data()['dataISO'] == dataISO;
              });

              return temTarefa || temCompromisso;
            }

            final tarefasSelecionadas = tarefas.where((doc) {
              return doc.data()['data'] ==
                  formatarData(diaSelecionado);
            }).toList();

            final compromissosSelecionados =
                compromissos.where((doc) {
              return doc.data()['dataISO'] ==
                  formatarISO(diaSelecionado);
            }).toList();

            return Scaffold(
              backgroundColor: const Color(0xFFF5F3FA),
              appBar: AppBar(
                title: const Text('Meu calendário'),
                backgroundColor: roxo,
                foregroundColor: Colors.white,
              ),
              body: ListView(
                padding: const EdgeInsets.all(20),
                children: [
                  const Text(
                    'Organize seus estudos',
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Veja suas provas, tarefas e compromissos.',
                  ),
                  const SizedBox(height: 25),

                  Row(
                    mainAxisAlignment:
                        MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        onPressed: () => mudarMes(-1),
                        icon: const Icon(Icons.chevron_left),
                      ),
                      Text(
                        '${nomeMes(mesAtual.month)} '
                        '${mesAtual.year}',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      IconButton(
                        onPressed: () => mudarMes(1),
                        icon: const Icon(Icons.chevron_right),
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  Row(
                    children: ['S', 'T', 'Q', 'Q', 'S', 'S', 'D']
                        .map(
                          (dia) => Expanded(
                            child: Center(
                              child: Text(
                                dia,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                          ),
                        )
                        .toList(),
                  ),

                  const SizedBox(height: 12),

                  GridView.builder(
                    shrinkWrap: true,
                    physics:
                        const NeverScrollableScrollPhysics(),
                    itemCount: deslocamento + quantidadeDias,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 7,
                      mainAxisSpacing: 8,
                      crossAxisSpacing: 4,
                    ),
                    itemBuilder: (context, index) {
                      if (index < deslocamento) {
                        return const SizedBox();
                      }

                      final dia = index - deslocamento + 1;

                      final data = DateTime(
                        mesAtual.year,
                        mesAtual.month,
                        dia,
                      );

                      final selecionado =
                          mesmoDia(diaSelecionado, data);

                      final ehHoje =
                          mesmoDia(DateTime.now(), data);

                      return InkWell(
                        borderRadius: BorderRadius.circular(12),
                        onTap: () {
                          setState(() {
                            diaSelecionado = data;
                          });
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: selecionado
                                ? roxo
                                : Colors.white,
                            borderRadius:
                                BorderRadius.circular(12),
                            border: ehHoje && !selecionado
                                ? Border.all(
                                    color: roxo,
                                    width: 2,
                                  )
                                : null,
                          ),
                          child: Column(
                            mainAxisAlignment:
                                MainAxisAlignment.center,
                            children: [
                              Text(
                                '$dia',
                                style: TextStyle(
                                  color: selecionado
                                      ? Colors.white
                                      : Colors.black87,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              if (temAtividade(data))
                                Container(
                                  margin:
                                      const EdgeInsets.only(top: 3),
                                  width: 5,
                                  height: 5,
                                  decoration: BoxDecoration(
                                    color: selecionado
                                        ? Colors.white
                                        : roxo,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),

                  const SizedBox(height: 30),

                  Text(
                    'Agenda de ${formatarData(diaSelecionado)}',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 12),

                  if (tarefasSnapshot.connectionState ==
                          ConnectionState.waiting ||
                      compromissosSnapshot.connectionState ==
                          ConnectionState.waiting)
                    const Center(
                      child: CircularProgressIndicator(),
                    )
                  else if (tarefasSelecionadas.isEmpty &&
                      compromissosSelecionados.isEmpty)
                    const Card(
                      child: Padding(
                        padding: EdgeInsets.all(18),
                        child: Text(
                          'Nenhuma atividade para este dia.',
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),

                  ...tarefasSelecionadas.map((doc) {
                    final tarefa = doc.data();

                    return Card(
                      child: ListTile(
                        leading: Icon(
                          tarefa['tipo'] == 'Prova'
                              ? Icons.quiz
                              : Icons.assignment,
                          color: roxo,
                        ),
                        title: Text(
                          tarefa['nome'] as String? ?? '',
                        ),
                        subtitle: Text(
                          '${tarefa['materia'] ?? ''} • '
                          '${tarefa['tipo'] ?? 'Tarefa'}',
                        ),
                      ),
                    );
                  }),

                  if (compromissosSelecionados.isNotEmpty) ...[
                    const SizedBox(height: 15),
                    const Text(
                      'Compromissos de estudo',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),

                    ...compromissosSelecionados.map((doc) {
                      final item = doc.data();
                      final descricao =
                          item['descricao'] as String? ?? '';

                      return Card(
                        child: ListTile(
                          leading: Icon(
                            Icons.menu_book,
                            color: roxo,
                          ),
                          title: Text(
                            item['titulo'] as String? ?? '',
                          ),
                          subtitle: Text(
                            descricao.isEmpty
                                ? 'Sem descrição'
                                : descricao,
                          ),
                        ),
                      );
                    }),
                  ],
                ],
              ),
            );
          },
        );
      },
    );
  }

  String nomeMes(int mes) {
    const meses = [
      'Janeiro',
      'Fevereiro',
      'Março',
      'Abril',
      'Maio',
      'Junho',
      'Julho',
      'Agosto',
      'Setembro',
      'Outubro',
      'Novembro',
      'Dezembro',
    ];

    return meses[mes - 1];
  }
}
