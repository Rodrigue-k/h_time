import 'dart:io';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;
import '../models/task.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._();
  factory NotificationService() => _instance;
  NotificationService._();

  final FlutterLocalNotificationsPlugin _notifications = FlutterLocalNotificationsPlugin();
  bool _initialized = false;

  Future<void> init() async {
    if (_initialized) return;

    try {
      // Initialize timezone database
      tz.initializeTimeZones();
      
      // Set default timezone to local system timezone
      tz.setLocalLocation(tz.getLocation(Platform.isWindows ? 'Europe/London' : 'UTC'));

      // Configure platform-specific settings
      const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
      const iosSettings = DarwinInitializationSettings(
        requestSoundPermission: true,
        requestBadgePermission: true,
        requestAlertPermission: true,
      );
      
      const initSettings = InitializationSettings(
        android: androidSettings,
        iOS: iosSettings,
      );

      // Initialize plugin
      final initialized = await _notifications.initialize(
        initSettings,
        onDidReceiveNotificationResponse: (details) async {
          print('Notification tapped: ${details.payload}');
        },
      );

      if (initialized != true) {
        throw Exception('Error initializing notifications');
      }

      await _createNotificationChannel();
      _initialized = true;
      print('Notifications initialized successfully');

    } catch (e) {
      print('Error during notification service initialization: $e');
      _initialized = false;
    }
  }

  Future<void> _createNotificationChannel() async {
    const androidChannel = AndroidNotificationChannel(
      'task_channel', // id
      'Task Notifications', // title
      description: 'Notifications for tasks', // description
      importance: Importance.max,
      playSound: true,
      enableVibration: true,
      enableLights: true,
    );

    await _notifications
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(androidChannel);
  }

  Future<void> scheduleTaskNotification(Task task) async {
    if (!_initialized) {
      print('Notifications not initialized');
      return;
    }
    
    if (!task.notificationsEnabled) return;
    
    try {
      await cancelTaskNotifications(task);
      for (int i = 0; i < task.days.length; i++) {
        if (task.days[i]) {
          final now = DateTime.now();
          var scheduledDate = DateTime(
            now.year,
            now.month,
            now.day,
            task.startTime.hour,
            task.startTime.minute,
          );

          // Calculer le prochain jour valide
          while (scheduledDate.weekday != i + 1) {
            scheduledDate = scheduledDate.add(const Duration(days: 1));
          }

          if (scheduledDate.isBefore(now)) {
            scheduledDate = scheduledDate.add(const Duration(days: 7));
          }

          final tzDateTime = tz.TZDateTime.from(scheduledDate, tz.local);

          try {
            await _notifications.zonedSchedule(
              task.id.hashCode + i,
              'Tâche: ${task.title}',
              task.description,
              tzDateTime,
              NotificationDetails(
                android: AndroidNotificationDetails(
                  'task_channel',
                  'Task Notifications',
                  channelDescription: 'Notifications for tasks',
                  importance: Importance.max,
                  priority: Priority.high,
                  sound: task.soundPath != null 
                      ? RawResourceAndroidNotificationSound(task.soundPath!)
                      : RawResourceAndroidNotificationSound('notification'),
                  fullScreenIntent: true,
                  visibility: NotificationVisibility.public,
                ),
                iOS: DarwinNotificationDetails(
                  sound: task.soundPath ?? 'notification',
                  presentAlert: true,
                  presentBadge: true,
                  presentSound: true,
                ),
              ),
              androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
              uiLocalNotificationDateInterpretation:
                  UILocalNotificationDateInterpretation.absoluteTime,
              matchDateTimeComponents: DateTimeComponents.dayOfWeekAndTime,
            );
            print('Notification programmée pour: $tzDateTime');
          } catch (e) {
            print('Erreur lors de la programmation de la notification: $e');
          }
        }
      }
    } catch (e) {
      print('Error scheduling notification: $e');
    }
  }

  Future<void> cancelTaskNotifications(Task task) async {
    if (!_initialized) {
      print('Notifications not initialized');
      return;
    }
    
    try {
      for (int i = 0; i < 7; i++) {
        await _notifications.cancel(task.id.hashCode + i);
      }
    } catch (e) {
      print('Error cancelling notifications: $e');
    }
  }
}
