import 'package:flutter_boilerplate/src/core/common/providers/shared_preferences_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'onboarding_repository.g.dart';

class OnboardingRepository {
  OnboardingRepository(this.sharedPreferences);
  final SharedPreferences sharedPreferences;

  static const onboardingCompleteKey = 'onboardingComplete';

  Future<void> setOnboardingComplete() async {
    await sharedPreferences.setBool(onboardingCompleteKey, true);
  }

  Future<void> setOnboardingNotComplete() async {
    await sharedPreferences.setBool(onboardingCompleteKey, false);
  }

  bool isOnboardingComplete() =>
      sharedPreferences.getBool(onboardingCompleteKey) ?? false;
}

@Riverpod(keepAlive: true)
OnboardingRepository onboardingRepository(
  Ref ref,
) {
  return OnboardingRepository(
    // initialized inside app startup, so it will have value
    ref.watch(sharedPreferencesProvider).requireValue,
  );
}
