import 'package:flutter/material.dart';
import 'package:my_portfolio/domain/entities/social_link.dart';
import 'package:my_portfolio/presentation/resources/resources.dart';
import 'package:my_portfolio/presentation/utils/launcher.dart';
import 'package:my_portfolio/presentation/utils/social_presentation.dart';
import 'package:my_portfolio/presentation/widgets/hover_builder.dart';

/// Row of circular social icon buttons with a hover highlight.
class SocialRow extends StatelessWidget {
  const SocialRow({
    super.key,
    required this.links,
    this.size = 42,
    this.alignment = MainAxisAlignment.start,
  });

  final List<SocialLink> links;
  final double size;
  final MainAxisAlignment alignment;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: alignment,
      children: [
        for (final link in links)
          Padding(
            padding: const EdgeInsets.only(right: AppDimensions.spaceSm),
            child: _SocialIconButton(link: link, size: size),
          ),
      ],
    );
  }
}

class _SocialIconButton extends StatelessWidget {
  const _SocialIconButton({required this.link, required this.size});
  final SocialLink link;
  final double size;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Tooltip(
      message: socialTitle(link.kind),
      child: HoverBuilder(
        onTap: () => Launcher.open(link.url),
        builder: (context, hovering) => AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: size,
          height: size,
          transform: Matrix4.translationValues(0, hovering ? -4 : 0, 0),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: hovering ? context.colors.accentGradient : null,
            color: hovering ? null : colors.surfaceElevated,
            border: Border.all(
              color: hovering ? Colors.transparent : colors.border,
            ),
          ),
          child: Icon(
            socialIcon(link.kind),
            size: size * 0.42,
            color: hovering ? context.colors.onPrimary : colors.textSecondary,
          ),
        ),
      ),
    );
  }
}
