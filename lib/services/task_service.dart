import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:sqlite3/sqlite3.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import '../models/task.dart';

class TaskService {
  // Instance singleton
  static final TaskService _instance = TaskService._internal();
  factory TaskService() => _instance;
  TaskService._internal();

  late Database _db;

  /// Initialise la base de données.
  Future<void> init() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, 'tasks.db');
    if (kDebugMode) {
      print('Chemin de la base de données : $path');
    }
    _db = sqlite3.open(path);
    _db.execute('''
      CREATE TABLE IF NOT EXISTS tasks(
        id TEXT PRIMARY KEY,
        title TEXT NOT NULL,
        description TEXT NOT NULL,
        days TEXT NOT NULL,
        startTimeHour INTEGER NOT NULL,
        startTimeMinute INTEGER NOT NULL,
        endTimeHour INTEGER NOT NULL,
        endTimeMinute INTEGER NOT NULL,
        color INTEGER NOT NULL
      )
    ''');
  }

  void createTask(Task task) {
    final stmt = _db.prepare('''
      INSERT OR REPLACE INTO tasks(
        id, title, description, days, startTimeHour, startTimeMinute, endTimeHour, endTimeMinute, color
      ) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)
    ''');
    stmt.execute([
      task.id,
      task.title,
      task.description,
      task.days.join(','),
      task.startTime.hour,
      task.startTime.minute,
      task.endTime.hour,
      task.endTime.minute,
      task.color.value,
    ]);
    stmt.dispose();
  }

  List<Task> getTasks() {
    final ResultSet result = _db.select('SELECT * FROM tasks');
    return result.map((row) {
      return Task(
        id: row['id'] as String,
        title: row['title'] as String,
        description: row['description'] as String,
        days: (row['days'] as String)
            .split(',')
            .map((e) => e == 'true')
            .toList(),
        startTime: TimeOfDay(
          hour: row['startTimeHour'] as int,
          minute: row['startTimeMinute'] as int,
        ),
        endTime: TimeOfDay(
          hour: row['endTimeHour'] as int,
          minute: row['endTimeMinute'] as int,
        ),
        color: Color(row['color'] as int),
      );
    }).toList();
  }

  void updateTask(Task task) {
    final stmt = _db.prepare('''
      UPDATE tasks SET
        title = ?,
        description = ?,
        days = ?,
        startTimeHour = ?,
        startTimeMinute = ?,
        endTimeHour = ?,
        endTimeMinute = ?,
        color = ?
      WHERE id = ?
    ''');
    stmt.execute([
      task.title,
      task.description,
      task.days.join(','),
      task.startTime.hour,
      task.startTime.minute,
      task.endTime.hour,
      task.endTime.minute,
      task.color.value,
      task.id,
    ]);
    stmt.dispose();
  }

  void deleteTask(String id) {
    final stmt = _db.prepare('DELETE FROM tasks WHERE id = ?');
    stmt.execute([id]);
    stmt.dispose();
  }
}
