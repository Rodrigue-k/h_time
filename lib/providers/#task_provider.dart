import 'package:flutter/material.dart';
import 'package:h_time/services/task_service.dart';
import '../models/task.dart';

class TaskProvider extends ChangeNotifier {
  final TaskService _taskService = TaskService();
  List<Task> _tasks = [];

  List<Task> get tasks => _tasks;

  Future<void> loadTasks() async {
    _tasks = await _taskService.getTasks();
    notifyListeners();
  }

  Future<void> addTask(Task task) async {
    await _taskService.createTask(task);
    await loadTasks();
  }

  Future<void> updateTask(Task task) async {
    await _taskService.updateTask(task);
    await loadTasks();
  }

  Future<void> deleteTask(String id) async {
    await _taskService.deleteTask(id);
    await loadTasks();
  }
}
