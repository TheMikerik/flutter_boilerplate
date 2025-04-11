import 'package:permission_handler/permission_handler.dart';

/// Throw this (or its child) if you expect Exception to happen.
///
/// Otherwise throw [AppError], because this *won't* be reported to *Sentry*
sealed class AppException implements Exception {
  const AppException(
    this.error,
  );

  final Object? error;

  @override
  String toString() {
    return 'An error occurred: $error';
  }
}

// GENERAL
/// Throw this if you expect Exception to happen, but it's too difficult for
/// regular user to understand
class UnknownException extends AppException {
  UnknownException() : super(null);

  @override
  String toString() {
    return 'An unknown exception has occurred.';
  }
}

class PermissionDeniedException extends AppException {
  PermissionDeniedException(this.permission) : super(null);
  final Permission permission;

  @override
  String toString() {
    return 'Permission denied: $permission';
  }
}
