import 'package:flutter/material.dart';
import 'add_subject_page.dart';
final nomeController = TextEditingController();
final professorController = TextEditingController();

class SubjectsPage extends StatefulWidget {
  const SubjectsPage({super.key});

  @override
  State<SubjectsPage> createState() => _SubjectsPageState();
}

class _SubjectsPageState extends State<SubjectsPage> {
  List<Map<String, String>> materias = [];

  @override
  Widget build(BuildContext context)  {
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
             onPressed: () async {
               final materia = await Navigator.push(
               context,
            MaterialPageRoute(
              builder: (context) => const AddSubjectPage(),
              ),
            );

            if (materia != null) {
             setState(() {
             materias.add({
               'nome': materia['nome'],
               'professor': materia['professor'],
               });
             });
           }
         },
                icon: const Icon(Icons.add),
                label: const Text('Adicionar matéria'),
              ),
            ),

            const SizedBox(height: 20),

          Expanded(
  child: ListView.builder(
    itemCount: materias.length,
    itemBuilder: (context, index) {
      final materia = materias[index];

      return Card(
        child: ListTile(
          leading: const Icon(
            Icons.book,
            color: Color(0xFF5E35B1),
          ),
          title: Text(materia['nome']!),
          subtitle: Text(
            'Professor: ${materia['professor']}',
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