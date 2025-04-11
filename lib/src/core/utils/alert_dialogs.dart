import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

const kDialogDefaultKey = Key('dialog-default-key');

/// Generic function to show a platform-aware Material or Cupertino dialog
Future<bool?> showAlertDialog({
  required BuildContext context,
  required String title,
  String? content,
  Widget? contentWidget,
  String? cancelActionText,
  String defaultActionText = 'OK',
}) async {
  return showDialog(
    context: context,
    // Only make the dialog dismissible if there is a cancel button
    barrierDismissible: cancelActionText != null,
    builder: (context) {
      // If a custom widget is provided, use that.
      // Otherwise, if content is set, display it as text.
      final dialogContent =
          contentWidget ?? (content != null ? Text(content) : null);

      return AlertDialog.adaptive(
        title: Text(title),
        content: dialogContent,
        actions: kIsWeb || !Platform.isIOS
            ? <Widget>[
                if (cancelActionText != null)
                  TextButton(
                    child: Text(cancelActionText),
                    onPressed: () => Navigator.of(context).pop(false),
                  ),
                TextButton(
                  key: kDialogDefaultKey,
                  child: Text(defaultActionText),
                  onPressed: () => Navigator.of(context).pop(true),
                ),
              ]
            : <Widget>[
                if (cancelActionText != null)
                  CupertinoDialogAction(
                    child: Text(cancelActionText),
                    onPressed: () => Navigator.of(context).pop(false),
                  ),
                CupertinoDialogAction(
                  key: kDialogDefaultKey,
                  child: Text(defaultActionText),
                  onPressed: () => Navigator.of(context).pop(true),
                ),
              ],
      );
    },
  );
}

/// Generic function to show a platform-aware Material or Cupertino error dialog
Future<void> showExceptionAlertDialog({
  required BuildContext context,
  required String title,
  required dynamic exception,
}) {
  final errorString = exception.toString();

  // Determine if the platform is Android (excluding web)
  final isAndroid = !kIsWeb && Platform.isAndroid;

  // Build the content with conditional scrolling for Android
  final contentWidget = isAndroid
      ? ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.5,
          ),
          child: SingleChildScrollView(
            child: _buildErrorContent(context, errorString),
          ),
        )
      : _buildErrorContent(context, errorString);

  return showAlertDialog(
    context: context,
    title: title,
    contentWidget: contentWidget,
  ).then((_) => null);
}

// Helper method to build the error content Column
Widget _buildErrorContent(BuildContext context, String errorString) {
  return Column(
    mainAxisSize: MainAxisSize.min,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        errorString,
        style: TextStyle(
          color: Theme.of(context).colorScheme.error,
        ),
      ),
      const SizedBox(height: 16),
      // TODO: Add correct error message
      const Text(
        'Found bug or need help? Contact us on Discord (found in Settings)!',
      ),
    ],
  );
}
