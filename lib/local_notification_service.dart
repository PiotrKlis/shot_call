import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:injectable/injectable.dart';
import 'package:shot_call/utils/get_it.dart';

// The backgroundHandler needs to be either a static function
// or a top level function to be accessible as a Flutter entry point.
Future<void> _backgroundHandler(RemoteMessage message) {
  print('PKPK notification received! backgroundHandler');
  return getIt.get<NotificationsService>().display(message);
}

@injectable
class NotificationsService {
  final _notificationsPlugin = FlutterLocalNotificationsPlugin();

  void initialize() {
    _initializePlugin();
    _setFirebaseNotificationsListeners();
  }

  Future<void> display(RemoteMessage message) async {
    // To display the notification in device
    try {
      final id = DateTime.now().millisecondsSinceEpoch ~/ 1000;
      const notificationDetails = NotificationDetails(
        android: AndroidNotificationDetails('channelId', 'channelName',
            color: Colors.green,
            importance: Importance.max,
            playSound: true,
            priority: Priority.high),
      );
      await _notificationsPlugin.show(
        id,
        message.notification?.title,
        message.notification?.body,
        notificationDetails,
        payload: message.data['route'] as String?,
      );
    } catch (e) {
      print('PKPK notification display failed!');
    }
  }

  void _initializePlugin() {
    const initializationSettingsAndroid = InitializationSettings(
      android: AndroidInitializationSettings('@drawable/ic_launcher'),
      iOS: DarwinInitializationSettings(),
    );

    _notificationsPlugin.initialize(
      initializationSettingsAndroid,
      onDidReceiveBackgroundNotificationResponse:
          _onDidReceiveBackgroundNotificationResponse,
    );
  }

  void _onDidReceiveBackgroundNotificationResponse(
      NotificationResponse details) {
    if (details.input != null) {
      print('PKPK notification received! onDidReceiveNotificationResponse');
    }
  }

  void _setFirebaseNotificationsListeners() {
    FirebaseMessaging.onBackgroundMessage(_backgroundHandler);

    FirebaseMessaging.instance.getInitialMessage().then((message) {
      print('PKPK notification received! getInitialMessage');
      // display(message!);
    });
    // To initialise when app is not terminated
    FirebaseMessaging.onMessage.listen((message) {
      if (message.notification != null) {
        print('PKPK notification received! onMessage');
        display(message);
      }
    });
    // To handle when app is open in
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      print('PKPK notification received! onMessageOpenedApp');
      display(message);
    });

    FirebaseMessaging.onBackgroundMessage((message) {
      print('PKPK notification received! onBackgroundMessage');
      return display(message);
    });
  }
}
