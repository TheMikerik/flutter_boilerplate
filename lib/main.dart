import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_boilerplate/env/env.dart';
import 'package:flutter_boilerplate/env/flavor.dart';
import 'package:flutter_boilerplate/src/app.dart';
import 'package:flutter_boilerplate/src/core/common/providers/shared_preferences_provider.dart';
import 'package:flutter_boilerplate/src/core/error/async_error_logger.dart';
import 'package:flutter_boilerplate/src/core/error/error_logger.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);

  final container = ProviderContainer(
    observers: [
      AsyncErrorLogger(),
    ],
  );

  // * Register error handlers. For more info, see:
  // * https://docs.flutter.dev/testing/errors
  final errorLogger = container.read(errorLoggerProvider);
  registerErrorHandlers(errorLogger);

  // initialization can only fail due to a programmer error,
  // that's why we init it here in main instead of app startup
  // * initialize Supabase
  if (getFlavor() == Flavor.prod) {
    await Supabase.initialize(
      url: Env.supabaseUrl,
      anonKey: Env.supabaseAnonKey,
    );
  } else if (getFlavor() == Flavor.stg) {
    await Supabase.initialize(
      url: Env.supabaseUrl,
      anonKey: Env.supabaseAnonKey,
    );
  } else {
    // LOCAL dev
    await Supabase.initialize(
      url: Env.supabaseLocalUrl,
      anonKey: Env.supabaseLocalAnonKey,
    );
  }

  // * Preload SharedPreferences before calling runApp, as the AppStartupWidget
  // * depends on it in order to load the themeMode
  await container.read(sharedPreferencesProvider.future);

  await SentryFlutter.init(
    (options) {
      options.dsn = Env.sentryDsn;
    },
    appRunner: () => runApp(
      UncontrolledProviderScope(
        container: container,
        child: const App(),
      ),
    ),
  );
}

void registerErrorHandlers(ErrorLogger errorLogger) {
  // * Show some error UI if any uncaught exception happens
  FlutterError.onError = (FlutterErrorDetails details) {
    FlutterError.presentError(details);
    errorLogger.logError(details.exception, details.stack);
    debugPrint(details.toString());
  };
  // * Handle errors from the underlying platform/OS
  PlatformDispatcher.instance.onError = (Object error, StackTrace stack) {
    errorLogger.logError(error, stack);
    debugPrint(error.toString());
    return true;
  };
  // * Show some error UI when any widget in the app fails to build
  ErrorWidget.builder = (FlutterErrorDetails details) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: const Text('Error :('),
      ),
      body: const Center(
        // not showing details.exception, which could be security flaw
        child: Text(
          '''
            An unexpected error occurred. 
            Please contact us on our discord server or try again later.
          ''',
        ),
      ),
    );
  };
}
