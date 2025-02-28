import 'package:isar/isar.dart';
import 'package:uuid/uuid.dart';

part 'task.g.dart';

@collection
class Task {
  Id id = Isar.autoIncrement;
  
  @Index(unique: true)
  late String uuid;
  
  late String title;
  late String description;
  late DateTime startTime;
  late DateTime endTime;
  late bool isRecurring;
  late List<bool> recurringDays; // [lundi, mardi, ..., dimanche]
  late String color;
  late bool isCompleted;

  Task() {
    uuid = const Uuid().v4();
    recurringDays = List.filled(7, false);
    isCompleted = false;
  }

  Task copyWith({
    String? title,
    String? description,
    DateTime? startTime,
    DateTime? endTime,
    bool? isRecurring,
    List<bool>? recurringDays,
    String? color,
    bool? isCompleted,
  }) {
    final task = Task()
      ..title = title ?? this.title
      ..description = description ?? this.description
      ..startTime = startTime ?? this.startTime
      ..endTime = endTime ?? this.endTime
      ..isRecurring = isRecurring ?? this.isRecurring
      ..recurringDays = recurringDays ?? List.from(this.recurringDays)
      ..color = color ?? this.color
      ..isCompleted = isCompleted ?? this.isCompleted;
    return task;
  }
}
