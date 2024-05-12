import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shot_call/bottom_bar.dart';
import 'package:shot_call/local_notification_service.dart';
import 'package:shot_call/shared_prefs.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await _askForNotificationPermissions();
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(backgroundHandler);
  runApp(const MyApp());
}

Future backgroundHandler(RemoteMessage msg) async {}

Future<void> _askForNotificationPermissions() async {
  await Permission.notification.isDenied.then((isDenied) {
    if (isDenied) {
      Permission.notification.request();
    }
  });
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    LocalNotificationService.initialize();
  }

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
