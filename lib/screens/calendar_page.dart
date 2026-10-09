
import 'package:flutter/material.dart';
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

  String formatarDataISO(DateTime data) {
    return '${data.year}-'
        '${data.month.toString().padLeft(2, '0')}-'
        '${data.day.toString().padLeft(2, '0')}';
  }

  bool temTarefa(DateTime dia) {
    final tarefasNoDia = widget.tarefas.any((tarefa) {
      return tarefa['data'] == formatarData(dia);
    });

    final compromissosNoDia = StudyData.compromissos.any((item) {
      return item['dataISO'] == formatarDataISO(dia);
    });

    return tarefasNoDia || compromissosNoDia;
  }

  List<Map<String, String>> tarefasDoDia() {
    return widget.tarefas.where((tarefa) {
      return tarefa['data'] == formatarData(diaSelecionado);
    }).toList();
  }

  List<Map<String, String>> compromissosDoDia() {
    return StudyData.compromissos.where((item) {
      return item['dataISO'] == formatarDataISO(diaSelecionado);
    }).toList();
  }

  void mudarMes(int quantidade) {
    setState(() {
      mesAtual = DateTime(
        mesAtual.year,
        mesAtual.month + quantidade,
        1,
      );

      // Seleciona um dia do mês que está sendo exibido.
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
    final tarefasSelecionadas = tarefasDoDia();
    final compromissosSelecionados = compromissosDoDia();

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

          const Text('Veja suas provas, tarefas e compromissos.'),

          const SizedBox(height: 25),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                onPressed: () => mudarMes(-1),
                icon: const Icon(Icons.chevron_left),
              ),
              Text(
                '${_nomeMes(mesAtual.month)} ${mesAtual.year}',
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
            physics: const NeverScrollableScrollPhysics(),
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
                  diaSelecionado.year == data.year &&
                  diaSelecionado.month == data.month &&
                  diaSelecionado.day == data.day;

              final hoje = DateTime.now();

              final ehHoje =
                  hoje.year == data.year &&
                  hoje.month == data.month &&
                  hoje.day == data.day;

              return InkWell(
                borderRadius: BorderRadius.circular(12),
                onTap: () {
                  setState(() {
                    diaSelecionado = data;
                  });
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: selecionado ? roxo : Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: ehHoje && !selecionado
                        ? Border.all(color: roxo, width: 2)
                        : null,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
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
                      if (temTarefa(data))
                        Container(
                          margin: const EdgeInsets.only(top: 3),
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

          if (tarefasSelecionadas.isEmpty &&
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

          ...tarefasSelecionadas.map(
            (tarefa) => Card(
              child: ListTile(
                leading: Icon(
                  tarefa['tipo'] == 'Prova'
                      ? Icons.quiz
                      : Icons.assignment,
                  color: roxo,
                ),
                title: Text(tarefa['nome'] ?? ''),
                subtitle: Text(
                  '${tarefa['materia'] ?? ''} • '
                  '${tarefa['tipo'] ?? 'Tarefa'}',
                ),
              ),
            ),
          ),

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
            ...compromissosSelecionados.map(
              (item) => Card(
                child: ListTile(
                  leading: Icon(
                    Icons.menu_book,
                    color: roxo,
                  ),
                  title: Text(item['titulo'] ?? ''),
                  subtitle: Text(
                    (item['descricao'] ?? '').isEmpty
                        ? 'Sem descrição'
                        : item['descricao']!,
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  String _nomeMes(int mes) {
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
