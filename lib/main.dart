import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:h_time/providers/providers.dart';
import 'package:window_manager/window_manager.dart';
import 'app/app.dart';

void main() async {
  try {
    WidgetsFlutterBinding.ensureInitialized();

    // Initialize window manager
    await windowManager.ensureInitialized();
    await windowManager.waitUntilReadyToShow();
    windowManager.setMinimumSize(const Size(800, 600));

    runApp(const ProviderScope(child: MyApp()));
  } catch (e) {
    if (kDebugMode) {
      print('Error during app initialization: $e');
    }
    rethrow;
  }
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notificationAsync = ref.watch(notificationServiceProvider);
    final  taskAsync = ref.watch(taskServiceProvider);

    return notificationAsync.when(
      data: (notificationService) => 
      taskAsync.when(
        data: (taskService){
          if (kDebugMode) {
            notificationService.showNotification(
              id: 0,
              title: 'Test Notification',
              body: 'Ceci est une notification sur Windows !',
            );
          }
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
        }, error: (error, stack) =>
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: Text('Error: $error'),
            ),
          ),
        ), loading: () => MaterialApp(home: Scaffold(
          body: Center(child: CircularProgressIndicator(),),
        ),)), error: (error , stack) => MaterialApp(
          home: Scaffold(
            body: Center(
              child: Text('Error: $error'),
            ),
          ),
        ), loading: () => MaterialApp(home: Scaffold(
          body: Center(child: CircularProgressIndicator(),),
        ),));
  }
}
