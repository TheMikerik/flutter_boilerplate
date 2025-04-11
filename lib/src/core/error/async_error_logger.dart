import 'package:flutter_boilerplate/src/core/error/app_error.dart';
import 'package:flutter_boilerplate/src/core/error/app_exception.dart';
import 'package:flutter_boilerplate/src/core/error/error_logger.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Error logger class to keep track of all AsyncError states that are set
/// by the controller classes in the app
class AsyncErrorLogger extends ProviderObserver {
  // this will be called everytime a provider's value changes inside container
  @override
  void didUpdateProvider(
    ProviderBase<dynamic> provider,
    Object? previousValue,
    Object? newValue,
    ProviderContainer container,
  ) {
    final errorLogger = container.read(errorLoggerProvider);
    // AsyncError
    final error = _findError(newValue);
    if (error != null) {
      if (error.error is AppException) {
        errorLogger.logAppException(error.error as AppException);
      } else if (error.error is AppError) {
        // directly log the cause from AppError
        final appError = error.error as AppError;
        errorLogger.logError(appError.cause, appError.stackTrace);
      } else {
        errorLogger.logError(error.error, error.stackTrace);
      }
    }
  }

  AsyncError<dynamic>? _findError(Object? value) {
    // if we have some custom states for controllers defined,
    // with AsyncValue inside them, we can check for the errors "deeply" here

    // example: EmailSignInController -> AsyncNotifier<EmailPasswordSignInState>
    /// &
    /// EmailPasswordSignInState({
    /// this.formType = EmailPasswordSignInFormType.signIn,
    /// this.value = const AsyncValue.data(null),
    /// COMMENT: this.value can be AsyncLoading,AsyncData, AsyncError
    /// });

    // if (value is EmailPasswordSignInState && value.value is AsyncError) {
    //   return value.value as AsyncError;
    // } else

    if (value is AsyncError) {
      return value;
    } else {
      return null;
    }
  }
}
