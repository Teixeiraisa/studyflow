
import 'package:flutter/material.dart';

import 'home_page.dart';
import 'subjects_page.dart';
import 'tasks_page.dart';
import 'calendar_page.dart';
import 'agenda_page.dart';
import '../services/study_data.dart';

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int paginaSelecionada = 0;

  void mudarPagina(int indice) {
    setState(() {
      paginaSelecionada = indice;
    });
  }

  @override
  Widget build(BuildContext context) {
    final paginas = [
      HomePage(onNavigate: mudarPagina),
      const SubjectsPage(),
      const TasksPage(),
      CalendarPage(tarefas: StudyData.tarefas),
      const AgendaPage(),
    ];

    return Scaffold(
      body: IndexedStack(
        index: paginaSelecionada,
        children: paginas,
      ),

      bottomNavigationBar: NavigationBar(
        backgroundColor: Colors.white,
        indicatorColor: const Color(0xFFEDE7F6),
        selectedIndex: paginaSelecionada,
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,

        onDestinationSelected: mudarPagina,

        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Início',
          ),
          NavigationDestination(
            icon: Icon(Icons.menu_book_outlined),
            selectedIcon: Icon(Icons.menu_book),
            label: 'Matérias',
          ),
          NavigationDestination(
            icon: Icon(Icons.task_alt_outlined),
            selectedIcon: Icon(Icons.task_alt),
            label: 'Tarefas',
          ),
          NavigationDestination(
            icon: Icon(Icons.calendar_month_outlined),
            selectedIcon: Icon(Icons.calendar_month),
            label: 'Calendário',
          ),
          NavigationDestination(
            icon: Icon(Icons.event_note_outlined),
            selectedIcon: Icon(Icons.event_note),
            label: 'Agenda',
          ),
        ],
      ),
    );
  }
}
