import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../models/task.dart';

part 'task_provider.g.dart';

@riverpod
class TaskNotifier extends _$TaskNotifier {
  @override
  List<Task> build() {
    return [];
  }

  void addTask(Task task) {
    state = [...state, task];
  }

  void removeTask(String taskId) {
    state = state.where((task) => task.id != taskId).toList();
  }

  void updateTask(Task task) {
    state = state.map((t) => t.id == task.id ? task : t).toList();
  }
}
