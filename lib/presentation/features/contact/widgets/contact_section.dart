import 'package:flutter/material.dart';
import 'package:my_portfolio/core/utils/screen_helper.dart';
import 'package:my_portfolio/domain/entities/social_link.dart';
import 'package:my_portfolio/domain/use_cases/get_portfolio_content_use_cases.dart';
import 'package:my_portfolio/injection/injector.dart';
import 'package:my_portfolio/presentation/features/contact/widgets/contact_form.dart';
import 'package:my_portfolio/presentation/resources/resources.dart';
import 'package:my_portfolio/presentation/utils/launcher.dart';
import 'package:my_portfolio/presentation/utils/social_presentation.dart';
import 'package:my_portfolio/presentation/widgets/hover_builder.dart';
import 'package:my_portfolio/presentation/widgets/reveal_on_scroll.dart';
import 'package:my_portfolio/presentation/widgets/section_wrapper.dart';
import 'package:my_portfolio/presentation/widgets/social_row.dart';

class ContactSection extends StatelessWidget {
  const ContactSection({super.key});

  static const _infoKinds = [
    SocialKind.email,
    SocialKind.phone,
    SocialKind.whatsapp,
    SocialKind.location,
  ];
  static const _profileKinds = {
    SocialKind.linkedin,
    SocialKind.github,
    SocialKind.instagram,
    SocialKind.fiverr,
  };

  @override
  Widget build(BuildContext context) {
    final isMobile = ScreenHelper.isMobile(context);
    final socials = injector<GetSocialLinksUseCase>().run();
    final info = [
      for (final kind in _infoKinds)
        ...socials.where((s) => s.kind == kind),
    ];
    final profiles =
        socials.where((s) => _profileKinds.contains(s.kind)).toList();

    return SectionWrapper(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionHeading(
            eyebrow: 'Contact',
            title: "Let's work together",
            subtitle:
                'Have a project in mind, or just want to say hello? Send me a '
                "message and I'll reply as soon as I can.",
          ),
          const SizedBox(height: AppDimensions.spaceXxl),
          if (isMobile)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RevealOnScroll(
                  child: _ContactInfo(info: info, profiles: profiles),
                ),
                const SizedBox(height: AppDimensions.spaceXl),
                const RevealOnScroll(
                  delay: Duration(milliseconds: 120),
                  child: ContactForm(),
                ),
              ],
            )
          else
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 5,
                  child: RevealOnScroll(
                    child: _ContactInfo(info: info, profiles: profiles),
                  ),
                ),
                const SizedBox(width: AppDimensions.spaceXxl),
                const Expanded(
                  flex: 6,
                  child: RevealOnScroll(
                    delay: Duration(milliseconds: 120),
                    child: ContactForm(),
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }
}

class _ContactInfo extends StatelessWidget {
  const _ContactInfo({required this.info, required this.profiles});
  final List<SocialLink> info;
  final List<SocialLink> profiles;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Prefer a direct line?',
          style: AppTextStyles.heading(22).copyWith(color: colors.textPrimary),
        ),
        const SizedBox(height: AppDimensions.spaceXs),
        Text(
          'Reach me on any of these — I usually respond within a day.',
          style: context.textTheme.bodyMedium
              ?.copyWith(color: colors.textSecondary),
        ),
        const SizedBox(height: AppDimensions.spaceLg),
        for (final item in info) ...[
          _InfoRow(link: item),
          const SizedBox(height: AppDimensions.spaceSm),
        ],
        const SizedBox(height: AppDimensions.spaceMd),
        Text('Find me online',
            style: AppTextStyles.body(13, weight: FontWeight.w700)
                .copyWith(color: colors.textPrimary)),
        const SizedBox(height: AppDimensions.spaceSm),
        SocialRow(links: profiles),
      ],
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.link});
  final SocialLink link;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return HoverBuilder(
      onTap: () => Launcher.open(link.url),
      builder: (context, hovering) => Row(
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            width: 46,
            height: 46,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: hovering
                  ? colors.accent.withValues(alpha: 0.16)
                  : colors.surfaceElevated,
              borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
              border: Border.all(
                  color: hovering
                      ? colors.accent.withValues(alpha: 0.5)
                      : colors.border),
            ),
            child: Icon(socialIcon(link.kind), size: 20, color: colors.accent),
          ),
          const SizedBox(width: AppDimensions.spaceMd),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(socialTitle(link.kind),
                  style: AppTextStyles.body(12, weight: FontWeight.w600)
                      .copyWith(color: colors.textMuted)),
              Text(link.label,
                  style: AppTextStyles.body(14, weight: FontWeight.w600)
                      .copyWith(color: colors.textPrimary)),
            ],
          ),
        ],
      ),
    );
  }
}
