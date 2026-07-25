import 'package:flutter/material.dart';

/// Raw brand palette. Semantic, mode-aware colors live in [AppPalette].
///
/// The signature amber/yellow is preserved from the original design and is the
/// single accent that anchors the whole visual identity.
class AppColors {
  AppColors._();

  // Signature accent (kept from the original portfolio) + a warmer amber for
  // premium gradients.
  static const Color primary = Color(0xFFFFD800);
  static const Color primaryDeep = Color(0xFFFFB300);
  static const Color primarySoft = Color(0xFFFFE566);

  /// Headline / CTA gradient used across buttons, headings and accents.
  static const Gradient accentGradient = LinearGradient(
    colors: [primarySoft, primary, primaryDeep],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // Dark theme surfaces.
  static const Color darkBackground = Color(0xFF060D16);
  static const Color darkSurface = Color(0xFF0C1723);
  static const Color darkSurfaceElevated = Color(0xFF122232);
  static const Color darkTextPrimary = Color(0xFFF4F7FB);
  static const Color darkTextSecondary = Color(0xFFA6B1BB);
  static const Color darkTextMuted = Color(0xFF6C7A88);

  // Light theme surfaces.
  static const Color lightBackground = Color(0xFFF7F9FC);
  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color lightSurfaceElevated = Color(0xFFF0F3F8);
  static const Color lightTextPrimary = Color(0xFF0F1B24);
  static const Color lightTextSecondary = Color(0xFF556575);
  static const Color lightTextMuted = Color(0xFF8A97A4);

  static const Color danger = Color(0xFFF32222);
  static const Color success = Color(0xFF2ECC71);
}

/// Semantic, theme-aware colors. Registered on both [ThemeData]s and read via
/// `Theme.of(context).extension<AppPalette>()` (see `context.colors`).
@immutable
class AppPalette extends ThemeExtension<AppPalette> {
  const AppPalette({
    required this.background,
    required this.surface,
    required this.surfaceElevated,
    required this.textPrimary,
    required this.textSecondary,
    required this.textMuted,
    required this.border,
    required this.glassFill,
    required this.shadow,
    required this.isDark,
  });

  final Color background;
  final Color surface;
  final Color surfaceElevated;
  final Color textPrimary;
  final Color textSecondary;
  final Color textMuted;
  final Color border;
  final Color glassFill;
  final Color shadow;
  final bool isDark;

  /// Brand colors stay constant across modes — exposed via `context.colors.*`
  /// so widgets never reference raw hex or [AppColors] directly.
  Color get primary => AppColors.primary;
  Color get accent => AppColors.primary;
  Color get secondary => AppColors.primaryDeep;

  /// Foreground color to use on top of [primary]/[accentGradient] fills.
  Color get onPrimary => const Color(0xFF1A1400);
  Color get success => AppColors.success;
  Color get danger => AppColors.danger;
  Gradient get accentGradient => AppColors.accentGradient;

  static const AppPalette dark = AppPalette(
    background: AppColors.darkBackground,
    surface: AppColors.darkSurface,
    surfaceElevated: AppColors.darkSurfaceElevated,
    textPrimary: AppColors.darkTextPrimary,
    textSecondary: AppColors.darkTextSecondary,
    textMuted: AppColors.darkTextMuted,
    border: Color(0x1AFFFFFF),
    glassFill: Color(0x0DFFFFFF),
    shadow: Color(0x66000000),
    isDark: true,
  );

  static const AppPalette light = AppPalette(
    background: AppColors.lightBackground,
    surface: AppColors.lightSurface,
    surfaceElevated: AppColors.lightSurfaceElevated,
    textPrimary: AppColors.lightTextPrimary,
    textSecondary: AppColors.lightTextSecondary,
    textMuted: AppColors.lightTextMuted,
    border: Color(0x14101B24),
    glassFill: Color(0xB3FFFFFF),
    shadow: Color(0x1A101B24),
    isDark: false,
  );

  @override
  AppPalette copyWith({
    Color? background,
    Color? surface,
    Color? surfaceElevated,
    Color? textPrimary,
    Color? textSecondary,
    Color? textMuted,
    Color? border,
    Color? glassFill,
    Color? shadow,
    bool? isDark,
  }) {
    return AppPalette(
      background: background ?? this.background,
      surface: surface ?? this.surface,
      surfaceElevated: surfaceElevated ?? this.surfaceElevated,
      textPrimary: textPrimary ?? this.textPrimary,
      textSecondary: textSecondary ?? this.textSecondary,
      textMuted: textMuted ?? this.textMuted,
      border: border ?? this.border,
      glassFill: glassFill ?? this.glassFill,
      shadow: shadow ?? this.shadow,
      isDark: isDark ?? this.isDark,
    );
  }

  @override
  AppPalette lerp(ThemeExtension<AppPalette>? other, double t) {
    if (other is! AppPalette) return this;
    return AppPalette(
      background: Color.lerp(background, other.background, t)!,
      surface: Color.lerp(surface, other.surface, t)!,
      surfaceElevated: Color.lerp(surfaceElevated, other.surfaceElevated, t)!,
      textPrimary: Color.lerp(textPrimary, other.textPrimary, t)!,
      textSecondary: Color.lerp(textSecondary, other.textSecondary, t)!,
      textMuted: Color.lerp(textMuted, other.textMuted, t)!,
      border: Color.lerp(border, other.border, t)!,
      glassFill: Color.lerp(glassFill, other.glassFill, t)!,
      shadow: Color.lerp(shadow, other.shadow, t)!,
      isDark: t < 0.5 ? isDark : other.isDark,
    );
  }
}

/// Ergonomic access to semantic colors: `context.colors.textPrimary`.
extension AppPaletteX on BuildContext {
  AppPalette get colors =>
      Theme.of(this).extension<AppPalette>() ?? AppPalette.dark;
}
