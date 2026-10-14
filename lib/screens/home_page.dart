
import 'package:flutter/material.dart';
import '../services/study_data.dart';

class HomePage extends StatelessWidget {
  final ValueChanged<int> onNavigate;

  const HomePage({
    super.key,
    required this.onNavigate,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F3FA),

      appBar: AppBar(
        title: const Text(
          'StudyFlow',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xFF5E35B1),
        foregroundColor: Colors.white,
        elevation: 0,
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Olá! 👋',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Color(0xFF302344),
              ),
            ),

            const SizedBox(height: 6),

            const Text(
              'Organize seus estudos e acompanhe seu progresso.',
              style: TextStyle(
                fontSize: 15,
                color: Color(0xFF6E6478),
              ),
            ),

            const SizedBox(height: 28),

            const Text(
              'Resumo dos estudos',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF302344),
              ),
            ),

            const SizedBox(height: 14),

            Row(
              children: [
                Expanded(
                  child: _cartaoResumo(
                    icone: Icons.menu_book_rounded,
                    titulo: 'Matérias',
                    quantidade: '0',
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _cartaoResumo(
                    icone: Icons.assignment_turned_in_rounded,
                    titulo: 'Tarefas',
                    quantidade: '${StudyData.tarefas.length}',
                  ),
                ),
              ],
            ),

            const SizedBox(height: 25),

            const Text(
              'Progresso',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF302344),
              ),
            ),

            const SizedBox(height: 12),

            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: const LinearProgressIndicator(
                value: 0,
                minHeight: 10,
                backgroundColor: Color(0xFFE2D8F2),
                valueColor: AlwaysStoppedAnimation<Color>(
                  Color(0xFF5E35B1),
                ),
              ),
            ),

            const SizedBox(height: 28),

            const Text(
              'Acesse suas ferramentas',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF302344),
              ),
            ),

            const SizedBox(height: 15),

            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisSpacing: 14,
              mainAxisSpacing: 14,
              childAspectRatio: 1.05,
              children: [
                _botaoMenu(
                  titulo: 'Matérias',
                  subtitulo: 'Suas disciplinas',
                  icone: Icons.menu_book_rounded,
                  aoClicar: () => onNavigate(1),
                ),
                _botaoMenu(
                  titulo: 'Tarefas',
                  subtitulo: 'Provas e atividades',
                  icone: Icons.task_alt_rounded,
                  aoClicar: () => onNavigate(2),
                ),
                _botaoMenu(
                  titulo: 'Calendário',
                  subtitulo: 'Seus prazos',
                  icone: Icons.calendar_month_rounded,
                  aoClicar: () => onNavigate(3),
                ),
                _botaoMenu(
                  titulo: 'Agenda',
                  subtitulo: 'Planeje seus estudos',
                  icone: Icons.event_note_rounded,
                  aoClicar: () => onNavigate(4),
                ),
              ],
            ),

            const SizedBox(height: 15),
          ],
        ),
      ),
    );
  }
}

Widget _cartaoResumo({
  required IconData icone,
  required String titulo,
  required String quantidade,
}) {
  return Card(
    elevation: 1,
    color: Colors.white,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(18),
    ),
    child: Padding(
      padding: const EdgeInsets.symmetric(vertical: 18),
      child: Column(
        children: [
          Icon(
            icone,
            color: const Color(0xFF5E35B1),
            size: 30,
          ),
          const SizedBox(height: 8),
          Text(titulo),
          const SizedBox(height: 4),
          Text(
            quantidade,
            style: const TextStyle(
              fontSize: 23,
              fontWeight: FontWeight.bold,
              color: Color(0xFF302344),
            ),
          ),
        ],
      ),
    ),
  );
}

Widget _botaoMenu({
  required String titulo,
  required String subtitulo,
  required IconData icone,
  required VoidCallback aoClicar,
}) {
  return Card(
    elevation: 2,
    color: Colors.white,
    shadowColor: const Color(0xFF5E35B1),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(20),
    ),
    clipBehavior: Clip.antiAlias,
    child: InkWell(
      onTap: aoClicar,
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 54,
              height: 54,
              decoration: BoxDecoration(
                color: const Color(0xFFF0E8FF),
                borderRadius: BorderRadius.circular(17),
              ),
              child: Icon(
                icone,
                size: 29,
                color: const Color(0xFF5E35B1),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              titulo,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xFF302344),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              subtitulo,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 11,
                color: Color(0xFF80758D),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
