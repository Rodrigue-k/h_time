import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:h_time/widgets/time_grid.dart';
import 'package:h_time/widgets/upcoming_tasks.dart';
import 'package:h_time/widgets/task_form_dialog.dart';

class WeeklyView extends ConsumerStatefulWidget {
  const WeeklyView({super.key});

  @override
  ConsumerState<WeeklyView> createState() => _WeeklyViewState();
}

class _WeeklyViewState extends ConsumerState<WeeklyView> {
  late DateTime _selectedDate;

  @override
  void initState() {
    super.initState();
    _selectedDate = DateTime.now();
  }

  void _showAddTaskDialog() {
    showDialog(
      context: context,
      builder: (context) => const TaskFormDialog(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          // Grille horaire (partie gauche)
          Expanded(
            flex: 7,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // En-tête avec navigation
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.chevron_left),
                        onPressed: () {
                          setState(() {
                            _selectedDate = _selectedDate.subtract(const Duration(days: 7));
                          });
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.chevron_right),
                        onPressed: () {
                          setState(() {
                            _selectedDate = _selectedDate.add(const Duration(days: 7));
                          });
                        },
                      ),
                      const SizedBox(width: 16),
                      TextButton.icon(
                        icon: const Icon(Icons.today),
                        label: const Text('Aujourd\'hui'),
                        onPressed: () {
                          setState(() {
                            _selectedDate = DateTime.now();
                          });
                        },
                      ),
                      const Spacer(),
                      ElevatedButton.icon(
                        icon: const Icon(Icons.add),
                        label: const Text('Nouvelle Tâche'),
                        onPressed: _showAddTaskDialog,
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  // Grille des tâches
                  Expanded(
                    child: TimeGrid(selectedDate: _selectedDate),
                  ),
                ],
              ),
            ),
          ),
          // Liste des tâches à venir (partie droite)
          Expanded(
            flex: 3,
            child: Container(
              padding: const EdgeInsets.all(16),
              child: UpcomingTasks(selectedDate: _selectedDate),
            ),
          ),
        ],
      ),
    );
  }
}
