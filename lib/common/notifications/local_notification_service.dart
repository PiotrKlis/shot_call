import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:injectable/injectable.dart';
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
      final id = DateTime.now().millisecondsSinceEpoch ~/ 1000;
      const notificationDetails = NotificationDetails(
        iOS: DarwinNotificationDetails(),
        android: AndroidNotificationDetails(
          'channelId',
          'channelName',
          color: Colors.green,
          importance: Importance.max,
          priority: Priority.max,
        ),
      );
      final alarmer = message.notification?.title;
      final defaultLocale = Platform.localeName;
      final title = (defaultLocale.contains('en'))
          ? '$alarmer needs backup!'
          : '$alarmer potrzebuje wsparcia!';
      final body = (defaultLocale.contains('en'))
          ? 'Immediately run to have a drink with him!'
          : 'Natychmiast rzuć wszystko i biegnij się napić!';

      await _notificationsPlugin.show(
        id,
        title,
        body,
        notificationDetails,
        payload: message.data['route'] as String?,
      );
    } catch (error, stacktrace) {
      Logger.error('notification display failed!', stacktrace);
    }
  }

  void _initializePlugin() {
    const initializationSettingsAndroid =
        AndroidInitializationSettings('@drawable/ic_launcher');
    final initializationSettingsIOS = DarwinInitializationSettings(
      onDidReceiveLocalNotification: onDidReceiveLocalNotification,
    );
    final initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );

    _notificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveBackgroundNotificationResponse:
          _onDidReceiveBackgroundNotificationResponse,
    );
  }

  Future<void> onDidReceiveLocalNotification(
    int id,
    String? title,
    String? body,
    String? payload,
  ) async {
    await display(
      RemoteMessage(notification: RemoteNotification(title: title)),
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
      Logger.log('notification received! onMessageOpenedApp $message');
      display(message);
    });

    FirebaseMessaging.onBackgroundMessage(backgroundMessageHandler);
  }
}

@pragma('vm:entry-point')
Future<void> backgroundMessageHandler(RemoteMessage message) async {
  Logger.log('backgroundMessageHandler $message');
  await NotificationsService.display(message);
}

void _onDidReceiveBackgroundNotificationResponse(
  NotificationResponse response,
) {
  Logger.log('onDidReceiveNotificationResponse $response');
  if (response.input != null) {
    Logger.log('onDidReceiveNotificationResponse input != null');
  }
}
