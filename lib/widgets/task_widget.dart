import 'package:flutter/material.dart';
import 'package:h_time/models/task.dart';

class TaskWidget extends StatelessWidget {
  final Task task;
  final VoidCallback onTap;

  const TaskWidget({super.key, required this.task, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: task.color.withOpacity(0.3),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: task.color, width: 2),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              task.title,
              style: const TextStyle(
                  fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 4),
            Text(task.description),
            const SizedBox(height: 8),
            Text(
              "${task.startTime.format(context)} - ${task.endTime.format(context)}",
              style: const TextStyle(fontSize: 12, color: Colors.black54),
            ),
          ],
        ),
      ),
    );
  }
}
