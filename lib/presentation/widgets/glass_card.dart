import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:my_portfolio/presentation/resources/resources.dart';
import 'package:my_portfolio/presentation/widgets/hover_builder.dart';

/// Frosted-glass surface: translucent fill, subtle border and backdrop blur.
/// Optionally lifts and glows on hover — the base of every card in the site.
class GlassCard extends StatelessWidget {
  const GlassCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(AppDimensions.spaceLg),
    this.radius = AppDimensions.radiusLg,
    this.hoverLift = false,
    this.onTap,
    this.blur = 14,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final double radius;
  final bool hoverLift;
  final VoidCallback? onTap;
  final double blur;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final borderRadius = BorderRadius.circular(radius);

    Widget surface(bool hovering) {
      return AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeOut,
        transform: Matrix4.translationValues(0, hovering ? -6 : 0, 0),
        decoration: BoxDecoration(
          borderRadius: borderRadius,
          color: colors.glassFill,
          border: Border.all(
            color: hovering
                ? colors.accent.withValues(alpha: 0.55)
                : colors.border,
          ),
          boxShadow: [
            BoxShadow(
              color: hovering
                  ? colors.accent.withValues(alpha: 0.18)
                  : colors.shadow,
              blurRadius: hovering ? 34 : 18,
              offset: Offset(0, hovering ? 16 : 8),
            ),
          ],
        ),
        child: Padding(padding: padding, child: child),
      );
    }

    final content = ClipRRect(
      borderRadius: borderRadius,
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
        child: hoverLift || onTap != null
            ? HoverBuilder(
                onTap: onTap,
                cursor: onTap != null
                    ? SystemMouseCursors.click
                    : SystemMouseCursors.basic,
                builder: (context, hovering) => surface(hoverLift && hovering),
              )
            : surface(false),
      ),
    );

    return content;
  }
}
