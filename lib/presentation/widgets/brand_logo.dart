import 'package:flutter/material.dart';
import 'package:my_portfolio/presentation/resources/resources.dart';
import 'package:my_portfolio/presentation/widgets/hover_builder.dart';

/// The single source of truth for the personal brand lockup: a "GZ" monogram
/// tile + the "Ghulam Zakariya" wordmark (surname in accent). Replaces the old
/// "Ghulam.dev" mark. Reused across the header, drawer and footer.
class BrandLogo extends StatelessWidget {
  const BrandLogo({
    super.key,
    this.onTap,
    this.monogramSize = 38,
    this.fontSize = 20,
    this.showWordmark = true,
    this.glowOnHover = true,
  });

  final VoidCallback? onTap;
  final double monogramSize;
  final double fontSize;
  final bool showWordmark;
  final bool glowOnHover;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return HoverBuilder(
      onTap: onTap,
      cursor: onTap == null ? SystemMouseCursors.basic : SystemMouseCursors.click,
      builder: (context, hovering) => Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: monogramSize,
            height: monogramSize,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              gradient: colors.accentGradient,
              borderRadius: (monogramSize * 0.29).radius,
              boxShadow: (glowOnHover && hovering)
                  ? [
                      BoxShadow(
                        color: colors.accent.withValues(alpha: 0.5),
                        blurRadius: 18,
                      ),
                    ]
                  : null,
            ),
            child: Text(
              'GZ',
              style: AppTextStyles.heading(monogramSize * 0.42)
                  .copyWith(color: colors.onPrimary),
            ),
          ),
          if (showWordmark) ...[
            12.horizontal,
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: 'Ghulam ',
                    style: AppTextStyles.heading(fontSize)
                        .copyWith(color: colors.textPrimary),
                  ),
                  TextSpan(
                    text: 'Zakariya',
                    style: AppTextStyles.heading(fontSize)
                        .copyWith(color: colors.accent),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}
