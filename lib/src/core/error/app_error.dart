/// A generic Error that holds an original cause (an [Object] that might be an
/// exception or something else), a [StackTrace], and an optional [message] for
/// extra context.
///
/// Since this extends [Error], it will be reported to *Sentry*.
///
/// *Throw this if you don't expect this* -
/// for example when all expected Exceptions are caught already.
class AppError extends Error {
  AppError(
    this.cause, {
    this.stackTrace,
    this.message,
  });

  /// The underlying cause of this error.
  final Object cause;

  /// The stack trace from where the error originated.
  @override
  final StackTrace? stackTrace;

  /// An optional human-readable message.
  final String? message;

  @override
  String toString() {
    if (message != null) {
      return message!;
    }
    return '''Unknown Error occured.''';
  }
}
