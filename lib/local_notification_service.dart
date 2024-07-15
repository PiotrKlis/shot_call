import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:injectable/injectable.dart';
import 'package:shot_call/utils/get_it.dart';
import 'package:shot_call/utils/logger.dart';

@injectable
class NotificationsService {
  static final _notificationsPlugin = FlutterLocalNotificationsPlugin();

  void initialize() {
    _initializePlugin();
    _setFirebaseNotificationsListeners();
  }

  static Future<void> display(RemoteMessage message) async {
    try {
      Logger.log('displaying message! $message');
      final id = DateTime.now().millisecondsSinceEpoch ~/ 1000;
      const notificationDetails = NotificationDetails(
        android: AndroidNotificationDetails(
          'channelId',
          'channelName',
          color: Colors.green,
          importance: Importance.max,
          priority: Priority.max,
        ),
      );
      await _notificationsPlugin.show(
        id,
        message.notification?.title,
        message.notification?.body,
        notificationDetails,
        payload: message.data['route'] as String?,
      );
    } catch (error, stacktrace) {
      Logger.error('PKPK notification display failed!', stacktrace);
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

  void _setFirebaseNotificationsListeners() {
    FirebaseMessaging.instance.getInitialMessage().then((message) {
      Logger.log('getInitialMessage $message');
      if (message != null) {
        Logger.log('getInitialMessage != null $message');
        display(message);
      }
    });
    // To initialise when app is not terminated
    FirebaseMessaging.onMessage.listen((message) {
      Logger.log('onMessage $message');
      if (message.notification != null) {
        Logger.log('onMessage.notification != null $message');
        display(message);
      }
    });
    // To handle when app is open in
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      Logger.log('PKPK notification received! onMessageOpenedApp $message');
      display(message);
    });

    FirebaseMessaging.onBackgroundMessage(backgroundMessageHandler);
  }
}

@pragma('vm:entry-point')
Future<void> backgroundMessageHandler(RemoteMessage message) async {
  // final service = getIt<NotificationsService>();
  Logger.log('backgroundMessageHandler $message');
  await NotificationsService.display(message);
}

void _onDidReceiveBackgroundNotificationResponse(
    NotificationResponse response) {
  Logger.log('onDidReceiveNotificationResponse $response');

  if (response.input != null) {
    Logger.log('onDidReceiveNotificationResponse input != null');
  }
}
