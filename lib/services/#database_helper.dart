/*import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/task.dart';

class DatabaseHelper {
  static const _databaseName = "tasks.db";
  static const _databaseVersion = 1;
  static const table = 'tasks';

  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static Database? _database;
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), _databaseName);
    return await openDatabase(
      path,
      version: _databaseVersion,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $table (
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

  Future<int> insertTask(Task task) async {
    Database db = await instance.database;
    return await db.insert(
      table,
      {
        'id': task.id,
        'title': task.title,
        'description': task.description,
        'days': task.days.join(','),
        'startTimeHour': task.startTime.hour,
        'startTimeMinute': task.startTime.minute,
        'endTimeHour': task.endTime.hour,
        'endTimeMinute': task.endTime.minute,
        'color': task.color.value,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Task>> getTasks() async {
    Database db = await instance.database;
    final List<Map<String, dynamic>> maps = await db.query(table);

    return List.generate(maps.length, (i) {
      List<bool> days = maps[i]['days']
          .split(',')
          .map((e) => e == 'true')
          .cast<bool>()
          .toList();

      return Task(
        id: maps[i]['id'],
        title: maps[i]['title'],
        description: maps[i]['description'],
        days: days,
        startTime: TimeOfDay(
          hour: maps[i]['startTimeHour'],
          minute: maps[i]['startTimeMinute'],
        ),
        endTime: TimeOfDay(
          hour: maps[i]['endTimeHour'],
          minute: maps[i]['endTimeMinute'],
        ),
        color: Color(maps[i]['color']),
      );
    });
  }

  Future<int> deleteTask(String id) async {
    Database db = await instance.database;
    return await db.delete(table, where: 'id = ?', whereArgs: [id]);
  }

  Future<int> updateTask(Task task) async {
    Database db = await instance.database;
    return await db.update(
      table,
      {
        'title': task.title,
        'description': task.description,
        'days': task.days.join(','),
        'startTimeHour': task.startTime.hour,
        'startTimeMinute': task.startTime.minute,
        'endTimeHour': task.endTime.hour,
        'endTimeMinute': task.endTime.minute,
        'color': task.color.value,
      },
      where: 'id = ?',
      whereArgs: [task.id],
    );
  }
}
*/