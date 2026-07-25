import 'package:flutter/material.dart';
import 'package:my_portfolio/presentation/resources/resources.dart';
import 'package:my_portfolio/presentation/widgets/hover_builder.dart';

enum AppButtonVariant { primary, outline }

/// Premium button with a gradient (or outline) fill, an optional leading icon,
/// a hover micro-interaction (lift + glow) and a loading state.
class AppButton extends StatelessWidget {
  const AppButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.variant = AppButtonVariant.primary,
    this.loading = false,
    this.expand = false,
  });

  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final AppButtonVariant variant;
  final bool loading;
  final bool expand;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final isPrimary = variant == AppButtonVariant.primary;
    final enabled = onPressed != null && !loading;

    return HoverBuilder(
      onTap: enabled ? onPressed : null,
      cursor: enabled ? SystemMouseCursors.click : SystemMouseCursors.basic,
      builder: (context, hovering) {
        final hover = hovering && enabled;
        final foreground = isPrimary
            ? context.colors.onPrimary
            : (hover ? context.colors.onPrimary : colors.textPrimary);

        return AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
          transform: Matrix4.translationValues(0, hover ? -3 : 0, 0),
          height: 52,
          width: expand ? double.infinity : null,
          padding: const EdgeInsets.symmetric(horizontal: AppDimensions.spaceXl),
          decoration: BoxDecoration(
            gradient: isPrimary || hover ? context.colors.accentGradient : null,
            borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
            border: isPrimary
                ? null
                : Border.all(color: colors.accent.withValues(alpha: 0.7)),
            boxShadow: (isPrimary || hover)
                ? [
                    BoxShadow(
                      color: colors.accent.withValues(alpha: hover ? 0.45 : 0.28),
                      blurRadius: hover ? 28 : 16,
                      offset: const Offset(0, 8),
                    ),
                  ]
                : null,
          ),
          child: Row(
            mainAxisSize: expand ? MainAxisSize.max : MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (loading)
                SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation(foreground),
                  ),
                )
              else ...[
                if (icon != null) ...[
                  Icon(icon, size: 18, color: foreground),
                  const SizedBox(width: AppDimensions.spaceXs),
                ],
                Text(
                  label,
                  style: AppTextStyles.body(14, weight: FontWeight.w700)
                      .copyWith(color: foreground),
                ),
              ],
            ],
          ),
        );
      },
    );
  }
}
