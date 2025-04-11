import 'package:flutter/material.dart';
import 'package:flutter_boilerplate/src/core/common/providers/connection_status_provider.dart';
import 'package:flutter_boilerplate/src/core/common/widgets/buttons/primary_button.dart';
import 'package:flutter_boilerplate/src/core/extensions/theme_data_extension.dart';
import 'package:flutter_boilerplate/src/core/resources/assets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'app_startup.g.dart';

// https://codewithandrea.com/articles/robust-app-initialization-riverpod/
@Riverpod(keepAlive: true)
Future<void> appStartup(Ref ref) async {
  // put here any providers which might fail while initializing (network, ..)
  ref.onDispose(() {
    // ensure dependent providers are disposed as well

    // moved shared preferences init to main() ->
    // user wouldn't be able to refresh screen anyway
    // ref.invalidate(sharedPreferencesProvider);
  });

  // precache all images
  SvgAssets.svgPrecacheImage();

  ref.read(connectionStatusProvider);
}

/// Widget class to manage asynchronous app initialization
class AppStartupWidget extends ConsumerWidget {
  const AppStartupWidget({required this.onLoaded, super.key});
  final WidgetBuilder onLoaded;

  static const routePath = '/startup';
  static const name = 'startup';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appStartupState = ref.watch(appStartupProvider);
    return appStartupState.when(
      data: (_) => onLoaded(context),
      loading: () => const AppStartupLoadingWidget(),
      error: (e, st) {
        return AppStartupErrorWidget(
          message: e.toString(),
          onRetry: () => ref.invalidate(appStartupProvider),
        );
      },
    );
  }
}

class AppStartupLoadingWidget extends StatelessWidget {
  const AppStartupLoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}

class AppStartupErrorWidget extends StatelessWidget {
  const AppStartupErrorWidget({
    required this.message,
    required this.onRetry,
    super.key,
  });
  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              message,
              style: context.t.headlineSmall,
            ),
            const SizedBox(
              height: 16,
            ),
            PrimaryButton(
              onPressed: onRetry,
              text: 'Retry',
            ),
          ],
        ),
      ),
    );
  }
}
