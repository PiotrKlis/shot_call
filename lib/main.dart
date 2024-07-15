import 'package:device_preview/device_preview.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shot_call/local_notification_service.dart';
import 'package:shot_call/shared_prefs.dart';
import 'package:shot_call/utils/get_it.dart';
import 'package:shot_call/utils/navigation_config.dart';

Future<void> main() async {
  await _handleBeforeAppStart();
  runApp(const ProviderScope(child: MyApp()));
}

Future<void> _handleBeforeAppStart() async {
  WidgetsFlutterBinding.ensureInitialized();
  initializeDependencyInjection();
  await Firebase.initializeApp();
  await _initializeSharedPreferences();
  _initializeNotificationsListeners();
  await _askForNotificationPermissions();
}

Future<void> _initializeSharedPreferences() async {
  await getIt.get<SharedPrefs>().init();
}

void _initializeNotificationsListeners() {
  getIt.get<NotificationsService>().initialize();
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

  // iphone 12 mini
  // Apple iPhone 13
  // big
  @override
  Widget build(BuildContext context) {
    // return DevicePreview(
    //   builder: (BuildContext context) {
    return MaterialApp.router(
      useInheritedMediaQuery: true,
      locale: DevicePreview.locale(context),
      builder: DevicePreview.appBuilder,
      routerConfig: goRouter,
      title: 'Call the Shots',
      theme: FlexThemeData.dark(
        useMaterial3: true,
      ),
      // );
      // },
    );
  }
}
