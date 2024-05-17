import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shot_call/bottom_bar.dart';
import 'package:shot_call/local_notification_service.dart';
import 'package:shot_call/shared_prefs.dart';
import 'package:shot_call/utils/get_it.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  configureDependencies();
  await Firebase.initializeApp();
  _initializeNotificationsListeners();
  await _askForNotificationPermissions();
  runApp(const MyApp());
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
      theme: ThemeData(
        colorScheme: const ColorScheme.dark(),
        useMaterial3: true,
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
