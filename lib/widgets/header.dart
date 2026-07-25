import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:my_portfolio/core/routes/routes.dart';
import 'package:my_portfolio/presentation/resources/resources.dart';
import 'package:my_portfolio/presentation/widgets/brand_logo.dart';

/// Slim top bar for the secondary pages (works, demos, tools): a back-to-home
/// brand lockup.
class CommonHeader extends StatelessWidget {
  const CommonHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Container(
      color: colors.background.withValues(alpha: 0.95),
      padding: const EdgeInsets.symmetric(
          horizontal: AppDimensions.spaceLg, vertical: AppDimensions.spaceSm),
      child: SafeArea(
        bottom: false,
        child: Row(
          children: [
            Icon(Icons.arrow_back_rounded, size: 18, color: colors.textSecondary),
            8.horizontal,
            BrandLogo(onTap: () => context.go(Routes.initial)),
          ],
        ),
      ),
    );
  }
}
