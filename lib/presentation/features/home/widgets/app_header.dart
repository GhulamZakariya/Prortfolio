import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_portfolio/core/utils/constants.dart';
import 'package:my_portfolio/core/utils/globals.dart';
import 'package:my_portfolio/presentation/features/home/bloc/navigation_cubit.dart';
import 'package:my_portfolio/presentation/features/home/bloc/navigation_state.dart';
import 'package:my_portfolio/presentation/features/theme/widgets/theme_toggle.dart';
import 'package:my_portfolio/presentation/resources/resources.dart';
import 'package:my_portfolio/presentation/utils/launcher.dart';
import 'package:my_portfolio/presentation/widgets/brand_logo.dart';
import 'package:my_portfolio/presentation/widgets/hover_builder.dart';

/// Sticky, scroll-aware site header. Transparent over the hero, then a frosted
/// glass bar once the user scrolls. Highlights the active section.
class AppHeader extends StatelessWidget {
  const AppHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    // Use the compact (hamburger) header until there's room for the full nav
    // row, otherwise the seven items + actions overflow on tablet widths.
    final compact = MediaQuery.of(context).size.width < 1200;

    return BlocBuilder<NavigationCubit, NavigationState>(
      buildWhen: (a, b) =>
          a.scrolled != b.scrolled || a.activeSection != b.activeSection,
      builder: (context, state) {
        return ClipRect(
          child: BackdropFilter(
            filter: state.scrolled
                ? ImageFilter.blur(sigmaX: 16, sigmaY: 16)
                : ImageFilter.blur(sigmaX: 0, sigmaY: 0),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              decoration: BoxDecoration(
                color: state.scrolled
                    ? colors.background.withValues(alpha: 0.72)
                    : Colors.transparent,
                border: Border(
                  bottom: BorderSide(
                    color: state.scrolled ? colors.border : Colors.transparent,
                  ),
                ),
              ),
              child: SafeArea(
                bottom: false,
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: compact ? 20 : 40,
                    vertical: 12,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      BrandLogo(
                        onTap: () => context
                            .read<NavigationCubit>()
                            .scrollTo(HomeSection.home),
                      ),
                      if (compact)
                        _MenuButton()
                      else
                        _DesktopNav(active: state.activeSection),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _DesktopNav extends StatelessWidget {
  const _DesktopNav({required this.active});
  final HomeSection active;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        for (final section in HomeSection.values)
          _NavItem(section: section, active: section == active),
        const SizedBox(width: AppDimensions.spaceLg),
        const ThemeToggle(),
        const SizedBox(width: AppDimensions.spaceMd),
        _ResumeButton(),
      ],
    );
  }
}

class _NavItem extends StatelessWidget {
  const _NavItem({required this.section, required this.active});
  final HomeSection section;
  final bool active;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return HoverBuilder(
      onTap: () => context.read<NavigationCubit>().scrollTo(section),
      builder: (context, hovering) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              section.label,
              style: AppTextStyles.body(14, weight: FontWeight.w600).copyWith(
                color: active || hovering
                    ? colors.textPrimary
                    : colors.textSecondary,
              ),
            ),
            4.vertical,
            AnimatedContainer(
              duration: const Duration(milliseconds: 220),
              height: 2,
              width: active ? 18 : 0,
              decoration: BoxDecoration(
                gradient: context.colors.accentGradient,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ResumeButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return HoverBuilder(
      onTap: () => Launcher.open(AppConstants.resumeUrl),
      builder: (context, hovering) => AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
        decoration: BoxDecoration(
          gradient: hovering ? context.colors.accentGradient : null,
          borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
          border: Border.all(color: colors.accent.withValues(alpha: 0.7)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.download_rounded,
                size: 16,
                color: hovering ? context.colors.onPrimary : colors.accent),
            6.horizontal,
            Text(
              'Résumé',
              style: AppTextStyles.body(13.5, weight: FontWeight.w700).copyWith(
                color: hovering ? context.colors.onPrimary : colors.textPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MenuButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Row(
      children: [
        const ThemeToggle(),
        const SizedBox(width: AppDimensions.spaceSm),
        IconButton(
          onPressed: () => Globals.scaffoldKey.currentState?.openEndDrawer(),
          icon: Icon(Icons.menu_rounded, color: colors.textPrimary, size: 28),
          tooltip: 'Open menu',
        ),
      ],
    );
  }
}
