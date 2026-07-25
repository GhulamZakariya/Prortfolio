import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:my_portfolio/core/utils/constants.dart';
import 'package:my_portfolio/domain/entities/social_link.dart';
import 'package:my_portfolio/injection/injector.dart';
import 'package:my_portfolio/domain/use_cases/get_portfolio_content_use_cases.dart';
import 'package:my_portfolio/presentation/features/home/bloc/navigation_cubit.dart';
import 'package:my_portfolio/presentation/features/home/bloc/navigation_state.dart';
import 'package:my_portfolio/core/utils/screen_helper.dart';
import 'package:my_portfolio/presentation/resources/resources.dart';
import 'package:my_portfolio/presentation/utils/launcher.dart';
import 'package:my_portfolio/presentation/widgets/app_button.dart';
import 'package:my_portfolio/presentation/widgets/reveal_on_scroll.dart';
import 'package:my_portfolio/presentation/widgets/social_row.dart';

class HeroSection extends StatelessWidget {
  const HeroSection({super.key});

  static const _profileKinds = {
    SocialKind.email,
    SocialKind.linkedin,
    SocialKind.github,
    SocialKind.instagram,
    SocialKind.fiverr,
  };

  @override
  Widget build(BuildContext context) {
    final isMobile = ScreenHelper.isMobile(context);
    final size = MediaQuery.of(context).size;
    final socials = injector<GetSocialLinksUseCase>()
        .run()
        .where((s) => _profileKinds.contains(s.kind))
        .toList();

    final content = Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: AppDimensions.maxContentWidth),
        child: Padding(
          padding: EdgeInsets.fromLTRB(
            isMobile ? 20 : 40,
            isMobile ? 120 : 130,
            isMobile ? 20 : 40,
            AppDimensions.spaceXxl,
          ),
          child: isMobile
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Center(child: _FloatingAvatar(size: 240)),
                    const SizedBox(height: AppDimensions.spaceXl),
                    _HeroText(socials: socials, isMobile: true),
                  ],
                )
              : Row(
                  children: [
                    Expanded(
                      flex: 6,
                      child: _HeroText(socials: socials, isMobile: false),
                    ),
                    const SizedBox(width: AppDimensions.spaceXl),
                    const Expanded(flex: 5, child: _FloatingAvatar(size: 380)),
                  ],
                ),
        ),
      ),
    );

    return ConstrainedBox(
      constraints: BoxConstraints(minHeight: size.height * (isMobile ? 0.9 : 0.96)),
      child: content,
    );
  }
}

class _HeroText extends StatelessWidget {
  const _HeroText({required this.socials, required this.isMobile});
  final List<SocialLink> socials;
  final bool isMobile;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const RevealOnScroll(child: _AvailabilityBadge()),
        const SizedBox(height: AppDimensions.spaceLg),
        RevealOnScroll(
          delay: const Duration(milliseconds: 80),
          child: Text(
            'MOBILE APPLICATION DEVELOPER',
            style: AppTextStyles.eyebrow().copyWith(color: colors.accent),
          ),
        ),
        const SizedBox(height: AppDimensions.spaceMd),
        RevealOnScroll(
          delay: const Duration(milliseconds: 140),
          child: RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: 'Ghulam\n',
                  style: AppTextStyles.heading(isMobile ? 44 : 68)
                      .copyWith(color: colors.textPrimary, height: 1.05),
                ),
                TextSpan(
                  text: 'Zakariya',
                  style: AppTextStyles.heading(isMobile ? 44 : 68).copyWith(
                    height: 1.05,
                    foreground: Paint()
                      ..shader = context.colors.accentGradient.createShader(
                        const Rect.fromLTWH(0, 0, 380, 80),
                      ),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: AppDimensions.spaceMd),
        RevealOnScroll(
          delay: const Duration(milliseconds: 200),
          child: Row(
            children: [
              Text('Software Engineer',
                  style: AppTextStyles.body(16, weight: FontWeight.w600)
                      .copyWith(color: colors.textPrimary)),
              const SizedBox(width: AppDimensions.spaceMd),
              Icon(Icons.location_on, size: 15, color: colors.accent),
              4.horizontal,
              Text('Lahore, Pakistan',
                  style: context.textTheme.bodyMedium
                      ?.copyWith(color: colors.textSecondary)),
            ],
          ),
        ),
        const SizedBox(height: AppDimensions.spaceMd),
        RevealOnScroll(
          delay: const Duration(milliseconds: 260),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 480),
            child: Text(
              'I craft fast, elegant cross-platform apps with Flutter — from '
              'idea to the App Store. 3+ years shipping production apps for '
              'global brands like Pizza Hut, KFC and Domino’s.',
              style: context.textTheme.bodyLarge
                  ?.copyWith(color: colors.textSecondary),
            ),
          ),
        ),
        const SizedBox(height: AppDimensions.spaceXl),
        RevealOnScroll(
          delay: const Duration(milliseconds: 320),
          child: Wrap(
            spacing: AppDimensions.spaceMd,
            runSpacing: AppDimensions.spaceSm,
            children: [
              AppButton(
                label: "Let's Talk",
                icon: Icons.arrow_forward_rounded,
                onPressed: () =>
                    context.read<NavigationCubit>().scrollTo(HomeSection.contact),
              ),
              AppButton(
                label: 'Download CV',
                icon: Icons.download_rounded,
                variant: AppButtonVariant.outline,
                onPressed: () => Launcher.open(AppConstants.resumeUrl),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppDimensions.spaceXl),
        RevealOnScroll(
          delay: const Duration(milliseconds: 380),
          child: SocialRow(links: socials),
        ),
      ],
    );
  }
}

