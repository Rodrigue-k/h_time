import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:h_time/models/task.dart';
import 'package:h_time/providers/task_filter_provider.dart';
import 'package:h_time/providers/task_provider.dart';
import 'package:h_time/theme/app_theme.dart';
import 'package:h_time/widgets/task_card.dart';
import 'package:h_time/widgets/task_form_dialog.dart';
import 'package:h_time/widgets/task_stats.dart';

class TasksView extends ConsumerWidget {
  const TasksView({super.key});

  void _showTaskFormDialog(BuildContext context, {Task? task}) {
    showDialog(
      context: context,
      builder: (context) => TaskFormDialog(task: task),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tasks = ref.watch(filteredTasksProvider);
    final filter = ref.watch(taskFilterProvider);
    final sort = ref.watch(taskSortProvider);

    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          color: Colors.white,
          child: Row(
            children: [
              const Text(
                'Toutes les tâches',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              PopupMenuButton<TaskSortType>(
                icon: const Icon(Icons.sort),
                tooltip: 'Trier par',
                initialValue: sort,
                itemBuilder: (context) => [
                  const PopupMenuItem(
                    value: TaskSortType.date,
                    child: Text('Date'),
                  ),
                  const PopupMenuItem(
                    value: TaskSortType.title,
                    child: Text('Titre'),
                  ),
                  const PopupMenuItem(
                    value: TaskSortType.recurring,
                    child: Text('Récurrence'),
                  ),
                ],
                onSelected: (value) {
                  ref.read(taskSortProvider.notifier).setSort(value);
                },
              ),
              const SizedBox(width: 8),
              PopupMenuButton<TaskFilterType>(
                icon: const Icon(Icons.filter_list),
                tooltip: 'Filtrer',
                initialValue: filter,
                itemBuilder: (context) => [
                  const PopupMenuItem(
                    value: TaskFilterType.all,
                    child: Text('Toutes'),
                  ),
                  const PopupMenuItem(
                    value: TaskFilterType.recurring,
                    child: Text('Récurrentes'),
                  ),
                  const PopupMenuItem(
                    value: TaskFilterType.oneTime,
                    child: Text('Ponctuelles'),
                  ),
                ],
                onSelected: (value) {
                  ref.read(taskFilterProvider.notifier).setFilter(value);
                },
              ),
            ],
          ),
        ),
        Expanded(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Liste des tâches
              Expanded(
                flex: 2,
                child: tasks.when(
                  data: (tasksList) {
                    if (tasksList.isEmpty) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.task,
                              size: 64,
                              color: Colors.grey[400],
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Aucune tâche trouvée',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey[600],
                              ),
                            ),
                            const SizedBox(height: 8),
                            ElevatedButton(
                              onPressed: () => _showTaskFormDialog(context),
                              child: const Text('Créer une tâche'),
                            ),
                          ],
                        ),
                      );
                    }

                    return ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: tasksList.length,
                      itemBuilder: (context, index) {
                        final task = tasksList[index];
                        return Slidable(
                          key: ValueKey(task.uuid),
                          endActionPane: ActionPane(
                            motion: const ScrollMotion(),
                            children: [
                              SlidableAction(
                                onPressed: (_) => _showTaskFormDialog(context, task: task),
                                backgroundColor: AppTheme.primaryColor,
                                foregroundColor: Colors.white,
                                icon: Icons.edit,
                                label: 'Modifier',
                              ),
                              SlidableAction(
                                onPressed: (_) {
                                  ref.read(taskProvider.notifier).deleteTask(task);
                                },
                                backgroundColor: AppTheme.errorColor,
                                foregroundColor: Colors.white,
                                icon: Icons.delete,
                                label: 'Supprimer',
                              ),
                            ],
                          ),
                          child: TaskCard(
                            task: task,
                            onEdit: () => _showTaskFormDialog(context, task: task),
                            onDelete: () {
                              ref.read(taskProvider.notifier).deleteTask(task);
                            },
                          ),
                        );
                      },
                    );
                  },
                  loading: () => const Center(child: CircularProgressIndicator()),
                  error: (error, stack) => Center(
                    child: Text('Erreur: $error'),
                  ),
                ),
              ),
              // Panneau latéral avec les statistiques
              const SizedBox(
                width: 300,
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: TaskStats(),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
