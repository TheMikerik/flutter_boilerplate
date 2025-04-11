import 'package:flutter/material.dart';
import 'package:flutter_boilerplate/src/core/error/app_exception.dart';
import 'package:flutter_boilerplate/src/core/utils/alert_dialogs.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

extension AsyncValueUI on AsyncValue<dynamic> {
  Future<void> showAlertDialogOnError(BuildContext context) async {
    if (!isLoading && hasError) {
      // missing permissions
      if (error is PermissionDeniedException) {
        final shouldOpenSettings = await showAlertDialog(
              context: context,
              title: '$error',
              content: 'Please grant access in settings.',
              cancelActionText: 'Cancel',
              defaultActionText: 'Open settings',
            ) ??
            false;

        if (shouldOpenSettings) {
          await openAppSettings();
        }
        return;
      }

      // ERROR HANDLING
      String message;
      if (error is PostgrestException) {
        message = (error! as PostgrestException).message;
      } else if (error is FunctionException) {
        message =
            (error! as FunctionException).reasonPhrase ?? 'Unknown Exception';
      } else if (error is SignInWithAppleAuthorizationException ||
          error is SignInWithAppleCredentialsException ||
          error is SignInWithAppleNotSupportedException) {
        message = 'Apple Sign In failed. Please try again.';
      }
      // if the error is AppException, the toString should return normal message
      // otherwise will be something like: SqliteError(mess: 'blabla', code: ..)
      else {
        message = error.toString();
      }
      await showExceptionAlertDialog(
        context: context,
        title: 'Error',
        exception: message,
      );
    }
  }
}
