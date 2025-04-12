import 'package:flutter/material.dart';

class OnboardingStep {
  const OnboardingStep.content({
    required this.title,
  }) : widget = null;

  const OnboardingStep.survey({
    required this.title,
  }) : widget = null;

  const OnboardingStep.custom({
    required this.title,
  }) : widget = null;

  final String? title;
  final Widget? widget;
  final bool countForProgress = false;
}
