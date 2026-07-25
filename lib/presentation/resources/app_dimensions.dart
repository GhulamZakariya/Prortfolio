import 'package:flutter/material.dart';

/// Centralized spacing, radii, breakpoints and layout widths.
/// No magic numbers in widgets — everything references this scale.
class AppDimensions {
  AppDimensions._();

  // Spacing scale (4pt base).
  static const double spaceXxs = 4;
  static const double spaceXs = 8;
  static const double spaceSm = 12;
  static const double spaceMd = 16;
  static const double spaceLg = 24;
  static const double spaceXl = 32;
  static const double spaceXxl = 48;
  static const double spaceHuge = 72;
  static const double sectionGap = 96;

  // Corner radii.
  static const double radiusSm = 8;
  static const double radiusMd = 14;
  static const double radiusLg = 20;
  static const double radiusXl = 28;
  static const double radiusPill = 999;

  // Content max-widths per breakpoint.
  static const double maxContentWidth = 1140;
  static const double tabletContentWidth = 760;
  static double mobileContentWidth(BuildContext context) =>
      MediaQuery.of(context).size.width * .86;

  // Breakpoints (aligned with ScreenHelper).
  static const double mobileBreakpoint = 800;
  static const double desktopBreakpoint = 1200;

  // Common gaps as SizedBoxes.
  static const SizedBox gapXs = SizedBox(height: spaceXs, width: spaceXs);
  static const SizedBox gapSm = SizedBox(height: spaceSm, width: spaceSm);
  static const SizedBox gapMd = SizedBox(height: spaceMd, width: spaceMd);
  static const SizedBox gapLg = SizedBox(height: spaceLg, width: spaceLg);
  static const SizedBox gapXl = SizedBox(height: spaceXl, width: spaceXl);
}
