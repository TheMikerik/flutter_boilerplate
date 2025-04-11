import 'package:flutter/material.dart';
import 'package:flutter_boilerplate/src/core/common/providers/shared_preferences_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'theme_mode_provider.g.dart';

const String _themePreferenceKey = 'selected_theme_mode';

@Riverpod(keepAlive: true)
class MyThemeMode extends _$MyThemeMode {
  @override
  FutureOr<ThemeMode> build() async {
    // startup widget hasnt started yet
    final prefs = await ref.read(sharedPreferencesProvider.future);
    final savedThemeMode = prefs.getString(_themePreferenceKey);
    return _getThemeModeFromString(savedThemeMode);
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    final prefs = ref.read(sharedPreferencesProvider).requireValue;
    await prefs.setString(_themePreferenceKey, mode.toString());
    state = AsyncValue.data(mode);
  }

  ThemeMode _getThemeModeFromString(String? themeString) {
    switch (themeString) {
      case 'ThemeMode.light':
        return ThemeMode.light;
      case 'ThemeMode.dark':
        return ThemeMode.dark;
      case 'ThemeMode.system':
        return ThemeMode.system;
      default:
        return ThemeMode.light;
    }
  }
}
