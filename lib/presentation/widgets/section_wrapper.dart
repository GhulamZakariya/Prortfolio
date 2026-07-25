import 'package:flutter/material.dart';
import 'package:my_portfolio/presentation/resources/resources.dart';
import 'package:my_portfolio/presentation/widgets/reveal_on_scroll.dart';

/// Centers content at the design max-width with responsive horizontal padding.
/// Replaces the scattered `ResponsiveWrapper(maxWidth: …)` calls.
class SectionWrapper extends StatelessWidget {
  const SectionWrapper({
    super.key,
    required this.child,
    this.maxWidth = AppDimensions.maxContentWidth,
    this.verticalPadding = AppDimensions.sectionGap,
  });

  final Widget child;
  final double maxWidth;
  final double verticalPadding;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final horizontal = width < AppDimensions.mobileBreakpoint
        ? AppDimensions.spaceLg
        : AppDimensions.spaceXxl;
    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxWidth),
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: horizontal,
            vertical: verticalPadding,
          ),
          child: child,
        ),
      ),
    );
  }
}

/// Eyebrow + title (+ optional subtitle) used to open each section.
class SectionHeading extends StatelessWidget {
  const SectionHeading({
    super.key,
    required this.eyebrow,
    required this.title,
    this.subtitle,
    this.center = false,
  });

  final String eyebrow;
  final String title;
  final String? subtitle;
  final bool center;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final align =
        center ? CrossAxisAlignment.center : CrossAxisAlignment.start;
    final textAlign = center ? TextAlign.center : TextAlign.start;
    final isMobile =
        MediaQuery.of(context).size.width < AppDimensions.mobileBreakpoint;

    return Column(
      crossAxisAlignment: align,
      children: [
        RevealOnScroll(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 28,
                height: 3,
                decoration: BoxDecoration(
                  gradient: context.colors.accentGradient,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(width: AppDimensions.spaceXs),
              Text(
                eyebrow.toUpperCase(),
                style: AppTextStyles.eyebrow().copyWith(color: colors.accent),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppDimensions.spaceMd),
        RevealOnScroll(
          delay: const Duration(milliseconds: 80),
          child: Text(
            title,
            textAlign: textAlign,
            style: AppTextStyles.heading(isMobile ? 32 : 44)
                .copyWith(color: colors.textPrimary),
          ),
        ),
        if (subtitle != null) ...[
          const SizedBox(height: AppDimensions.spaceSm),
          RevealOnScroll(
            delay: const Duration(milliseconds: 140),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 560),
              child: Text(
                subtitle!,
                textAlign: textAlign,
                style: context.textTheme.bodyMedium
                    ?.copyWith(color: colors.textSecondary),
              ),
            ),
          ),
        ],
      ],
    );
  }
}
