import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:h_time/models/task.dart';
import 'package:h_time/providers/task_provider.dart';
import 'package:h_time/theme/app_theme.dart';

class TimeSlot extends ConsumerWidget {
  final DateTime day;
  final int timeSlot;
  final bool isCurrentDay;

  const TimeSlot({
    super.key,
    required this.day,
    required this.timeSlot,
    required this.isCurrentDay,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tasks = ref.watch(dailyTasksProvider(day));

    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade200),
        color: isCurrentDay ? Colors.blue.shade50.withOpacity(0.3) : null,
      ),
      child: tasks.when(
        data: (tasksList) {
          final currentTime = DateTime(
            day.year,
            day.month,
            day.day,
            timeSlot ~/ 4,
            (timeSlot % 4) * 15,
          );

          final tasksInSlot = tasksList.where((task) {
            return task.startTime.isBefore(currentTime.add(const Duration(minutes: 15))) &&
                   task.endTime.isAfter(currentTime);
          }).toList();

          if (tasksInSlot.isEmpty) {
            return const SizedBox();
          }

          return Stack(
            children: tasksInSlot.map((task) {
              final isStart = task.startTime.hour == currentTime.hour &&
                            task.startTime.minute == currentTime.minute;
              
              if (!isStart) return const SizedBox();

              final duration = task.endTime.difference(task.startTime);
              final slots = (duration.inMinutes / 15).ceil();

              return Positioned.fill(
                child: Container(
                  height: 30.0 * slots,
                  margin: const EdgeInsets.all(1),
                  decoration: BoxDecoration(
                    color: Color(int.parse('0xFF${task.color}')).withOpacity(0.8),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(4),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          task.title,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        if (slots > 2)
                          Text(
                            task.description,
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 10,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                      ],
                    ),
                  ),
                ),
              );
            }).toList(),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Icon(Icons.error_outline, color: Colors.red[300]),
        ),
      ),
    );
  }
}
