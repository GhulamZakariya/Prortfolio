import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_portfolio/presentation/features/theme/bloc/app_theme_cubit.dart';
import 'package:my_portfolio/presentation/features/theme/bloc/app_theme_state.dart';
import 'package:my_portfolio/presentation/resources/resources.dart';

/// Animated dark/light toggle bound to [AppThemeCubit].
class ThemeToggle extends StatelessWidget {
  const ThemeToggle({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return BlocBuilder<AppThemeCubit, AppThemeState>(
      builder: (context, state) {
        final isDark = state.isDark;
        return Tooltip(
          message: isDark ? 'Switch to light mode' : 'Switch to dark mode',
          child: MouseRegion(
            cursor: SystemMouseCursors.click,
            child: GestureDetector(
              onTap: () => context.read<AppThemeCubit>().toggle(),
              child: Container(
                width: 58,
                height: 30,
                padding: const EdgeInsets.all(3),
                decoration: BoxDecoration(
                  color: colors.surfaceElevated,
                  borderRadius: BorderRadius.circular(AppDimensions.radiusPill),
                  border: Border.all(color: colors.border),
                ),
                child: AnimatedAlign(
                  duration: const Duration(milliseconds: 260),
                  curve: Curves.easeOutBack,
                  alignment:
                      isDark ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: context.colors.accentGradient,
                    ),
                    child: Icon(
                      isDark
                          ? Icons.dark_mode_rounded
                          : Icons.light_mode_rounded,
                      size: 15,
                      color: context.colors.onPrimary,
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
