import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shot_call/utils/connection_status.dart';
import 'package:shot_call/utils/context_extensions.dart';

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
        destinations: const [
          NavigationDestination(
            label: 'Call the Shots',
            icon: Icon(Icons.local_drink),
          ),
          NavigationDestination(
            label: 'Parties',
            icon: Icon(Icons.six_ft_apart),
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
          context.showFailedSnackBar('No internet connection :(');
          wasOffline = true;
        }
        if (wasOffline && next == const AsyncData(ConnectivityStatus.online)) {
          context.showSuccessfulSnackBar('Internet connection is back :)');
          wasOffline = false;
        }
      },
    );
  }
}
