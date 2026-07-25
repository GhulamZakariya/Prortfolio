import 'package:flutter/material.dart';
import 'package:my_portfolio/presentation/resources/app_colors.dart';
import 'package:my_portfolio/presentation/resources/app_text_styles.dart';

/// Builds the light and dark [ThemeData]. Both register [AppPalette] as a
/// [ThemeExtension] so semantic colors are available via `context.colors`.
class AppTheme {
  AppTheme._();

  static ThemeData get dark => _build(AppPalette.dark);
  static ThemeData get light => _build(AppPalette.light);

  static ThemeData _build(AppPalette palette) {
    final scheme = ColorScheme(
      brightness: palette.isDark ? Brightness.dark : Brightness.light,
      primary: AppColors.primary,
      onPrimary: const Color(0xFF1A1400),
      secondary: AppColors.primaryDeep,
      onSecondary: const Color(0xFF1A1400),
      surface: palette.surface,
      onSurface: palette.textPrimary,
      error: AppColors.danger,
      onError: Colors.white,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: scheme.brightness,
      scaffoldBackgroundColor: palette.background,
      colorScheme: scheme,
      primaryColor: AppColors.primary,
      canvasColor: palette.background,
      textTheme: AppTextStyles.textTheme(
        primary: palette.textPrimary,
        secondary: palette.textSecondary,
      ),
      iconTheme: IconThemeData(color: palette.textSecondary),
      dividerColor: palette.border,
      extensions: [palette],
      textSelectionTheme: const TextSelectionThemeData(
        cursorColor: AppColors.primary,
        selectionHandleColor: AppColors.primary,
      ),
      textButtonTheme: TextButtonThemeData(
        style: ButtonStyle(
          foregroundColor: WidgetStateProperty.all(palette.textPrimary),
        ),
      ),
      tooltipTheme: TooltipThemeData(
        decoration: BoxDecoration(
          color: palette.surfaceElevated,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: palette.border),
        ),
        textStyle: TextStyle(color: palette.textPrimary, fontSize: 12),
      ),
    );
  }
}

/// `context.textTheme` — mirrors the reference app's ergonomics.
extension TextThemeX on BuildContext {
  TextTheme get textTheme => Theme.of(this).textTheme;
}
