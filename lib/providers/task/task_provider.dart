import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../models/task.dart';
import '../../services/task_service.dart';

part 'task_provider.g.dart';

@riverpod
class TaskNotifier extends _$TaskNotifier {
 final _taskService = TaskService();

  @override
  Future<List<Task>> build() async {
    return _taskService.getTasks();
  }

  Future<void> addTask(Task task, BuildContext context) async {
    _taskService.createTask(task);
    await task.scheduleNotifications(context);
    state = AsyncValue.data([...state.value ?? [], task]);
  }

  Future<void> removeTask(String taskId) async {
    final task = state.value?.firstWhere((t) => t.id == taskId);
    if (task != null) {
      await task.cancelNotifications();
    }
    _taskService.deleteTask(taskId);
    state = AsyncValue.data(
        (state.value ?? []).where((task) => task.id != taskId).toList());
  }

  Future<void> updateTask(Task updatedTask, BuildContext context) async {
    final existingTask = state.value?.firstWhere((t) => t.id == updatedTask.id);
    if (existingTask != null) {
      await existingTask.cancelNotifications();
    }
    await updatedTask.scheduleNotifications(context);
    _taskService.updateTask(updatedTask);
    state = AsyncValue.data(
        (state.value ?? []).map((t) => t.id == updatedTask.id ? updatedTask : t).toList());
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
