import 'package:flutter/material.dart';
import 'add_subject_page.dart';

class SubjectsPage extends StatelessWidget {
  const SubjectsPage({super.key});

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
              onPressed: () {
              Navigator.push(
              context,
              MaterialPageRoute(
              builder: (context) => const AddSubjectPage(),
              ),
            );
           },
                icon: const Icon(Icons.add),
                label: const Text('Adicionar matéria'),
              ),
            ),

            const SizedBox(height: 20),

            Card(
              child: ListTile(
                leading: const Icon(
                  Icons.calculate,
                  color: Color(0xFF5E35B1),
                ),
                title: const Text('Matemática'),
                subtitle: const Text('Professor não definido'),
              ),
            ),

            Card(
              child: ListTile(
                leading: const Icon(
                  Icons.science,
                  color: Color(0xFF5E35B1),
                ),
                title: const Text('Química'),
                subtitle: const Text('Professor não definido'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}