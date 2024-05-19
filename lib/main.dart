import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shot_call/bottom_bar.dart';
import 'package:shot_call/local_notification_service.dart';
import 'package:shot_call/shared_prefs.dart';
import 'package:shot_call/utils/get_it.dart';

Future<void> main() async {
  await _handleBeforeAppStart();
  runApp(const MyApp());
}

Future<void> _handleBeforeAppStart() async {
  WidgetsFlutterBinding.ensureInitialized();
  configureDependencies();
  await Firebase.initializeApp();
  _initializeNotificationsListeners();
  await _askForNotificationPermissions();
}

void _initializeNotificationsListeners() {
  final notificationService = getIt.get<LocalNotificationService>();
  FirebaseMessaging.onBackgroundMessage(notificationService.backgroundHandler);
  getIt.get<LocalNotificationService>().initialize();
}

Future<void> _askForNotificationPermissions() async {
  await Permission.notification.isDenied.then((isDenied) {
    if (isDenied) {
      Permission.notification.request();
    }
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: FlexThemeData.light(
        scheme: FlexScheme.bahamaBlue,
        useMaterial3: true,
        typography: Typography.material2021(),
        appBarElevation: 2,
      ),
      home: FutureBuilder(
        future: SharedPrefs().init(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return const BasicBottomNavBar();
          } else {
            return Container();
          }
        },
      ),
    );
  }
}
