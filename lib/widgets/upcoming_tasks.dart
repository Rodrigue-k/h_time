import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:h_time/models/task.dart';
import 'package:h_time/providers/task_provider.dart';
import 'package:h_time/theme/app_theme.dart';
import 'package:intl/intl.dart';

class UpcomingTasks extends ConsumerWidget {
  final DateTime selectedDate;

  const UpcomingTasks({
    super.key,
    required this.selectedDate,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tasks = ref.watch(dailyTasksProvider(selectedDate));

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Tâches du ${DateFormat('EEEE d MMMM', 'fr_FR').format(selectedDate)}',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            tasks.when(
              data: (tasksList) {
                if (tasksList.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.event_available,
                          size: 48,
                          color: Colors.grey[400],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Aucune tâche prévue',
                          style: TextStyle(
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  );
                }

                // Trier les tâches par heure de début
                tasksList.sort((a, b) => a.startTime.compareTo(b.startTime));

                return Column(
                  children: tasksList.map((task) {
                    final isUpcoming = task.startTime.isAfter(DateTime.now());
                    final isPast = task.endTime.isBefore(DateTime.now());

                    return Container(
                      margin: const EdgeInsets.only(bottom: 8),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade200),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: ListTile(
                        leading: Container(
                          width: 4,
                          height: 40,
                          decoration: BoxDecoration(
                            color: Color(int.parse('0xFF${task.color}')),
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                        title: Row(
                          children: [
                            Expanded(
                              child: Text(
                                task.title,
                                style: TextStyle(
                                  decoration: isPast ? TextDecoration.lineThrough : null,
                                  color: isPast ? Colors.grey : null,
                                ),
                              ),
                            ),
                            if (isUpcoming)
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: AppTheme.primaryColor.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  'À venir',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: AppTheme.primaryColor,
                                  ),
                                ),
                              ),
                          ],
                        ),
                        subtitle: Text(
                          '${DateFormat('HH:mm').format(task.startTime)} - ${DateFormat('HH:mm').format(task.endTime)}',
                          style: TextStyle(
                            color: isPast ? Colors.grey : Colors.grey[600],
                          ),
                        ),
                        trailing: task.isRecurring
                            ? Icon(
                                Icons.repeat,
                                size: 16,
                                color: Colors.grey[600],
                              )
                            : null,
                      ),
                    );
                  }).toList(),
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, stack) => Center(
                child: Text('Erreur: $error'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
