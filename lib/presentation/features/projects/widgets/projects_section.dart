import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_portfolio/domain/entities/project_entity.dart';
import 'package:my_portfolio/presentation/features/projects/bloc/projects_cubit.dart';
import 'package:my_portfolio/presentation/features/projects/bloc/projects_state.dart';
import 'package:my_portfolio/presentation/features/projects/widgets/project_card.dart';
import 'package:my_portfolio/presentation/resources/resources.dart';
import 'package:my_portfolio/presentation/widgets/hover_builder.dart';
import 'package:my_portfolio/presentation/widgets/reveal_on_scroll.dart';
import 'package:my_portfolio/presentation/widgets/section_wrapper.dart';

class ProjectsSection extends StatelessWidget {
  const ProjectsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return SectionWrapper(
      child: BlocBuilder<ProjectsCubit, ProjectsState>(
        builder: (context, state) {
          final categories = <ProjectCategory?>[
            null,
            ...ProjectCategory.values
                .where((c) => state.all.any((p) => p.category == c)),
          ];
          final visible = state.visible;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SectionHeading(
                eyebrow: 'Portfolio',
                title: 'Featured projects',
                subtitle:
                    'A selection of apps I have designed, built and shipped to '
                    'millions of users.',
              ),
              const SizedBox(height: AppDimensions.spaceLg),
              RevealOnScroll(
                child: _FilterBar(
                  categories: categories,
                  selected: state.filter,
                  onSelected: (c) =>
                      context.read<ProjectsCubit>().setFilter(c),
                ),
              ),
              const SizedBox(height: AppDimensions.spaceXl),
              LayoutBuilder(
                builder: (context, constraints) {
                  final width = constraints.maxWidth;
                  final columns = width < 640 ? 1 : (width < 1000 ? 2 : 3);
                  const gap = AppDimensions.spaceLg;
                  final cardWidth =
                      (width - (columns - 1) * gap) / columns;
                  return AnimatedSwitcher(
                    duration: const Duration(milliseconds: 350),
                    transitionBuilder: (child, animation) => FadeTransition(
                      opacity: animation,
                      child: child,
                    ),
                    child: Wrap(
                      key: ValueKey(state.filter),
                      spacing: gap,
                      runSpacing: gap,
                      children: [
                        for (var i = 0; i < visible.length; i++)
                          SizedBox(
                            width: cardWidth,
                            child: RevealOnScroll(
                              delay: Duration(milliseconds: 60 * (i % columns)),
                              child: ProjectCard(project: visible[i]),
                            ),
                          ),
                      ],
                    ),
                  );
                },
              ),
            ],
          );
        },
      ),
    );
  }
}

class _FilterBar extends StatelessWidget {
  const _FilterBar({
    required this.categories,
    required this.selected,
    required this.onSelected,
  });

  final List<ProjectCategory?> categories;
  final ProjectCategory? selected;
  final ValueChanged<ProjectCategory?> onSelected;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: AppDimensions.spaceSm,
      runSpacing: AppDimensions.spaceSm,
      children: [
        for (final category in categories)
          _FilterChip(
            label: category?.label ?? 'All',
            selected: category == selected,
            onTap: () => onSelected(category),
          ),
      ],
    );
  }
}

class _FilterChip extends StatelessWidget {
  const _FilterChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return HoverBuilder(
      onTap: onTap,
      builder: (context, hovering) {
        final active = selected;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
          decoration: BoxDecoration(
            gradient: active ? context.colors.accentGradient : null,
            color: active ? null : colors.surfaceElevated,
            borderRadius: BorderRadius.circular(AppDimensions.radiusPill),
            border: Border.all(
              color: active
                  ? Colors.transparent
                  : (hovering ? colors.accent.withValues(alpha: 0.5) : colors.border),
            ),
          ),
          child: Text(
            label,
            style: AppTextStyles.body(13.5, weight: FontWeight.w600).copyWith(
              color: active ? context.colors.onPrimary : colors.textPrimary,
            ),
          ),
        );
      },
    );
  }
}
