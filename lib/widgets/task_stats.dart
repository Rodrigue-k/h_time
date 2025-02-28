import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:h_time/providers/task_provider.dart';
import 'package:h_time/theme/app_theme.dart';

class TaskStats extends ConsumerWidget {
  const TaskStats({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tasks = ref.watch(taskProvider);

    return tasks.when(
      data: (tasksList) {
        final totalTasks = tasksList.length;
        final recurringTasks = tasksList.where((task) => task.isRecurring).length;
        final oneTimeTasks = totalTasks - recurringTasks;

        return Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Statistiques',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                _buildStatItem(
                  icon: Icons.task,
                  label: 'Total des tâches',
                  value: totalTasks.toString(),
                  color: AppTheme.primaryColor,
                ),
                const SizedBox(height: 12),
                _buildStatItem(
                  icon: Icons.repeat,
                  label: 'Tâches récurrentes',
                  value: recurringTasks.toString(),
                  color: AppTheme.successColor,
                ),
                const SizedBox(height: 12),
                _buildStatItem(
                  icon: Icons.event,
                  label: 'Tâches ponctuelles',
                  value: oneTimeTasks.toString(),
                  color: AppTheme.warningColor,
                ),
              ],
            ),
          ),
        );
      },
      loading: () => const Card(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Center(child: CircularProgressIndicator()),
        ),
      ),
      error: (error, stack) => Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Text('Erreur: $error'),
        ),
      ),
    );
  }

  Widget _buildStatItem({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: color),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            label,
            style: TextStyle(
              color: Colors.grey[700],
              fontSize: 14,
            ),
          ),
        ),
        Text(
          value,
          style: TextStyle(
            color: color,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
