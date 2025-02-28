import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:h_time/models/task.dart';
import 'package:h_time/providers/task_provider.dart';

enum TaskSortType {
  date,
  title,
  recurring,
}

enum TaskFilterType {
  all,
  recurring,
  oneTime,
}

class TaskFilterNotifier extends StateNotifier<TaskFilterType> {
  TaskFilterNotifier() : super(TaskFilterType.all);

  void setFilter(TaskFilterType filter) {
    state = filter;
  }
}

class TaskSortNotifier extends StateNotifier<TaskSortType> {
  TaskSortNotifier() : super(TaskSortType.date);

  void setSort(TaskSortType sort) {
    state = sort;
  }
}

final taskFilterProvider = StateNotifierProvider<TaskFilterNotifier, TaskFilterType>(
  (ref) => TaskFilterNotifier(),
);

final taskSortProvider = StateNotifierProvider<TaskSortNotifier, TaskSortType>(
  (ref) => TaskSortNotifier(),
);

final filteredTasksProvider = Provider<AsyncValue<List<Task>>>((ref) {
  final tasks = ref.watch(taskProvider);
  final filter = ref.watch(taskFilterProvider);
  final sort = ref.watch(taskSortProvider);

  return tasks.when(
    data: (tasksList) {
      var filteredTasks = [...tasksList];

      // Appliquer le filtre
      switch (filter) {
        case TaskFilterType.recurring:
          filteredTasks = filteredTasks.where((task) => task.isRecurring).toList();
          break;
        case TaskFilterType.oneTime:
          filteredTasks = filteredTasks.where((task) => !task.isRecurring).toList();
          break;
        case TaskFilterType.all:
          // Pas de filtrage nécessaire
          break;
      }

      // Appliquer le tri
      switch (sort) {
        case TaskSortType.date:
          filteredTasks.sort((a, b) => a.startTime.compareTo(b.startTime));
          break;
        case TaskSortType.title:
          filteredTasks.sort((a, b) => a.title.compareTo(b.title));
          break;
        case TaskSortType.recurring:
          filteredTasks.sort((a, b) {
            if (a.isRecurring == b.isRecurring) {
              return a.startTime.compareTo(b.startTime);
            }
            return b.isRecurring ? 1 : -1;
          });
          break;
      }

      return AsyncValue.data(filteredTasks);
    },
    loading: () => const AsyncValue.loading(),
    error: (error, stack) => AsyncValue.error(error, stack),
  );
});
