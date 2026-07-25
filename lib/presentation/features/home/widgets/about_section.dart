import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:my_portfolio/core/utils/constants.dart';
import 'package:my_portfolio/core/utils/screen_helper.dart';
import 'package:my_portfolio/domain/use_cases/get_portfolio_content_use_cases.dart';
import 'package:my_portfolio/injection/injector.dart';
import 'package:my_portfolio/presentation/resources/resources.dart';
import 'package:my_portfolio/presentation/utils/launcher.dart';
import 'package:my_portfolio/presentation/widgets/app_button.dart';
import 'package:my_portfolio/presentation/widgets/glass_card.dart';
import 'package:my_portfolio/presentation/widgets/reveal_on_scroll.dart';
import 'package:my_portfolio/presentation/widgets/section_wrapper.dart';
import 'package:my_portfolio/presentation/widgets/tech_badge.dart';

class AboutSection extends StatelessWidget {
  const AboutSection({super.key});

  @override
  Widget build(BuildContext context) {
    final isMobile = ScreenHelper.isMobile(context);
    final years = DateTime.now().year - 2021;

    return SectionWrapper(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionHeading(
            eyebrow: 'About',
            title: 'A bit about me',
          ),
          const SizedBox(height: AppDimensions.spaceXxl),
          if (isMobile)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _Bio(years: years),
                const SizedBox(height: AppDimensions.spaceXl),
                RevealOnScroll(
                  delay: const Duration(milliseconds: 120),
                  child: _ProfileCard(years: years),
                ),
              ],
            )
          else
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(flex: 6, child: _Bio(years: years)),
                const SizedBox(width: AppDimensions.spaceXxl),
                Expanded(
                  flex: 5,
                  child: RevealOnScroll(
                    delay: const Duration(milliseconds: 120),
                    child: _ProfileCard(years: years),
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }
}

class _Bio extends StatelessWidget {
  const _Bio({required this.years});
  final int years;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final tech = injector<GetTechStackUseCase>().run();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RevealOnScroll(
          child: Text(
            "I'm Ghulam Zakariya, a Flutter Developer.",
            style: AppTextStyles.heading(24).copyWith(color: colors.textPrimary),
          ),
        ),
        const SizedBox(height: AppDimensions.spaceMd),
        RevealOnScroll(
          delay: const Duration(milliseconds: 60),
          child: Text(
            'I graduated in Software Engineering from COMSATS University '
            'Islamabad (Sahiwal Campus) in 2021, and I have spent the last '
            '$years+ years building mobile apps — both solo and in teams — and '
            'shipping them to the Play Store and App Store.',
            style: context.textTheme.bodyLarge
                ?.copyWith(color: colors.textSecondary),
          ),
        ),
        const SizedBox(height: AppDimensions.spaceMd),
        RevealOnScroll(
          delay: const Duration(milliseconds: 120),
          child: Text(
            'I love learning new technologies and thrive in environments built '
            'on growth and excellence — where I can deliver polished products '
            'and keep raising the bar.',
            style: context.textTheme.bodyLarge
                ?.copyWith(color: colors.textSecondary),
          ),
        ),
        const SizedBox(height: AppDimensions.spaceXl),
        RevealOnScroll(
          delay: const Duration(milliseconds: 160),
          child: Text(
            'Technologies I work with',
            style: AppTextStyles.body(14, weight: FontWeight.w700)
                .copyWith(color: colors.textPrimary),
          ),
        ),
        const SizedBox(height: AppDimensions.spaceSm),
        RevealOnScroll(
          delay: const Duration(milliseconds: 200),
          child: Wrap(
            spacing: AppDimensions.spaceSm,
            runSpacing: AppDimensions.spaceSm,
            children: [
              for (final t in tech)
                TechBadge(name: t.name, logoAsset: t.logoAsset),
            ],
          ),
        ),
        const SizedBox(height: AppDimensions.spaceXl),
        RevealOnScroll(
          delay: const Duration(milliseconds: 240),
          child: AppButton(
            label: 'Download CV',
            icon: Icons.download_rounded,
            onPressed: () => Launcher.open(AppConstants.resumeUrl),
          ),
        ),
      ],
    );
  }
}

class _ProfileCard extends StatelessWidget {
  const _ProfileCard({required this.years});
  final int years;

  @override
  Widget build(BuildContext context) {
    final facts = <(IconData, String, String)>[
      (Icons.person_outline_rounded, 'Name', 'Ghulam Zakariya'),
      (Icons.location_on_outlined, 'Based in', 'Lahore, Pakistan'),
      (Icons.work_outline_rounded, 'Experience', '$years+ years'),
      (Icons.rocket_launch_outlined, 'Apps shipped', 'iOS & Android'),
      (Icons.check_circle_outline, 'Freelance', 'Available'),
    ];

    return GlassCard(
      hoverLift: true,
      padding: const EdgeInsets.all(AppDimensions.spaceLg),
      child: Column(
        children: [
          const _AvatarRing(size: 140),
          const SizedBox(height: AppDimensions.spaceLg),
          for (final fact in facts) ...[
            _FactRow(icon: fact.$1, label: fact.$2, value: fact.$3),
            if (fact != facts.last)
              Divider(height: AppDimensions.spaceLg, color: context.colors.border),
          ],
        ],
      ),
    );
  }
}

/// Circular avatar with a gradient ring — shows the AI portrait when present
/// at [AppConstants.profileSquareImage], otherwise the illustration.
class _AvatarRing extends StatelessWidget {
  const _AvatarRing({required this.size});
  final double size;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Container(
      width: size,
      height: size,
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: colors.accentGradient,
        boxShadow: [
          BoxShadow(
            color: colors.accent.withValues(alpha: 0.3),
            blurRadius: 28,
          ),
        ],
      ),
      child: ClipOval(
        child: ColoredBox(
          color: colors.surfaceElevated,
          child: Image.asset(
            AppConstants.profileSquareImage,
            fit: BoxFit.cover,
            semanticLabel: 'Portrait of Ghulam Zakariya',
            errorBuilder: (context, _, __) => Padding(
              padding: const EdgeInsets.all(AppDimensions.spaceMd),
              child: SvgPicture.asset(
                AppConstants.personSvg,
                fit: BoxFit.contain,
                semanticsLabel: 'Developer illustration',
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _FactRow extends StatelessWidget {
  const _FactRow({required this.icon, required this.label, required this.value});
  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Row(
      children: [
        Icon(icon, size: 18, color: colors.accent),
        const SizedBox(width: AppDimensions.spaceSm),
        Text(label,
            style: context.textTheme.bodyMedium
                ?.copyWith(color: colors.textSecondary)),
        const Spacer(),
        Flexible(
          child: Text(
            value,
            textAlign: TextAlign.right,
            style: AppTextStyles.body(14, weight: FontWeight.w600)
                .copyWith(color: colors.textPrimary),
          ),
        ),
      ],
    );
  }
}
