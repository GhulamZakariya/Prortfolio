import 'package:flutter/material.dart';
import 'package:my_portfolio/core/utils/screen_helper.dart';
import 'package:my_portfolio/domain/entities/skill_entity.dart';
import 'package:my_portfolio/domain/use_cases/get_portfolio_content_use_cases.dart';
import 'package:my_portfolio/injection/injector.dart';
import 'package:my_portfolio/presentation/resources/resources.dart';
import 'package:my_portfolio/presentation/widgets/glass_card.dart';
import 'package:my_portfolio/presentation/widgets/reveal_on_scroll.dart';
import 'package:my_portfolio/presentation/widgets/section_wrapper.dart';
import 'package:visibility_detector/visibility_detector.dart';

class SkillsSection extends StatelessWidget {
  const SkillsSection({super.key});

  static const _services = <(IconData, String, String)>[
    (
      Icons.phone_iphone_rounded,
      'Mobile App Development',
      'Cross-platform iOS & Android apps built with Flutter — pixel-perfect and fast.'
    ),
    (
      Icons.language_rounded,
      'Web Development',
      'Responsive web experiences with Flutter Web — like this very portfolio.'
    ),
    (
      Icons.code_rounded,
      'Open Source',
      'Building and sharing tools & packages with the developer community on GitHub.'
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final skills = injector<GetSkillsUseCase>().run();
    final isMobile = ScreenHelper.isMobile(context);

    final grouped = {
      for (final category in SkillCategory.values)
        category: skills.where((s) => s.category == category).toList(),
    };

    return SectionWrapper(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionHeading(
            eyebrow: 'What I do',
            title: 'Skills & expertise',
            subtitle:
                "Productive and experienced — here are the tools I reach for and how "
                'confident I am with each.',
          ),
          const SizedBox(height: AppDimensions.spaceXxl),
          // "What I do" highlight cards.
          Wrap(
            spacing: AppDimensions.spaceLg,
            runSpacing: AppDimensions.spaceLg,
            children: [
              for (var i = 0; i < _services.length; i++)
                SizedBox(
                  width: isMobile ? double.infinity : 340,
                  child: RevealOnScroll(
                    delay: Duration(milliseconds: 80 * i),
                    child: _ServiceCard(
                      icon: _services[i].$1,
                      title: _services[i].$2,
                      description: _services[i].$3,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: AppDimensions.spaceXxl),
          // Skill bars grouped by category.
          Wrap(
            spacing: AppDimensions.spaceLg,
            runSpacing: AppDimensions.spaceLg,
            children: [
              for (final entry in grouped.entries)
                if (entry.value.isNotEmpty)
                  SizedBox(
                    width: isMobile ? double.infinity : 345,
                    child: RevealOnScroll(
                      child: _SkillGroupCard(
                        category: entry.key,
                        skills: entry.value,
                      ),
                    ),
                  ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ServiceCard extends StatelessWidget {
  const _ServiceCard({
    required this.icon,
    required this.title,
    required this.description,
  });
  final IconData icon;
  final String title;
  final String description;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return GlassCard(
      hoverLift: true,
      padding: const EdgeInsets.all(AppDimensions.spaceLg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 54,
            height: 54,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: colors.accent.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
              border: Border.all(color: colors.accent.withValues(alpha: 0.3)),
            ),
            child: Icon(icon, color: colors.accent, size: 26),
          ),
          const SizedBox(height: AppDimensions.spaceMd),
          Text(title,
              style: AppTextStyles.heading(19)
                  .copyWith(color: colors.textPrimary)),
          const SizedBox(height: AppDimensions.spaceXs),
          Text(description,
              style: context.textTheme.bodyMedium
                  ?.copyWith(color: colors.textSecondary)),
        ],
      ),
    );
  }
}

class _SkillGroupCard extends StatelessWidget {
  const _SkillGroupCard({required this.category, required this.skills});
  final SkillCategory category;
  final List<SkillEntity> skills;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return GlassCard(
      padding: const EdgeInsets.all(AppDimensions.spaceLg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(category.label,
              style: AppTextStyles.heading(18)
                  .copyWith(color: colors.textPrimary)),
          const SizedBox(height: AppDimensions.spaceMd),
          for (final skill in skills)
            Padding(
              padding: const EdgeInsets.only(bottom: AppDimensions.spaceMd),
              child: _SkillBar(skill: skill),
            ),
        ],
      ),
    );
  }
}

class _SkillBar extends StatefulWidget {
  const _SkillBar({required this.skill});
  final SkillEntity skill;

  @override
  State<_SkillBar> createState() => _SkillBarState();
}

class _SkillBarState extends State<_SkillBar>
    with SingleTickerProviderStateMixin {
  final Key _key = UniqueKey();
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1100),
  );

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return VisibilityDetector(
      key: _key,
      onVisibilityChanged: (info) {
        if (info.visibleFraction > 0.2 &&
            !_controller.isAnimating &&
            _controller.value == 0) {
          _controller.forward();
        }
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(widget.skill.name,
                  style: AppTextStyles.body(13.5, weight: FontWeight.w600)
                      .copyWith(color: colors.textPrimary)),
              Text('${(widget.skill.level * 100).round()}%',
                  style: AppTextStyles.body(12.5, weight: FontWeight.w600)
                      .copyWith(color: colors.textSecondary)),
            ],
          ),
          6.vertical,
          LayoutBuilder(
            builder: (context, constraints) => Stack(
              children: [
                Container(
                  height: 7,
                  decoration: BoxDecoration(
                    color: colors.surfaceElevated,
                    borderRadius: AppDimensions.radiusPill.radius,
                  ),
                ),
                AnimatedBuilder(
                  animation: _controller,
                  builder: (context, _) {
                    final value = Curves.easeOutCubic
                            .transform(_controller.value) *
                        widget.skill.level;
                    return Container(
                      height: 7,
                      width: constraints.maxWidth * value,
                      decoration: BoxDecoration(
                        gradient: colors.accentGradient,
                        borderRadius: AppDimensions.radiusPill.radius,
                        boxShadow: [
                          BoxShadow(
                            color: colors.accent.withValues(alpha: 0.4),
                            blurRadius: 8,
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
