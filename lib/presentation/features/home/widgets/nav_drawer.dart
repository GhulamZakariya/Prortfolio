import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_portfolio/core/utils/constants.dart';
import 'package:my_portfolio/domain/entities/social_link.dart';
import 'package:my_portfolio/domain/use_cases/get_portfolio_content_use_cases.dart';
import 'package:my_portfolio/injection/injector.dart';
import 'package:my_portfolio/presentation/features/home/bloc/navigation_cubit.dart';
import 'package:my_portfolio/presentation/features/home/bloc/navigation_state.dart';
import 'package:my_portfolio/presentation/features/theme/widgets/theme_toggle.dart';
import 'package:my_portfolio/presentation/resources/resources.dart';
import 'package:my_portfolio/presentation/utils/launcher.dart';
import 'package:my_portfolio/presentation/widgets/app_button.dart';
import 'package:my_portfolio/presentation/widgets/social_row.dart';

class NavDrawer extends StatelessWidget {
  const NavDrawer({super.key});

  static const _profileKinds = {
    SocialKind.email,
    SocialKind.linkedin,
    SocialKind.github,
    SocialKind.instagram,
  };

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final profiles = injector<GetSocialLinksUseCase>()
        .run()
        .where((s) => _profileKinds.contains(s.kind))
        .toList();

    return Drawer(
      backgroundColor: colors.surface,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppDimensions.spaceLg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Menu',
                      style: AppTextStyles.heading(22)
                          .copyWith(color: colors.textPrimary)),
                  const ThemeToggle(),
                ],
              ),
              const SizedBox(height: AppDimensions.spaceLg),
              for (final section in HomeSection.values)
                _DrawerItem(section: section),
              const Spacer(),
              AppButton(
                label: 'Download CV',
                icon: Icons.download_rounded,
                expand: true,
                onPressed: () => Launcher.open(AppConstants.resumeUrl),
              ),
              const SizedBox(height: AppDimensions.spaceLg),
              SocialRow(links: profiles, size: 40),
            ],
          ),
        ),
      ),
    );
  }
}

class _DrawerItem extends StatelessWidget {
  const _DrawerItem({required this.section});
  final HomeSection section;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(_iconFor(section), color: colors.accent, size: 20),
      title: Text(section.label,
          style: AppTextStyles.body(15, weight: FontWeight.w600)
              .copyWith(color: colors.textPrimary)),
      onTap: () {
        Navigator.of(context).pop();
        context.read<NavigationCubit>().scrollTo(section);
      },
    );
  }

  IconData _iconFor(HomeSection section) {
    switch (section) {
      case HomeSection.home:
        return Icons.home_rounded;
      case HomeSection.about:
        return Icons.person_outline_rounded;
      case HomeSection.skills:
        return Icons.auto_awesome_outlined;
      case HomeSection.experience:
        return Icons.timeline_rounded;
      case HomeSection.education:
        return Icons.school_rounded;
      case HomeSection.projects:
        return Icons.grid_view_rounded;
      case HomeSection.contact:
        return Icons.mail_outline_rounded;
    }
  }
}
