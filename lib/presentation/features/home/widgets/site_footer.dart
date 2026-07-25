import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_portfolio/domain/entities/social_link.dart';
import 'package:my_portfolio/domain/use_cases/get_portfolio_content_use_cases.dart';
import 'package:my_portfolio/injection/injector.dart';
import 'package:my_portfolio/presentation/features/home/bloc/navigation_cubit.dart';
import 'package:my_portfolio/presentation/features/home/bloc/navigation_state.dart';
import 'package:my_portfolio/presentation/resources/resources.dart';
import 'package:my_portfolio/presentation/widgets/brand_logo.dart';
import 'package:my_portfolio/presentation/widgets/hover_builder.dart';
import 'package:my_portfolio/presentation/widgets/social_row.dart';

class SiteFooter extends StatelessWidget {
  const SiteFooter({super.key});

  static const _profileKinds = {
    SocialKind.linkedin,
    SocialKind.github,
    SocialKind.instagram,
    SocialKind.fiverr,
    SocialKind.email,
  };

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final year = DateTime.now().year;
    final profiles = injector<GetSocialLinksUseCase>()
        .run()
        .where((s) => _profileKinds.contains(s.kind))
        .toList();

    return Container(
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: colors.border)),
      ),
      child: Center(
        child: ConstrainedBox(
          constraints:
              const BoxConstraints(maxWidth: AppDimensions.maxContentWidth),
          child: Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: AppDimensions.spaceXl,
                vertical: AppDimensions.spaceXxl),
            child: Column(
              children: [
                Wrap(
                  alignment: WrapAlignment.spaceBetween,
                  crossAxisAlignment: WrapCrossAlignment.start,
                  runSpacing: AppDimensions.spaceLg,
                  children: [
                    SizedBox(
                      width: 320,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const BrandLogo(monogramSize: 36, fontSize: 18),
                          16.vertical,
                          Text(
                            'Flutter Developer crafting delightful, high-quality '
                            'mobile experiences from Lahore, Pakistan.',
                            style: context.textTheme.bodyMedium
                                ?.copyWith(color: colors.textSecondary),
                          ),
                        ],
                      ),
                    ),
                    _QuickLinks(),
                  ],
                ),
                const SizedBox(height: AppDimensions.spaceXl),
                Divider(color: colors.border),
                const SizedBox(height: AppDimensions.spaceMd),
                Wrap(
                  alignment: WrapAlignment.spaceBetween,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  runSpacing: AppDimensions.spaceMd,
                  spacing: AppDimensions.spaceMd,
                  children: [
                    Text(
                      '© $year Ghulam Zakariya · Built with Flutter 💛',
                      style: context.textTheme.bodySmall
                          ?.copyWith(color: colors.textMuted),
                    ),
                    SocialRow(links: profiles, size: 38),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _QuickLinks extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return SizedBox(
      width: 260,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Explore',
              style: AppTextStyles.body(13, weight: FontWeight.w700)
                  .copyWith(color: colors.textPrimary)),
          const SizedBox(height: AppDimensions.spaceSm),
          Wrap(
            spacing: AppDimensions.spaceLg,
            runSpacing: AppDimensions.spaceXs,
            children: [
              for (final section in HomeSection.values)
                HoverBuilder(
                  onTap: () =>
                      context.read<NavigationCubit>().scrollTo(section),
                  builder: (context, hovering) => Text(
                    section.label,
                    style: AppTextStyles.body(13.5, weight: FontWeight.w500)
                        .copyWith(
                      color:
                          hovering ? colors.accent : colors.textSecondary,
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
