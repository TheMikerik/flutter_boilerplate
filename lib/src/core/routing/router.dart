import 'package:flutter/material.dart';
import 'package:flutter_boilerplate/src/core/routing/app_startup.dart';
import 'package:flutter_boilerplate/src/core/routing/scaffold_with_nested_navigation.dart';
import 'package:flutter_boilerplate/src/features/auth/presentation/auth_screen.dart';
import 'package:flutter_boilerplate/src/features/home/presentation/home_screen.dart';
import 'package:flutter_boilerplate/src/features/settings/presentation/settings_screen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

part 'router.g.dart';

// private navigators
final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _decksNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'decks');
final _settingsNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'settings');

// https://github.com/bizz84/starter_architecture_flutter_firebase/blob/master/lib/src/routing/app_router.dart
@riverpod
GoRouter goRouter(Ref ref) {
  // we can add some logic later thanks to ref,
  // that's why we use Riverpod for GoRouter

  // TODO: Refrest router when needed
  // we can rebuild GoRouter when some state changes
  // final authRepository = ref.watch(authRepositoryProvider);
  // final appStartupState = ref.watch(appStartupProvider);

  return GoRouter(
    observers: [
      SentryNavigatorObserver(),
    ],
    initialLocation: AuthScreen.routePath,
    navigatorKey: _rootNavigatorKey,
    debugLogDiagnostics: true,
    // TODO: Check if user is logged in

    // redirect: (context, state) {
    //   // If the app is still initializing, show the /startup route
    //   if (appStartupState.isLoading || appStartupState.hasError) {
    //     return AppStartupWidget.routePath;
    //   }
    //   final path = state.uri.path;

    //   final isLoggedIn = authRepository.currentUser != null;
    //   if (isLoggedIn) {
    //     if (path.startsWith(AppStartupWidget.routePath) ||
    //         path.startsWith(OnboardingScreen.routePath) ||
    //         path.startsWith(AuthScreen.routePath)) {
    //       return HomeScreen.routePath;
    //     }
    //   } else {
    //     if (path != AuthScreen.routePath) {
    //       return AuthScreen.routePath;
    //     }
    //   }
    //   return null;
    // },
    // refreshListenable: GoRouterRefreshStream(authRepository.authStateChanges()),
    routes: [
      GoRoute(
        path: AppStartupWidget.routePath,
        name: AppStartupWidget.name,
        pageBuilder: (context, state) => NoTransitionPage(
          child: AppStartupWidget(
            // * This is just a placeholder
            // * The loaded route will be managed by GoRouter on state change
            onLoaded: (_) => const SizedBox.shrink(),
          ),
        ),
      ),
      GoRoute(
        path: AuthScreen.routePath,
        name: AuthScreen.name,
        builder: (context, state) => const AuthScreen(),
      ),
      StatefulShellRoute.indexedStack(
        pageBuilder: (context, state, navigationShell) => NoTransitionPage(
          child: ScaffoldWithNestedNavigation(
            navigationShell: navigationShell,
          ),
        ),
        branches: [
          StatefulShellBranch(
            navigatorKey: _decksNavigatorKey,
            routes: [
              GoRoute(
                path: HomeScreen.routePath,
                name: HomeScreen.name,
                pageBuilder: (context, state) => const NoTransitionPage(
                  child: HomeScreen(),
                ),
                routes: [
                  // GoRoute(
                  //   // parentNavigatorKey: _rootNavigatorKey,
                  //   path: ManageDeckScreen.routePath,
                  //   name: ManageDeckScreen.name,
                  //   pageBuilder: (context, state) {
                  //     final deckToEdit = state.extra as Deck?;
                  //     return CupertinoPage(
                  //       child: ManageDeckScreen(
                  //         deckToEdit: deckToEdit,
                  //       ),
                  //     );
                  //   },
                  // ),
                ],
              ),
            ],
          ),
          StatefulShellBranch(
            navigatorKey: _settingsNavigatorKey,
            routes: [
              GoRoute(
                path: SettingsScreen.routePath,
                name: SettingsScreen.name,
                pageBuilder: (context, state) => const NoTransitionPage(
                  child: SettingsScreen(),
                ),
                routes: [
                  // GoRoute(
                  //   path: AccountDeleteScreen.routePath,
                  //   name: AccountDeleteScreen.name,
                  //   pageBuilder: (context, state) {
                  //     return const CupertinoPage(
                  //       child: AccountDeleteScreen(),
                  //     );
                  //   },
                  // ),
                ],
              ),
            ],
          ),
        ],
      ),
    ],
    // this shouldn't happen ever in mobile apps, but just to make sure
    errorPageBuilder: (context, state) => const MaterialPage(
      child: Scaffold(
        body: Center(
          child: Text('Oops! Something went wrong.'),
        ),
      ),
    ),
  );
}
