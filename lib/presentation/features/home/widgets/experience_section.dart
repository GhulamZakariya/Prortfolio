import 'package:flutter/material.dart';
import 'package:my_portfolio/domain/entities/experience_entity.dart';
import 'package:my_portfolio/domain/use_cases/get_portfolio_content_use_cases.dart';
import 'package:my_portfolio/injection/injector.dart';
import 'package:my_portfolio/presentation/resources/resources.dart';
import 'package:my_portfolio/presentation/widgets/glass_card.dart';
import 'package:my_portfolio/presentation/widgets/reveal_on_scroll.dart';
import 'package:my_portfolio/presentation/widgets/section_wrapper.dart';
import 'package:my_portfolio/presentation/widgets/tech_badge.dart';

/// Professional experience — a modern timeline of roles, each card showing
/// responsibilities, the tech stack used and major achievements.
class ExperienceSection extends StatelessWidget {
  const ExperienceSection({super.key});

  @override
  Widget build(BuildContext context) {
    final experiences = injector<GetExperiencesUseCase>().run();

    return SectionWrapper(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionHeading(
            eyebrow: 'Career',
            title: 'Professional experience',
            subtitle:
                'Where I have worked and what I have delivered — building and '
                'shipping apps for global brands.',
          ),
          AppDimensions.spaceXxl.vertical,
          for (var i = 0; i < experiences.length; i++)
            _TimelineTile(
              item: experiences[i],
              isFirst: i == 0,
              isLast: i == experiences.length - 1,
              index: i,
            ),
        ],
      ),
    );
  }
}

class _TimelineTile extends StatelessWidget {
  const _TimelineTile({
    required this.item,
    required this.isFirst,
    required this.isLast,
    required this.index,
  });

  final ExperienceEntity item;
  final bool isFirst;
  final bool isLast;
  final int index;

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _Rail(isFirst: isFirst, isLast: isLast),
          AppDimensions.spaceLg.horizontal,
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(bottom: isLast ? 0 : AppDimensions.spaceLg),
              child: RevealOnScroll(
                delay: Duration(milliseconds: 80 * index),
                offset: const Offset(40, 0),
                child: _Card(item: item),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Rail extends StatelessWidget {
  const _Rail({required this.isFirst, required this.isLast});
  final bool isFirst;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return SizedBox(
      width: 40,
      child: Column(
        children: [
          Container(
            width: 2,
            height: 6,
            color: isFirst ? Colors.transparent : colors.border,
          ),
          Container(
            width: 38,
            height: 38,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: colors.accentGradient,
              boxShadow: [
                BoxShadow(
                    color: colors.accent.withValues(alpha: 0.4), blurRadius: 12),
              ],
            ),
            child: Icon(Icons.work_rounded, size: 18, color: colors.onPrimary),
          ),
          Expanded(
            child: Container(
              width: 2,
              color: isLast ? Colors.transparent : colors.border,
            ),
          ),
        ],
      ),
    );
  }
}

class _Card extends StatelessWidget {
  const _Card({required this.item});
  final ExperienceEntity item;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return GlassCard(
      hoverLift: true,
      padding: AppDimensions.spaceLg.all,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _Pill(text: item.duration),
          AppDimensions.spaceSm.vertical,
          Text(item.jobTitle,
              style:
                  AppTextStyles.heading(21).copyWith(color: colors.textPrimary)),
          2.vertical,
          Row(
            children: [
              Icon(Icons.apartment_rounded, size: 15, color: colors.accent),
              6.horizontal,
              Text(item.company,
                  style: AppTextStyles.body(14, weight: FontWeight.w600)
                      .copyWith(color: colors.accent)),
            ],
          ),
          AppDimensions.spaceSm.vertical,
          Text(item.description,
              style: context.textTheme.bodyMedium
                  ?.copyWith(color: colors.textSecondary)),
          if (item.responsibilities.isNotEmpty) ...[
            AppDimensions.spaceMd.vertical,
            const _Label('Key responsibilities'),
            8.vertical,
            for (final r in item.responsibilities)
              _Bullet(icon: Icons.check_circle, text: r),
          ],
          if (item.technologies.isNotEmpty) ...[
            AppDimensions.spaceMd.vertical,
            const _Label('Technologies'),
            8.vertical,
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: [
                for (final t in item.technologies)
                  TechBadge(name: t.name, logoAsset: t.logoAsset, compact: true),
              ],
            ),
          ],
          if (item.achievements.isNotEmpty) ...[
            AppDimensions.spaceMd.vertical,
            const _Label('Major achievements'),
            8.vertical,
            for (final a in item.achievements)
              _Bullet(icon: Icons.emoji_events_rounded, text: a),
          ],
        ],
      ),
    );
  }
}

class _Pill extends StatelessWidget {
  const _Pill({required this.text});
  final String text;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
      decoration: BoxDecoration(
        color: colors.accent.withValues(alpha: 0.12),
        borderRadius: AppDimensions.radiusPill.radius,
        border: Border.all(color: colors.accent.withValues(alpha: 0.3)),
      ),
      child: Text(text,
          style: AppTextStyles.body(12, weight: FontWeight.w700)
              .copyWith(color: colors.accent)),
    );
  }
}

class _Label extends StatelessWidget {
  const _Label(this.text);
  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(text.toUpperCase(),
        style: AppTextStyles.body(11, weight: FontWeight.w800)
            .copyWith(color: context.colors.textMuted, letterSpacing: 1.2));
  }
}

class _Bullet extends StatelessWidget {
  const _Bullet({required this.icon, required this.text});
  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Padding(
      padding: const EdgeInsets.only(bottom: AppDimensions.spaceXs),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 3),
            child: Icon(icon, size: 15, color: colors.accent),
          ),
          8.horizontal,
          Expanded(
            child: Text(text,
                style: context.textTheme.bodyMedium
                    ?.copyWith(color: colors.textSecondary)),
          ),
        ],
      ),
    );
  }
}
