import 'package:permission_handler/permission_handler.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'notification_permission_provider.g.dart';

@riverpod
Stream<PermissionStatus> notificationPermissionStatus(
  NotificationPermissionStatusRef ref,
) async* {
  yield* Permission.notification.status.asStream().map((status) {
    return status;
  });
}
