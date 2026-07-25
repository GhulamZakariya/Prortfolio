import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:my_portfolio/core/utils/constants.dart';
import 'package:my_portfolio/domain/entities/project_entity.dart';
import 'package:my_portfolio/presentation/resources/resources.dart';
import 'package:my_portfolio/presentation/utils/launcher.dart';
import 'package:my_portfolio/presentation/widgets/hover_builder.dart';
import 'package:my_portfolio/presentation/widgets/tech_badge.dart';

/// Parses an optional `#RRGGBB` string into a [Color], falling back to [fallback].
Color parseBrandHex(String? hex, Color fallback) {
  if (hex == null || hex.isEmpty) return fallback;
  var value = hex.replaceFirst('#', '');
  if (value.length == 6) value = 'FF$value';
  final parsed = int.tryParse(value, radix: 16);
  return parsed == null ? fallback : Color(parsed);
}

/// A premium project card: screenshot with hover zoom, category pill, tech
/// badges and live/store/code action chips.
class ProjectCard extends StatelessWidget {
  const ProjectCard({super.key, required this.project});
  final ProjectEntity project;

  bool get _isPlaceholder => project.imageAsset == AppConstants.flutterImage;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return HoverBuilder(
      cursor: SystemMouseCursors.basic,
      builder: (context, hovering) => AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeOut,
        transform: Matrix4.translationValues(0, hovering ? -8 : 0, 0),
        decoration: BoxDecoration(
          color: colors.surface,
          borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
          border: Border.all(
            color: hovering ? colors.accent.withValues(alpha: 0.5) : colors.border,
          ),
          boxShadow: [
            BoxShadow(
              color: hovering
                  ? colors.accent.withValues(alpha: 0.16)
                  : colors.shadow,
              blurRadius: hovering ? 34 : 16,
              offset: Offset(0, hovering ? 16 : 8),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _Cover(project: project, hovering: hovering, placeholder: _isPlaceholder),
            Padding(
              padding: const EdgeInsets.all(AppDimensions.spaceLg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(project.tagline.toUpperCase(),
                      style: AppTextStyles.eyebrow()
                          .copyWith(color: colors.accent, fontSize: 11)),
                  6.vertical,
                  Text(project.name,
                      style: AppTextStyles.heading(20)
                          .copyWith(color: colors.textPrimary)),
                  const SizedBox(height: AppDimensions.spaceXs),
                  Text(
                    project.description,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: context.textTheme.bodyMedium
                        ?.copyWith(color: colors.textSecondary),
                  ),
                  const SizedBox(height: AppDimensions.spaceMd),
                  Wrap(
                    spacing: 6,
                    runSpacing: 6,
                    children: [
                      for (final tech in project.technologies)
                        TechBadge(
                            name: tech.name,
                            logoAsset: tech.logoAsset,
                            compact: true),
                    ],
                  ),
                  const SizedBox(height: AppDimensions.spaceMd),
                  _Actions(project: project),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Cover extends StatelessWidget {
  const _Cover({
    required this.project,
    required this.hovering,
    required this.placeholder,
  });
  final ProjectEntity project;
  final bool hovering;
  final bool placeholder;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return ClipRRect(
      borderRadius: const BorderRadius.vertical(
          top: Radius.circular(AppDimensions.radiusLg)),
      child: SizedBox(
        height: 190,
        width: double.infinity,
        child: Stack(
          fit: StackFit.expand,
          children: [
            if (project.iconAsset != null)
              _IconCover(project: project, hovering: hovering)
            else if (project.imageAsset == null || placeholder)
              _PlaceholderCover(project: project)
            else
              AnimatedScale(
                scale: hovering ? 1.06 : 1,
                duration: const Duration(milliseconds: 350),
                curve: Curves.easeOut,
                child: Image.asset(
                  project.imageAsset!,
                  fit: BoxFit.cover,
                  alignment: Alignment.topCenter,
                ),
              ),
            // Legibility gradient (only over real screenshots).
            if (project.iconAsset == null &&
                project.imageAsset != null &&
                !placeholder)
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      colors.surface.withValues(alpha: 0.35),
                    ],
                  ),
                ),
              ),
            Positioned(
              top: AppDimensions.spaceSm,
              left: AppDimensions.spaceSm,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: colors.background.withValues(alpha: 0.7),
                  borderRadius:
                      BorderRadius.circular(AppDimensions.radiusPill),
                  border: Border.all(color: colors.border),
                ),
                child: Text(project.category.label,
                    style: AppTextStyles.body(11, weight: FontWeight.w600)
                        .copyWith(color: colors.textPrimary)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// App-icon cover: the official app logo shown as a padded, rounded tile on a
/// brand-colored gradient — clean, premium, App-Store-style presentation.
class _IconCover extends StatelessWidget {
  const _IconCover({required this.project, required this.hovering});
  final ProjectEntity project;
  final bool hovering;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final brand = parseBrandHex(project.brandHex, colors.accent);
    return Container(
      decoration: BoxDecoration(
        gradient: RadialGradient(
          center: const Alignment(0, -0.15),
          radius: 1.0,
          colors: [
            brand.withValues(alpha: 0.55),
            Color.lerp(brand, Colors.black, 0.6)!,
          ],
        ),
      ),
      alignment: Alignment.center,
      child: AnimatedScale(
        scale: hovering ? 1.05 : 1,
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeOut,
        child: Container(
          width: 96,
          height: 96,
          decoration: BoxDecoration(
            borderRadius: 22.radius,
            border: Border.all(color: Colors.white.withValues(alpha: 0.18)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.35),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: 22.radius,
            child: Image.asset(project.iconAsset!, fit: BoxFit.cover),
          ),
        ),
      ),
    );
  }
}

class _PlaceholderCover extends StatelessWidget {
  const _PlaceholderCover({required this.project});
  final ProjectEntity project;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            colors.accent.withValues(alpha: 0.18),
            colors.surfaceElevated,
          ],
        ),
      ),
      alignment: Alignment.center,
      child: project.imageAsset != null
          ? Image.asset(project.imageAsset!, width: 64, height: 64)
          : Icon(Icons.apps_rounded, size: 56, color: colors.accent),
    );
  }
}

class _Actions extends StatelessWidget {
  const _Actions({required this.project});
  final ProjectEntity project;

  @override
  Widget build(BuildContext context) {
    final chips = <Widget>[];

    if (project.internalRoute && project.liveUrl.isNotEmpty) {
      chips.add(_LinkChip(
        icon: Icons.open_in_new_rounded,
        label: 'Live Demo',
        primary: true,
        onTap: () => context.goNamed(project.liveUrl),
      ));
    } else if (project.liveUrl.isNotEmpty) {
      chips.add(_LinkChip(
        icon: Icons.open_in_new_rounded,
        label: 'Live Demo',
        primary: true,
        onTap: () => Launcher.open(project.liveUrl),
      ));
    }
    if (project.googlePlayUrl.isNotEmpty) {
      chips.add(_LinkChip(
        faIcon: FontAwesomeIcons.googlePlay,
        label: 'Play Store',
        primary: chips.isEmpty,
        onTap: () => Launcher.open(project.googlePlayUrl),
      ));
    }
    if (project.appStoreUrl.isNotEmpty) {
      chips.add(_LinkChip(
        faIcon: FontAwesomeIcons.appStoreIos,
        label: 'App Store',
        onTap: () => Launcher.open(project.appStoreUrl),
      ));
    }
    if (project.githubUrl.isNotEmpty) {
      chips.add(_LinkChip(
        faIcon: FontAwesomeIcons.github,
        label: 'Code',
        onTap: () => Launcher.open(project.githubUrl),
      ));
    }

    if (chips.isEmpty) {
      return Text(
        'Private / enterprise project',
        style: AppTextStyles.body(12.5, weight: FontWeight.w500)
            .copyWith(color: context.colors.textMuted),
      );
    }

    return Wrap(spacing: 8, runSpacing: 8, children: chips);
  }
}

class _LinkChip extends StatelessWidget {
  const _LinkChip({
    this.icon,
    this.faIcon,
    required this.label,
    required this.onTap,
    this.primary = false,
  });
  final IconData? icon;
  final IconData? faIcon;
  final String label;
  final VoidCallback onTap;
  final bool primary;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return HoverBuilder(
      onTap: onTap,
      builder: (context, hovering) {
        final active = primary || hovering;
        final fg = active ? context.colors.onPrimary : colors.textPrimary;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            gradient: active ? context.colors.accentGradient : null,
            color: active ? null : colors.surfaceElevated,
            borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
            border: Border.all(
                color: active ? Colors.transparent : colors.border),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (faIcon != null)
                FaIcon(faIcon, size: 13, color: fg)
              else if (icon != null)
                Icon(icon, size: 15, color: fg),
              6.horizontal,
              Text(label,
                  style: AppTextStyles.body(12.5, weight: FontWeight.w600)
                      .copyWith(color: fg)),
            ],
          ),
        );
      },
    );
  }
}
