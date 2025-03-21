import 'package:h_time/services/notification_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../models/task.dart';
import '../../services/task_service.dart';

part 'task_provider.g.dart';

@riverpod
class TaskNotifier extends _$TaskNotifier {
  final _taskService = TaskService();
  final notificationService = NotificationService();

  @override
  Future<List<Task>> build() async {
    return _taskService.getTasks();
  }

  Future<void> addTask(Task task) async {
    _taskService.createTask(task);
    await notificationService.scheduleTaskNotification(task);
    state = AsyncValue.data([...state.value ?? [], task]);
  }

  Future<void> removeTask(String taskId) async {
    _taskService.deleteTask(taskId);
    state = AsyncValue.data(
        (state.value ?? []).where((task) => task.id != taskId).toList());
  }

  Future<void> updateTask(Task task) async {
    _taskService.updateTask(task);
    await notificationService.scheduleTaskNotification(task);
    state = AsyncValue.data(
        (state.value ?? []).map((t) => t.id == task.id ? task : t).toList());
  }

  Future<void> refreshTasks() async {
    state = const AsyncValue.loading();
    try {
      final tasks = _taskService.getTasks();
      state = AsyncValue.data(tasks);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }
}
