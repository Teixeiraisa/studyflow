import 'package:flutter/material.dart';
import 'subjects_page.dart';
import 'tasks_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F3FA),

      appBar: AppBar(
        title: const Text('StudyFlow'),
        backgroundColor: const Color(0xFF5E35B1),
        foregroundColor: Colors.white,
      ),

      body: Padding(
        padding: const EdgeInsets.all(20),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            const Text(
              'Olá! 👋',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 5),

            const Text(
              'Organize seus estudos e acompanhe seu progresso.',
              style: TextStyle(
                fontSize: 16,
              ),
            ),

            const SizedBox(height: 30),

            const Text(
              'Resumo dos estudos',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 15),

            Row(
              children: [
                Expanded(
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        children: const [
                          Icon(
                            Icons.book,
                            color: Color(0xFF5E35B1),
                            size: 35,
                          ),
                          SizedBox(height: 10),
                          Text('Matérias'),
                          Text(
                            '0',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                Expanded(
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        children: const [
                          Icon(
                            Icons.task,
                            color: Color(0xFF5E35B1),
                            size: 35,
                          ),
                          SizedBox(height: 10),
                          Text('Tarefas'),
                          Text(
                            '0',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            const Text(
              'Progresso',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 10),

            const LinearProgressIndicator(
              value: 0,
              minHeight: 10,
            ),
            const SizedBox(height: 25),

          SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
          onPressed: () {
          Navigator.push(
          context,
          MaterialPageRoute(
               builder: (context) => const SubjectsPage(),
        ),
      );
    },
         icon: const Icon(Icons.book),
        label: const Text('Ver minhas matérias'),
  ),
),
      const SizedBox(height: 15),

        SizedBox(
        width: double.infinity,
        child: ElevatedButton.icon(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
             builder: (context) => const TasksPage(),
        ),
      );
    },
        icon: const Icon(Icons.assignment),
        label: const Text('Ver minhas tarefas'),
  ),
),
          ],
        ),
      ),
    );
  }
}