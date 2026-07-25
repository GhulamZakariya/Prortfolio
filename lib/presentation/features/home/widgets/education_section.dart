import 'package:flutter/material.dart';
import 'package:my_portfolio/core/utils/screen_helper.dart';
import 'package:my_portfolio/domain/entities/education_entity.dart';
import 'package:my_portfolio/domain/use_cases/get_portfolio_content_use_cases.dart';
import 'package:my_portfolio/injection/injector.dart';
import 'package:my_portfolio/presentation/resources/resources.dart';
import 'package:my_portfolio/presentation/widgets/glass_card.dart';
import 'package:my_portfolio/presentation/widgets/reveal_on_scroll.dart';
import 'package:my_portfolio/presentation/widgets/section_wrapper.dart';

/// Education — a dedicated, card-based section (distinct from the Experience
/// timeline) with graduation iconography and relevant coursework chips.
class EducationSection extends StatelessWidget {
  const EducationSection({super.key});

  @override
  Widget build(BuildContext context) {
    final education = injector<GetEducationUseCase>().run();
    final isMobile = ScreenHelper.isMobile(context);

    return SectionWrapper(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionHeading(
            eyebrow: 'Learning',
            title: 'Education',
            subtitle:
                'The academic foundation behind my engineering work.',
          ),
          AppDimensions.spaceXxl.vertical,
          Wrap(
            spacing: AppDimensions.spaceLg,
            runSpacing: AppDimensions.spaceLg,
            children: [
              for (var i = 0; i < education.length; i++)
                SizedBox(
                  width: isMobile ? double.infinity : 640,
                  child: RevealOnScroll(
                    delay: Duration(milliseconds: 100 * i),
                    child: _EducationCard(item: education[i]),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _EducationCard extends StatelessWidget {
  const _EducationCard({required this.item});
  final EducationEntity item;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return GlassCard(
      hoverLift: true,
      padding: AppDimensions.spaceLg.all,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Graduation-cap medallion.
              Container(
                width: 56,
                height: 56,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  gradient: colors.accentGradient,
                  borderRadius: AppDimensions.radiusMd.radius,
                  boxShadow: [
                    BoxShadow(
                        color: colors.accent.withValues(alpha: 0.35),
                        blurRadius: 16),
                  ],
                ),
                child: Icon(Icons.school_rounded,
                    color: colors.onPrimary, size: 28),
              ),
              AppDimensions.spaceMd.horizontal,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(item.degree,
                        style: AppTextStyles.heading(22)
                            .copyWith(color: colors.textPrimary)),
                    6.vertical,
                    Row(
                      children: [
                        Icon(Icons.location_city_rounded,
                            size: 15, color: colors.accent),
                        6.horizontal,
                        Expanded(
                          child: Text(item.university,
                              style: AppTextStyles.body(14,
                                      weight: FontWeight.w600)
                                  .copyWith(color: colors.textSecondary)),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              AppDimensions.spaceSm.horizontal,
              _YearPill(text: item.year),
            ],
          ),
          if (item.coursework.isNotEmpty) ...[
            AppDimensions.spaceLg.vertical,
            Divider(color: colors.border, height: 1),
            AppDimensions.spaceMd.vertical,
            Row(
              children: [
                Icon(Icons.menu_book_rounded, size: 16, color: colors.accent),
                8.horizontal,
                Text('Relevant coursework',
                    style: AppTextStyles.body(12.5, weight: FontWeight.w700)
                        .copyWith(color: colors.textPrimary)),
              ],
            ),
            AppDimensions.spaceMd.vertical,
            Wrap(
              spacing: AppDimensions.spaceXs,
              runSpacing: AppDimensions.spaceXs,
              children: [
                for (final course in item.coursework) _CourseChip(label: course),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

class _YearPill extends StatelessWidget {
  const _YearPill({required this.text});
  final String text;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: colors.accent.withValues(alpha: 0.12),
        borderRadius: AppDimensions.radiusPill.radius,
        border: Border.all(color: colors.accent.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.calendar_today_rounded, size: 12, color: colors.accent),
          6.horizontal,
          Text(text,
              style: AppTextStyles.body(11.5, weight: FontWeight.w700)
                  .copyWith(color: colors.accent)),
        ],
      ),
    );
  }
}

class _CourseChip extends StatelessWidget {
  const _CourseChip({required this.label});
  final String label;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
      decoration: BoxDecoration(
        color: colors.surfaceElevated,
        borderRadius: AppDimensions.radiusSm.radius,
        border: Border.all(color: colors.border),
      ),
      child: Text(label,
          style: AppTextStyles.body(12.5, weight: FontWeight.w500)
              .copyWith(color: colors.textSecondary)),
    );
  }
}
