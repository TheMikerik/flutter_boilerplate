import 'package:flutter/material.dart';
import 'package:flutter_boilerplate/src/core/extensions/theme_data_extension.dart';
import 'package:hugeicons/hugeicons.dart';

extension ContextExtension on BuildContext {
  void showSnackBar(
    String message, {
    bool isError = false,
    double bottomMargin = 0,
    int duration = 3,
  }) {
    ScaffoldMessenger.of(this)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Row(
            children: [
              if (isError)
                HugeIcon(
                  icon: HugeIcons.strokeRoundedAlert02,
                  color: c.onErrorContainer,
                )
              else
                HugeIcon(
                  icon: HugeIcons.strokeRoundedTick02,
                  color: c.onPrimary,
                ),
              const SizedBox(width: 10),
              Text(
                message,
                style: isError
                    ? t.bodyMedium!.copyWith(color: c.onErrorContainer)
                    : t.bodyMedium!.copyWith(color: c.onPrimary),
              ),
              const Spacer(),
              GestureDetector(
                onTap: () => ScaffoldMessenger.of(this).hideCurrentSnackBar(),
                child: HugeIcon(
                  icon: HugeIcons.strokeRoundedMultiplicationSign,
                  color: c.onError,
                ),
              ),
            ],
          ),
          duration: Duration(seconds: duration),
          behavior: SnackBarBehavior.floating,
          margin: EdgeInsets.only(bottom: bottomMargin, left: 16, right: 16),
          backgroundColor: isError ? c.errorContainer : c.primary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );
  }
}
