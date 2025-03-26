

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:h_time/services/notification_service.dart';
import 'package:h_time/services/task_service.dart';

export 'task/task_provider.dart';
export 'task_color_provider.dart';
export 'schedule_view_mode_provider.dart';
export 'selected_colonne_provider.dart';

final notificationServiceProvider = FutureProvider<NotificationService>((ref)async{
  final notificationService = NotificationService();
  await notificationService.init();
  return notificationService;
});


final taskServiceProvider = FutureProvider<TaskService>((ref)async{
  final taskService = TaskService();
  await taskService.init();
  return taskService;
});
