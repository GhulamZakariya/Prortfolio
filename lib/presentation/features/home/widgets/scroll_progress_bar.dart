import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_portfolio/presentation/features/home/bloc/navigation_cubit.dart';
import 'package:my_portfolio/presentation/features/home/bloc/navigation_state.dart';
import 'package:my_portfolio/presentation/resources/resources.dart';

/// Thin gradient bar pinned to the very top that fills as the page scrolls.
class ScrollProgressBar extends StatelessWidget {
  const ScrollProgressBar({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NavigationCubit, NavigationState>(
      buildWhen: (a, b) => a.scrollProgress != b.scrollProgress,
      builder: (context, state) {
        return SizedBox(
          height: 3,
          child: Align(
            alignment: Alignment.centerLeft,
            child: FractionallySizedBox(
              widthFactor: state.scrollProgress.clamp(0.0, 1.0),
              child: Container(
                decoration: BoxDecoration(
                  gradient: context.colors.accentGradient,
                  boxShadow: [
                    BoxShadow(color: context.colors.accent, blurRadius: 6),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
