import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class LocalNotificationService {
  // Instance of Flutternotification plugin
  static final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static void initialize() {
    // Initialization setting for android
    const initializationSettingsAndroid = InitializationSettings(
      android: AndroidInitializationSettings("@drawable/ic_launcher"),
      iOS: DarwinInitializationSettings(),
    );

    _notificationsPlugin.initialize(
      initializationSettingsAndroid,
      onDidReceiveNotificationResponse: (details) {
        if (details.input != null) {}
      },
    );

    FirebaseMessaging.instance.getInitialMessage().then((message) {
      print("PKPK notification received! getInitialMessage");
      LocalNotificationService.display(message!);
    });
    // To initialise when app is not terminated
    FirebaseMessaging.onMessage.listen((message) {
      if (message.notification != null) {
        print("PKPK notification received! onMessage");
        LocalNotificationService.display(message);
      }
    });
    // To handle when app is open in
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      print("PKPK notification received! onMessageOpenedApp");
      LocalNotificationService.display(message);
    });

    FirebaseMessaging.onBackgroundMessage((message) {
      print("PKPK notification received! onBackgroundMessage");
      return LocalNotificationService.display(message);
    });
  }

  static Future<void> display(RemoteMessage message) async {
    // To display the notification in device
    try {
      final id = DateTime.now().millisecondsSinceEpoch ~/ 1000;
      NotificationDetails notificationDetails = NotificationDetails(
        android: AndroidNotificationDetails("channelId", "channelName",
            color: Colors.green,
            importance: Importance.max,
            playSound: true,
            priority: Priority.high),
      );
      await _notificationsPlugin.show(id, message.notification?.title,
          message.notification?.body, notificationDetails,
          payload: message.data['route']);
    } catch (e) {
      print("PKPK notification display failed!");
    }
  }
}

Future backgroundHandler(RemoteMessage message) async {
  print("PKPK notification received! backgroundHandler");
  LocalNotificationService.display(message);
}
