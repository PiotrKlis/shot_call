import 'package:firebase_core/firebase_core.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shot_call/local_notification_service.dart';
import 'package:shot_call/shared_prefs.dart';
import 'package:shot_call/utils/get_it.dart';
import 'package:shot_call/utils/navigation_config.dart';

part 'main.g.dart';

@riverpod
String helloWorld(HelloWorldRef ref) {
  return 'Hello world';
}

final dupaProvider = Provider<String>((ref) {
  return 'dupa';
});

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

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp.router(
      routerConfig: goRouter,
      title: 'Call the Shots',
      theme: FlexThemeData.light(
        scheme: FlexScheme.bahamaBlue,
        useMaterial3: true,
        typography: Typography.material2021(),
      ),
    );
  }
}
