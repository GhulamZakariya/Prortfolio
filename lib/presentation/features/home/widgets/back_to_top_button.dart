import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_portfolio/presentation/features/home/bloc/navigation_cubit.dart';
import 'package:my_portfolio/presentation/features/home/bloc/navigation_state.dart';
import 'package:my_portfolio/presentation/resources/resources.dart';
import 'package:my_portfolio/presentation/widgets/hover_builder.dart';

/// Floating "back to top" button that fades/scales in once the user has
/// scrolled past the hero.
class BackToTopButton extends StatelessWidget {
  const BackToTopButton({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return BlocBuilder<NavigationCubit, NavigationState>(
      buildWhen: (a, b) => a.showBackToTop != b.showBackToTop,
      builder: (context, state) {
        return AnimatedScale(
          scale: state.showBackToTop ? 1 : 0,
          duration: const Duration(milliseconds: 220),
          curve: Curves.easeOutBack,
          child: AnimatedOpacity(
            opacity: state.showBackToTop ? 1 : 0,
            duration: const Duration(milliseconds: 220),
            child: HoverBuilder(
              onTap: () =>
                  context.read<NavigationCubit>().scrollTo(HomeSection.home),
              builder: (context, hovering) => Container(
                width: 50,
                height: 50,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: context.colors.accentGradient,
                  boxShadow: [
                    BoxShadow(
                      color: colors.accent.withValues(alpha: hovering ? 0.6 : 0.35),
                      blurRadius: hovering ? 24 : 14,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Icon(Icons.arrow_upward_rounded,
                    color: context.colors.onPrimary),
              ),
            ),
          ),
        );
      },
    );
  }
}
