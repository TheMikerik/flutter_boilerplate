import 'package:flutter/material.dart';
import 'package:flutter_boilerplate/src/core/routing/app_startup.dart';
import 'package:flutter_boilerplate/src/core/routing/router.dart';
import 'package:flutter_boilerplate/src/core/theme/theme.dart';
import 'package:flutter_boilerplate/src/core/theme/theme_mode_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class App extends ConsumerWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final goRouter = ref.watch(goRouterProvider);
    final themeMode = ref.watch(myThemeModeProvider);

    return TooltipVisibility(
      visible: false,
      child: MaterialApp.router(
        routerConfig: goRouter,
        builder: (_, child) {
          return AppStartupWidget(
            onLoaded: (_) => child!,
          );
        },
        debugShowCheckedModeBanner: false,
        themeMode: themeMode.value ?? ThemeMode.system,
        theme: AppTheme.lightMode,
        darkTheme: AppTheme.darkMode,
      ),
    );
  }
}