class _AvailabilityBadge extends StatelessWidget {
  const _AvailabilityBadge();

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: colors.surfaceElevated,
        borderRadius: BorderRadius.circular(AppDimensions.radiusPill),
        border: Border.all(color: colors.border),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const _PulsingDot(),
          const SizedBox(width: AppDimensions.spaceXs),
          Text(
            'Available for freelance & full-time',
            style: AppTextStyles.body(12.5, weight: FontWeight.w600)
                .copyWith(color: colors.textSecondary),
          ),
        ],
      ),
    );
  }
}

class _PulsingDot extends StatefulWidget {
  const _PulsingDot();
  @override
  State<_PulsingDot> createState() => _PulsingDotState();
}

class _PulsingDotState extends State<_PulsingDot>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1400),
  )..repeat(reverse: true);

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _c,
      builder: (context, _) => Container(
        width: 9,
        height: 9,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: context.colors.success,
          boxShadow: [
            BoxShadow(
              color: context.colors.success.withValues(alpha: 0.6 * _c.value),
              blurRadius: 8 * _c.value + 2,
              spreadRadius: 2 * _c.value,
            ),
          ],
        ),
      ),
    );
  }
}

/// The hero illustration: a gentle vertical bob, a glowing ring behind it and a
/// subtle mouse-parallax tilt.
class _FloatingAvatar extends StatefulWidget {
  const _FloatingAvatar({required this.size});
  final double size;

  @override
  State<_FloatingAvatar> createState() => _FloatingAvatarState();
}

class _FloatingAvatarState extends State<_FloatingAvatar>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 5),
  )..repeat(reverse: true);

  final ValueNotifier<Offset> _parallax = ValueNotifier<Offset>(Offset.zero);

  void _onHover(PointerEvent e, Size size) {
    final dx = (e.localPosition.dx / size.width - 0.5);
    final dy = (e.localPosition.dy / size.height - 0.5);
    _parallax.value = Offset(dx, dy);
  }

  @override
  void dispose() {
    _c.dispose();
    _parallax.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onHover: (e) => _onHover(e, Size(widget.size, widget.size)),
      onExit: (_) => _parallax.value = Offset.zero,
      child: AnimatedBuilder(
        animation: Listenable.merge([_c, _parallax]),
        builder: (context, child) {
          final parallax = _parallax.value;
          final bob = math.sin(_c.value * 2 * math.pi) * 10;
          return Transform(
            alignment: Alignment.center,
            transform: Matrix4.identity()
              ..setEntry(3, 2, 0.001)
              ..translateByDouble(
                  parallax.dx * 18, bob + parallax.dy * 18, 0.0, 1.0)
              ..rotateY(parallax.dx * 0.12)
              ..rotateX(-parallax.dy * 0.12),
            child: child,
          );
        },
        child: _PortraitFrame(size: widget.size),
      ),
    );
  }
}

/// The hero visual: a premium framed portrait (AI portrait when present at
/// [AppConstants.profileImage]) with a gradient ring, glow and a dark-theme
/// bottom blend. Falls back to the illustration until the portrait is added.
class _PortraitFrame extends StatelessWidget {
  const _PortraitFrame({required this.size});
  final double size;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final w = size * 0.84;
    final h = size * 1.04;

    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.center,
      children: [
        // Ambient glow.
        Container(
          width: w * 1.2,
          height: w * 1.2,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: RadialGradient(
              colors: [
                colors.accent.withValues(alpha: 0.28),
                colors.accent.withValues(alpha: 0),
              ],
            ),
          ),
        ),
        // Gradient ring + portrait.
        Container(
          padding: const EdgeInsets.all(3),
          decoration: BoxDecoration(
            gradient: colors.accentGradient,
            borderRadius: 28.radius,
            boxShadow: [
              BoxShadow(
                color: colors.accent.withValues(alpha: 0.32),
                blurRadius: 44,
                offset: const Offset(0, 18),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: 25.radius,
            child: SizedBox(
              width: w,
              height: h,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Image.asset(
                    AppConstants.profileImage,
                    fit: BoxFit.cover,
                    alignment: Alignment.topCenter,
                    semanticLabel: 'Portrait of Ghulam Zakariya',
                    errorBuilder: (context, _, __) => ColoredBox(
                      color: colors.surface,
                      child: SvgPicture.asset(
                        AppConstants.guySvg,
                        fit: BoxFit.contain,
                        semanticsLabel: 'Illustration of Ghulam Zakariya',
                      ),
                    ),
                  ),
                  // Blend the bottom into the dark theme.
                  DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.center,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          colors.background.withValues(alpha: 0.45),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
