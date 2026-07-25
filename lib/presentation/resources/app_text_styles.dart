import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Typography system.
///
/// - Headings/display keep the brand's **Josefin Sans** (unchanged identity).
/// - Body copy moves to **Inter** for better on-screen readability at small
///   sizes — a premium, neutral companion to the geometric display face.
///
/// Colors are intentionally omitted here; they are applied by [AppTheme] /
/// `context.textTheme` so the same styles work in light and dark modes.
class AppTextStyles {
  AppTextStyles._();

  static TextStyle heading(double size, {FontWeight weight = FontWeight.w900}) =>
      GoogleFonts.josefinSans(
        fontSize: size,
        fontWeight: weight,
        height: 1.15,
        letterSpacing: 0.2,
      );

  static TextStyle body(double size, {FontWeight weight = FontWeight.w400}) =>
      GoogleFonts.inter(
        fontSize: size,
        fontWeight: weight,
        height: 1.6,
      );

  static TextStyle mono(double size, {FontWeight weight = FontWeight.w500}) =>
      GoogleFonts.jetBrainsMono(fontSize: size, fontWeight: weight);

  /// Small uppercased label used above section titles ("eyebrow").
  static TextStyle eyebrow() => GoogleFonts.josefinSans(
        fontSize: 14,
        fontWeight: FontWeight.w800,
        letterSpacing: 3,
      );

  /// The full [TextTheme], colored for the given palette, injected into
  /// [ThemeData] so `context.textTheme.titleLarge` etc. work everywhere.
  static TextTheme textTheme({
    required Color primary,
    required Color secondary,
  }) {
    final josefin = GoogleFonts.josefinSansTextTheme();
    final inter = GoogleFonts.interTextTheme();
    return TextTheme(
      displayLarge: josefin.displayLarge
          ?.copyWith(color: primary, fontWeight: FontWeight.w900, height: 1.1),
      displayMedium: josefin.displayMedium
          ?.copyWith(color: primary, fontWeight: FontWeight.w900, height: 1.15),
      headlineLarge: josefin.headlineLarge
          ?.copyWith(color: primary, fontWeight: FontWeight.w900),
      headlineMedium: josefin.headlineMedium
          ?.copyWith(color: primary, fontWeight: FontWeight.w800),
      headlineSmall: josefin.headlineSmall
          ?.copyWith(color: primary, fontWeight: FontWeight.w800),
      titleLarge: josefin.titleLarge
          ?.copyWith(color: primary, fontWeight: FontWeight.w700),
      titleMedium: josefin.titleMedium
          ?.copyWith(color: primary, fontWeight: FontWeight.w700),
      titleSmall: josefin.titleSmall
          ?.copyWith(color: primary, fontWeight: FontWeight.w600),
      bodyLarge: inter.bodyLarge?.copyWith(color: secondary, height: 1.6),
      bodyMedium: inter.bodyMedium?.copyWith(color: secondary, height: 1.6),
      bodySmall: inter.bodySmall?.copyWith(color: secondary, height: 1.5),
      labelLarge: inter.labelLarge
          ?.copyWith(color: primary, fontWeight: FontWeight.w600),
    );
  }
}
