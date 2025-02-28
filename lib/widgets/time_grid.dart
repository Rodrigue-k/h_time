import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:h_time/models/task.dart';
import 'package:h_time/providers/task_provider.dart';
import 'package:h_time/theme/app_theme.dart';
import 'package:intl/intl.dart';

class TimeGrid extends ConsumerWidget {
  final DateTime selectedDate;

  const TimeGrid({
    super.key,
    required this.selectedDate,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tasks = ref.watch(dailyTasksProvider(selectedDate));

    return Card(
      child: SingleChildScrollView(
        child: Column(
          children: [
            // En-tête avec les jours de la semaine
            _buildHeader(),
            // Grille des heures
            _buildTimeGrid(context, tasks),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    final days = ['Lun', 'Mar', 'Mer', 'Jeu', 'Ven', 'Sam', 'Dim'];
    final now = DateTime.now();
    final startOfWeek = selectedDate.subtract(Duration(days: selectedDate.weekday - 1));

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.grey)),
      ),
      child: Row(
        children: [
          // Cellule vide pour l'alignement avec les heures
          SizedBox(width: 60),
          // Jours de la semaine
          ...List.generate(7, (index) {
            final date = startOfWeek.add(Duration(days: index));
            final isToday = date.year == now.year && 
                           date.month == now.month && 
                           date.day == now.day;
            
            return Expanded(
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: isToday ? AppTheme.primaryColor.withOpacity(0.1) : null,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  children: [
                    Text(
                      days[index],
                      style: TextStyle(
                        fontWeight: isToday ? FontWeight.bold : FontWeight.normal,
                        color: isToday ? AppTheme.primaryColor : null,
                      ),
                    ),
                    Text(
                      date.day.toString(),
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: isToday ? FontWeight.bold : FontWeight.normal,
                        color: isToday ? AppTheme.primaryColor : null,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildTimeGrid(BuildContext context, AsyncValue<List<Task>> tasksAsync) {
    return tasksAsync.when(
      data: (tasks) => Column(
        children: List.generate(24, (hour) {
          return _buildTimeRow(context, hour, tasks);
        }),
      ),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => Center(child: Text('Erreur: $error')),
    );
  }

  Widget _buildTimeRow(BuildContext context, int hour, List<Task> tasks) {
    return Row(
      children: [
        // Heure
        SizedBox(
          width: 60,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Text(
              '${hour.toString().padLeft(2, '0')}:00',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 12,
              ),
            ),
          ),
        ),
        // Cellules pour chaque jour
        ...List.generate(7, (dayIndex) {
          final date = selectedDate.subtract(
            Duration(days: selectedDate.weekday - 1 - dayIndex),
          );
          final tasksForThisSlot = tasks.where((task) {
            final taskStartHour = task.startTime.hour;
            final taskEndHour = task.endTime.hour;
            final taskDate = DateTime(
              task.startTime.year,
              task.startTime.month,
              task.startTime.day,
            );
            final cellDate = DateTime(date.year, date.month, date.day);
            
            return taskDate == cellDate && 
                   taskStartHour <= hour && 
                   taskEndHour > hour;
          }).toList();

          return Expanded(
            child: Container(
              height: 60,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: Stack(
                children: [
                  // Tâches
                  ...tasksForThisSlot.map((task) => Positioned.fill(
                    child: Padding(
                      padding: const EdgeInsets.all(2),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Color(int.parse('0xFF${task.color}')).withOpacity(0.2),
                          borderRadius: BorderRadius.circular(4),
                          border: Border.all(
                            color: Color(int.parse('0xFF${task.color}')),
                          ),
                        ),
                        child: Tooltip(
                          message: '${task.title}\n${DateFormat('HH:mm').format(task.startTime)} - ${DateFormat('HH:mm').format(task.endTime)}',
                          child: Padding(
                            padding: const EdgeInsets.all(4),
                            child: Text(
                              task.title,
                              style: const TextStyle(
                                fontSize: 10,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  )),
                ],
              ),
            ),
          );
        }),
      ],
    );
  }
}
