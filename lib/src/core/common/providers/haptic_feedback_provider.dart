import 'package:flutter/services.dart';
import 'package:flutter_boilerplate/src/core/common/providers/shared_preferences_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'haptic_feedback_provider.g.dart';

const String _hapticFeedbackKey = 'haptic_feedback_enabled';

@Riverpod(keepAlive: true)
class Haptic extends _$Haptic {
  @override
  bool build() {
    final prefs = ref.read(sharedPreferencesProvider).requireValue;
    return prefs.getBool(_hapticFeedbackKey) ?? true;
  }

  void toggleHaptic({
    required bool doHapticFeedback,
  }) {
    ref
        .read(sharedPreferencesProvider)
        .requireValue
        .setBool(_hapticFeedbackKey, doHapticFeedback);
    state = doHapticFeedback;
  }

  void vibrate({
    bool forceVibration = false,
  }) {
    if (state || forceVibration) {
      HapticFeedback.lightImpact();
    }
  }

  void vibrateMedium() {
    if (state) {
      HapticFeedback.mediumImpact();
    }
  }

  void vibrateHeavy() {
    if (state) {
      HapticFeedback.heavyImpact();
    }
  }

  void vibrateSelection() {
    if (state) {
      HapticFeedback.selectionClick();
    }
  }

  Future<void> vibrateFor({
    required int milisecondsBreak,
    required int repetitions,
  }) async {
    for (var i = 0; i < repetitions; i++) {
      ref.read(hapticProvider.notifier).vibrateHeavy();
      await Future<void>.delayed(Duration(milliseconds: milisecondsBreak));
    }
  }
}
