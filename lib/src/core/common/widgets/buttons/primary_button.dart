import 'package:flutter/material.dart';
import 'package:flutter_boilerplate/src/core/common/providers/haptic_feedback_provider.dart';
import 'package:flutter_boilerplate/src/core/extensions/theme_data_extension.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PrimaryButton extends ConsumerWidget {
  const PrimaryButton({
    required this.text,
    this.isLoading = false,
    this.height = 60,
    this.borderRadius = 16,
    this.backgroundColor,
    this.foregroundColor,
    this.onPressed,
    super.key,
  });

  final String text;
  final bool isLoading;
  final double height;
  final double borderRadius;
  final VoidCallback? onPressed;
  final Color? backgroundColor;
  final Color? foregroundColor;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SizedBox(
      width: double.infinity,
      height: height,
      child: FilledButton(
        style: ButtonStyle(
          backgroundColor: isLoading
              ? WidgetStateProperty.all<Color>(
                  backgroundColor?.withAlpha(80) ??
                      context.c.primary.withAlpha(80),
                )
              : WidgetStateProperty.all<Color>(
                  backgroundColor ?? context.c.primary,
                ),
          shape: WidgetStateProperty.all<OutlinedBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(borderRadius),
            ),
          ),
        ),
        onPressed: isLoading
            ? null
            : () {
                if (onPressed != null) {
                  ref.read(hapticProvider.notifier).vibrate();
                  onPressed!();
                }
              },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              text,
              textAlign: TextAlign.center,
              style: isLoading
                  ? context.t.bodyLarge!.copyWith(
                      color:
                          foregroundColor?.withAlpha(75) ?? context.c.surface,
                    )
                  : context.t.bodyLarge!.copyWith(
                      color: foregroundColor ?? context.c.onPrimary,
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
