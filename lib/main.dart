import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shot_call/bottom_bar.dart';
import 'package:shot_call/shared_prefs.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await _askForNotificationPermissions();
  await Firebase.initializeApp();
  runApp(const MyApp());
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
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.black),
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
