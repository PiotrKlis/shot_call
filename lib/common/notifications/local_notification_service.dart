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
      final defaultLocale = Platform.localeName;
      final alarmer = (defaultLocale.contains('en'))
          ? message.data['title']?.split(' ')?.first ?? 'Somebody'
          : message.data['title']?.split(' ')?.first ?? 'Ktoś';
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
    Logger.log('onDidReceiveLocalNotification');
    await display(
      RemoteMessage(notification: RemoteNotification(title: title)),
    );
  }

  void _setFirebaseNotificationsListeners() {
    FirebaseMessaging.onMessage.listen((message) {
      Logger.log('onMessage $message');
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
