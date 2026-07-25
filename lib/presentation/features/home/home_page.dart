import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_portfolio/core/analytics/analytics_service.dart';
import 'package:my_portfolio/core/utils/globals.dart';
import 'package:my_portfolio/injection/injector.dart';
import 'package:my_portfolio/presentation/features/contact/widgets/contact_section.dart';
import 'package:my_portfolio/presentation/features/home/bloc/navigation_cubit.dart';
import 'package:my_portfolio/presentation/features/home/bloc/navigation_state.dart';
import 'package:my_portfolio/presentation/features/home/widgets/about_section.dart';
import 'package:my_portfolio/presentation/features/home/widgets/app_header.dart';
import 'package:my_portfolio/presentation/features/home/widgets/back_to_top_button.dart';
import 'package:my_portfolio/presentation/features/home/widgets/education_section.dart';
import 'package:my_portfolio/presentation/features/home/widgets/experience_section.dart';
import 'package:my_portfolio/presentation/features/home/widgets/hero_section.dart';
import 'package:my_portfolio/presentation/features/home/widgets/nav_drawer.dart';
import 'package:my_portfolio/presentation/features/home/widgets/scroll_progress_bar.dart';
import 'package:my_portfolio/presentation/features/home/widgets/site_footer.dart';
import 'package:my_portfolio/presentation/features/home/widgets/skills_section.dart';
import 'package:my_portfolio/presentation/features/projects/widgets/projects_section.dart';
import 'package:my_portfolio/presentation/resources/resources.dart';
import 'package:my_portfolio/presentation/widgets/animated_background.dart';
import 'package:visibility_detector/visibility_detector.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Timer(const Duration(seconds: 2), () async {
        final analytics = injector<AnalyticsService>();
        await analytics.logStartupEvent();
        await analytics.logScreen('home');
      });
    });
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;
    context.read<NavigationCubit>().onScroll(
          _scrollController.offset,
          _scrollController.position.maxScrollExtent,
        );
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
    super.dispose();
  }

  Widget _anchor(HomeSection section, Widget child) {
    final navigation = context.read<NavigationCubit>();
    return KeyedSubtree(
      key: navigation.keyOf(section),
      child: VisibilityDetector(
        key: ValueKey('anchor_${section.name}'),
        onVisibilityChanged: (info) {
          if (info.visibleFraction > 0.5) {
            navigation.setActiveSection(section);
          }
        },
        child: child,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: Globals.scaffoldKey,
      endDrawer: const NavDrawer(),
      body: AnimatedBackground(
        child: Stack(
          children: [
            ScrollConfiguration(
              behavior:
                  ScrollConfiguration.of(context).copyWith(scrollbars: false),
              child: SingleChildScrollView(
                controller: _scrollController,
                physics: const ClampingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _anchor(HomeSection.home, const HeroSection()),
                    _anchor(HomeSection.about, const AboutSection()),
                    _anchor(HomeSection.skills, const SkillsSection()),
                    _anchor(
                        HomeSection.experience, const ExperienceSection()),
                    _anchor(HomeSection.education, const EducationSection()),
                    _anchor(HomeSection.projects, const ProjectsSection()),
                    _anchor(HomeSection.contact, const ContactSection()),
                    const SiteFooter(),
                  ],
                ),
              ),
            ),
            const Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Column(
                children: [
                  ScrollProgressBar(),
                  AppHeader(),
                ],
              ),
            ),
            const Positioned(
              right: AppDimensions.spaceLg,
              bottom: AppDimensions.spaceLg,
              child: BackToTopButton(),
            ),
          ],
        ),
      ),
    );
  }
}
