import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'app_theme_state.freezed.dart';

@freezed
abstract class AppThemeState with _$AppThemeState {
  const AppThemeState._();

  const factory AppThemeState({@Default(true) bool isDark}) = _AppThemeState;

  ThemeMode get themeMode => isDark ? ThemeMode.dark : ThemeMode.light;
}
