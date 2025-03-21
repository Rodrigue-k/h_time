import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:window_manager/window_manager.dart';
import 'app/app.dart';
import 'services/task_service.dart';
import 'services/notification_service.dart';

void main() async {
  try {
    WidgetsFlutterBinding.ensureInitialized();
    
    // Initialize notifications first
    final notificationService = NotificationService();
    await notificationService.init();

    // Initialize window manager
    await windowManager.ensureInitialized();
    await windowManager.waitUntilReadyToShow();
    windowManager.setMinimumSize(const Size(800, 600));

    // Initialize task service
    final taskService = TaskService();
    await taskService.init();

    runApp(const ProviderScope(child: MyApp()));
  } catch (e) {
    if (kDebugMode) {
      print('Error during app initialization: $e');
    }
    rethrow;
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'H-Time',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
        scaffoldBackgroundColor: Colors.grey[100],
      ),
      home: const HTimeApp(),
    );
  }
}
