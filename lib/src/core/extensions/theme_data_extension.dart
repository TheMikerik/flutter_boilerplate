import 'package:flutter/material.dart';

extension ThemeDataExtensions on BuildContext {
  ColorScheme get c => Theme.of(this).colorScheme;
  TextTheme get t => Theme.of(this).textTheme;
}
