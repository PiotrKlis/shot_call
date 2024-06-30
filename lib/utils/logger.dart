import 'package:flutter/foundation.dart';

class Logger {
  static void log(String message) {
    if (kDebugMode) {
      debugPrint('Logger $message');
    }
  }

  static void error(Object error, StackTrace stackTrace) {
    if (kDebugMode) {
      debugPrint('Logger error: $error');
      debugPrint('Logger stacktrace: $stackTrace');
    }
  }
}
