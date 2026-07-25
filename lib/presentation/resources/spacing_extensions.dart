import 'package:flutter/widgets.dart';

/// Spacing helpers so widgets never hardcode raw `SizedBox`/`EdgeInsets` values.
///
/// Usage:
///   16.vertical            -> SizedBox(height: 16)
///   24.horizontal          -> SizedBox(width: 24)
///   16.all                 -> EdgeInsets.all(16)
///   24.horizontalPadding   -> EdgeInsets.symmetric(horizontal: 24)
///   16.verticalPadding     -> EdgeInsets.symmetric(vertical: 16)
extension SpacingX on num {
  /// Vertical gap.
  SizedBox get vertical => SizedBox(height: toDouble());

  /// Horizontal gap.
  SizedBox get horizontal => SizedBox(width: toDouble());

  /// Square gap (useful inside `Flex` that switches axis).
  SizedBox get gap => SizedBox(height: toDouble(), width: toDouble());

  EdgeInsets get all => EdgeInsets.all(toDouble());
  EdgeInsets get horizontalPadding =>
      EdgeInsets.symmetric(horizontal: toDouble());
  EdgeInsets get verticalPadding => EdgeInsets.symmetric(vertical: toDouble());

  BorderRadius get radius => BorderRadius.circular(toDouble());
}
