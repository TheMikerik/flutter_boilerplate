import 'package:flutter/material.dart';
import 'package:flutter_boilerplate/src/core/error/app_exception.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

part 'error_logger.g.dart';

class ErrorLogger {
  void logError(Object error, StackTrace? stackTrace) {
    debugPrint('logError() - error: $error, st: $stackTrace');

    Sentry.captureException(
      error,
      stackTrace: stackTrace,
    );
  }

  void logAppException(AppException exception) {
    debugPrint('logException() - exception: $exception');
    //* We don't want to log recoverable exceptions to Sentry
    // Sentry.captureException(
    //   exception,
    // );
  }
}

@riverpod
ErrorLogger errorLogger(Ref ref) => ErrorLogger();
