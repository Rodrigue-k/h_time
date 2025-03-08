import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

class Task {
  final String id;
  final String title;
  final String description;
  final List<bool> days;
  final TimeOfDay startTime;
  final TimeOfDay endTime;
  final Color color;

  Task({
    String? id,
    required this.title,
    required this.description,
    required this.days,
    required this.startTime,
    required this.endTime,
    required this.color,
  }) : id = id ?? DateTime.now().toString();

  // Copie avec modification
  Task copyWith({
    String? id,
    String? title,
    String? description,
    List<bool>? days,
    TimeOfDay? startTime,
    TimeOfDay? endTime,
    Color? color,
  }) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      days: days ?? this.days,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      color: color ?? this.color,
    );
  }

  // Conversion en Map pour stockage
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'days': days,
      'startTime': {'hour': startTime.hour, 'minute': startTime.minute},
      'endTime': {'hour': endTime.hour, 'minute': endTime.minute},
      'color': color.value,
    };
  }

  // Création depuis Map
  factory Task.fromMap(Map<String, dynamic> map) {
    return Task(
      id: map['id'] as String,
      title: map['title'] as String,
      description: map['description'] as String,
      days: List<bool>.from(map['days']),
      startTime: TimeOfDay(
        hour: (map['startTime'] as Map<String, dynamic>)['hour'] as int,
        minute: (map['startTime'] as Map<String, dynamic>)['minute'] as int,
      ),
      endTime: TimeOfDay(
        hour: (map['endTime'] as Map<String, dynamic>)['hour'] as int,
        minute: (map['endTime'] as Map<String, dynamic>)['minute'] as int,
      ),
      color: Color(map['color'] as int),
    );
  }

  // Égalité
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Task &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          title == other.title &&
          description == other.description &&
          listEquals(days, other.days) &&
          startTime == other.startTime &&
          endTime == other.endTime &&
          color == other.color;

  @override
  int get hashCode =>
      id.hashCode ^
      title.hashCode ^
      description.hashCode ^
      days.hashCode ^
      startTime.hashCode ^
      endTime.hashCode ^
      color.hashCode;

  @override
  String toString() {
    return 'Task{id: $id, title: $title, description: $description, days: $days, startTime: $startTime, endTime: $endTime, color: $color}';
  }
}
