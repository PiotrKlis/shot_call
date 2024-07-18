import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shot_call/common/navigation/navigation_constants.dart';
import 'package:shot_call/common/navigation/screen_navigation_key.dart';
import 'package:shot_call/screens/account/account_screen.dart';
import 'package:shot_call/screens/app_frame_with_nav_bar.dart';
import 'package:shot_call/screens/home/home_screen.dart';
import 'package:shot_call/screens/parties/parties_screen.dart';
import 'package:shot_call/screens/party_participants/party_participants_screen.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _homeShellNavigatorKey = GlobalKey<NavigatorState>();
final _partiesShellNavigatorKey = GlobalKey<NavigatorState>();
final _accountShellNavigatorKey = GlobalKey<NavigatorState>();

final goRouter = GoRouter(
  initialLocation: '/${ScreenNavigationKey.home}',
  navigatorKey: _rootNavigatorKey,
  debugLogDiagnostics: true,
  routes: [
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) {
        return AppFrameWithNavBar(navigationShell: navigationShell);
      },
      branches: [
        StatefulShellBranch(
          navigatorKey: _homeShellNavigatorKey,
          routes: [
            GoRoute(
              name: ScreenNavigationKey.home,
              path: '/${ScreenNavigationKey.home}',
              pageBuilder: (BuildContext context, GoRouterState state) {
                return const NoTransitionPage(
                  child: HomeScreen(),
                );
              },
            ),
          ],
        ),
        StatefulShellBranch(
          navigatorKey: _partiesShellNavigatorKey,
          routes: [
            GoRoute(
              name: ScreenNavigationKey.parties,
              path: '/${ScreenNavigationKey.parties}',
              pageBuilder: (BuildContext context, GoRouterState state) {
                return const NoTransitionPage(
                  child: PartiesScreen(),
                );
              },
              routes: [
                GoRoute(
                  name: ScreenNavigationKey.partyMembers,
                  path:
                      '${ScreenNavigationKey.parties}/${ScreenNavigationKey.partyMembers}/:${NavigationConstants.partyId}',
                  // Correctly include path parameter
                  pageBuilder: (BuildContext context, GoRouterState state) {
                    return NoTransitionPage(
                      child: PartyParticipantsScreen(
                        partyId:
                            state.pathParameters[NavigationConstants.partyId]!,
                      ),
                    );
                  },
                ),
              ],
            ),
          ],
        ),
        StatefulShellBranch(
          navigatorKey: _accountShellNavigatorKey,
          routes: [
            GoRoute(
              name: ScreenNavigationKey.account,
              path: '/${ScreenNavigationKey.account}',
              pageBuilder: (BuildContext context, GoRouterState state) {
                return const NoTransitionPage(
                  child: AccountScreen(),
                );
              },
            ),
          ],
        ),
      ],
    ),
  ],
);
