import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:h_time/models/task.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

class TaskNotifier extends AsyncNotifier<List<Task>> {
  late Isar isar;

  @override
  Future<List<Task>> build() async {
    final dir = await getApplicationDocumentsDirectory();
    isar = await Isar.open(
      [TaskSchema],
      directory: dir.path,
    );
    return isar.tasks.where().findAll();
  }

  Future<void> addTask(Task task) async {
    state = const AsyncValue.loading();
    await isar.writeTxn(() async {
      await isar.tasks.put(task);
    });
    state = AsyncValue.data(await isar.tasks.where().findAll());
  }

  Future<void> updateTask(Task task) async {
    state = const AsyncValue.loading();
    await isar.writeTxn(() async {
      await isar.tasks.put(task);
    });
    state = AsyncValue.data(await isar.tasks.where().findAll());
  }

  Future<void> deleteTask(Task task) async {
    state = const AsyncValue.loading();
    await isar.writeTxn(() async {
      await isar.tasks.delete(task.id);
    });
    state = AsyncValue.data(await isar.tasks.where().findAll());
  }

  Future<List<Task>> getTasksForDay(DateTime date) async {
    final tasks = await isar.tasks.where().findAll();
    return tasks.where((task) {
      if (!task.isRecurring) {
        return task.startTime.year == date.year &&
            task.startTime.month == date.month &&
            task.startTime.day == date.day;
      } else {
        // Pour les tâches récurrentes, vérifier si le jour de la semaine correspond
        return task.recurringDays[date.weekday - 1];
      }
    }).toList();
  }
}

final taskProvider = AsyncNotifierProvider<TaskNotifier, List<Task>>(
  () => TaskNotifier(),
);

final dailyTasksProvider = FutureProvider.family<List<Task>, DateTime>(
  (ref, date) async {
    final taskNotifier = ref.watch(taskProvider.notifier);
    return taskNotifier.getTasksForDay(date);
  },
);
