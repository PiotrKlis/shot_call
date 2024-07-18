import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'connection_status.g.dart';

enum ConnectivityStatus { online, offline }

@riverpod
Stream<ConnectivityStatus> connectivityStatus(
  ConnectivityStatusRef ref,
) async* {
  final connectivityStream = Connectivity().onConnectivityChanged;
  await for (final result in connectivityStream) {
    yield _updateConnectionStatus(result);
  }
}

ConnectivityStatus _updateConnectionStatus(List<ConnectivityResult> result) {
  if (result.contains(ConnectivityResult.none)) {
    return ConnectivityStatus.offline;
  } else {
    return ConnectivityStatus.online;
  }
}
