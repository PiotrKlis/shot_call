import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shot_call/common/connection_status/connection_status.dart';
import 'package:shot_call/common/extensions/context_extensions.dart';

class AppFrameWithNavBar extends ConsumerWidget {
  const AppFrameWithNavBar({
    required this.navigationShell,
    Key? key,
  }) : super(key: key ?? const ValueKey('ScaffoldWithNestedNavigation'));
  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    _listenForConnectivityChanges(ref, context);
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: NavigationBar(
        selectedIndex: navigationShell.currentIndex,
        destinations: [
          NavigationDestination(
            label: context.strings.app_name,
            icon: const Icon(Icons.local_drink),
          ),
          NavigationDestination(
            label: context.strings.parties,
            icon: const Icon(Icons.meeting_room),
          ),
          NavigationDestination(
            label: context.strings.user,
            icon: const Icon(Icons.manage_accounts),
          ),
        ],
        onDestinationSelected: _goBranch,
      ),
    );
  }

  void _goBranch(int index) {
    navigationShell.goBranch(
      index,
      initialLocation: index == navigationShell.currentIndex,
    );
  }

  void _listenForConnectivityChanges(WidgetRef ref, BuildContext context) {
    var wasOffline = false;
    ref.listen(
      connectivityStatusProvider,
      (previous, next) {
        if (next == const AsyncData(ConnectivityStatus.offline)) {
          context.showFailedSnackBar(context.strings.offline_info);
          wasOffline = true;
        }
        if (wasOffline && next == const AsyncData(ConnectivityStatus.online)) {
          context.showSuccessfulSnackBar(context.strings.online_info);
          wasOffline = false;
        }
      },
    );
  }
}
