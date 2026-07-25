import 'package:flutter/material.dart';
import 'package:my_portfolio/presentation/resources/resources.dart';
import 'package:my_portfolio/presentation/widgets/hover_builder.dart';

/// Small pill showing a technology's logo + name. Subtle hover highlight.
class TechBadge extends StatelessWidget {
  const TechBadge({
    super.key,
    required this.name,
    this.logoAsset,
    this.compact = false,
  });

  final String name;
  final String? logoAsset;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return HoverBuilder(
      cursor: SystemMouseCursors.basic,
      builder: (context, hovering) => AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: EdgeInsets.symmetric(
          horizontal: compact ? AppDimensions.spaceSm : AppDimensions.spaceMd,
          vertical: compact ? 6 : AppDimensions.spaceXs,
        ),
        decoration: BoxDecoration(
          color: hovering
              ? colors.accent.withValues(alpha: 0.12)
              : colors.surfaceElevated,
          borderRadius: BorderRadius.circular(AppDimensions.radiusPill),
          border: Border.all(
            color: hovering ? colors.accent.withValues(alpha: 0.5) : colors.border,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (logoAsset != null) ...[
              Image.asset(logoAsset!, width: compact ? 14 : 18, height: compact ? 14 : 18),
              const SizedBox(width: AppDimensions.spaceXs),
            ],
            Text(
              name,
              style: AppTextStyles.body(compact ? 11.5 : 13,
                      weight: FontWeight.w600)
                  .copyWith(color: colors.textPrimary),
            ),
          ],
        ),
      ),
    );
  }
}
