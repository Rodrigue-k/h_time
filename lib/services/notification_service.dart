import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

/// Classe de service pour gérer les notifications locales sur Windows.
class NotificationService {
  // Instance singleton pour garantir une seule instance dans l'application
  static final NotificationService _instance = NotificationService._internal();

  // Instance du plugin FlutterLocalNotificationsPlugin
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  // Constructeur factory pour retourner l'instance singleton
  factory NotificationService() {
    return _instance;
  }

  // Constructeur privé interne pour l'initialisation
  NotificationService._internal();

  /// Initialise le plugin de notifications pour Windows.
  Future<void> init() async {
    // Paramètres spécifiques à Windows
    const WindowsInitializationSettings windowsInitializationSettings =
        WindowsInitializationSettings(
      appName: 'Mon Application', // Nom affiché dans la notification
      appUserModelId: 'MaSociete.MonApplication', // Identifiant unique de l'application
      guid: '12345678-1234-1234-1234-123456789012', // GUID unique pour les callbacks
      // iconPath: 'data/notification_icon.png', // Chemin optionnel vers une icône
    );

    // Paramètres d'initialisation combinés (seulement Windows ici)
    final InitializationSettings initializationSettings = InitializationSettings(
      windows: windowsInitializationSettings,
    );

    // Initialisation du plugin avec un callback pour gérer les interactions
    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        // Callback appelé quand l'utilisateur clique sur la notification
        // Vous pouvez ajouter une logique ici, par exemple naviguer vers une page
        if (kDebugMode) {
          print('Notification cliquée : ${response.payload}');
        }
      },
    );
  }

  /// Affiche une notification simple sur Windows.
  /// - [id] : Identifiant unique de la notification.
  /// - [title] : Titre de la notification.
  /// - [body] : Corps du message de la notification.
  Future<void> showNotification({
    required int id,
    required String title,
    required String body,
  }) async {
    // Détails spécifiques à Windows pour la notification
    const WindowsNotificationDetails windowsNotificationDetails =
        WindowsNotificationDetails();

    // Détails de la notification combinés
    const NotificationDetails notificationDetails = NotificationDetails(
      windows: windowsNotificationDetails,
    );

    // Affichage de la notification
    await flutterLocalNotificationsPlugin.show(
      id, // Identifiant unique
      title, // Titre
      body, // Corps
      notificationDetails, // Détails spécifiques à la plateforme
    );
  }
}

// Exemple d'utilisation (à placer dans votre code principal, par exemple main.dart)
/*
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialisation du service de notifications
  final notificationService = NotificationService();
  await notificationService.init();

  runApp(MyApp(notificationService: notificationService));
}

class MyApp extends StatelessWidget {
  final NotificationService notificationService;

  const MyApp({required this.notificationService, super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('Test Notifications')),
        body: Center(
          child: ElevatedButton(
            onPressed: () async {
              // Afficher une notification
              await notificationService.showNotification(
                id: 0,
                title: 'Test Notification',
                body: 'Ceci est une notification sur Windows !',
              );
            },
            child: const Text('Afficher Notification'),
          ),
        ),
      ),
    );
  }
}
*/