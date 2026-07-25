import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_portfolio/core/routes/routes.dart';
import 'package:my_portfolio/injection/injector.dart';
import 'package:my_portfolio/presentation/features/contact/bloc/contact_cubit.dart';
import 'package:my_portfolio/presentation/features/home/bloc/navigation_cubit.dart';
import 'package:my_portfolio/presentation/features/projects/bloc/projects_cubit.dart';
import 'package:my_portfolio/presentation/features/theme/bloc/app_theme_cubit.dart';
import 'package:my_portfolio/presentation/features/theme/bloc/app_theme_state.dart';
import 'package:my_portfolio/presentation/resources/resources.dart';

/// Root widget. Provides the app-wide cubits (theme, navigation, projects,
/// contact) above the router so every page can reach them, and rebuilds the
/// [MaterialApp] when the theme changes.
class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AppThemeCubit>(create: (_) => injector<AppThemeCubit>()),
        BlocProvider<NavigationCubit>(
            create: (_) => injector<NavigationCubit>()),
        BlocProvider<ProjectsCubit>(
            create: (_) => injector<ProjectsCubit>()..load()),
        BlocProvider<ContactCubit>(create: (_) => injector<ContactCubit>()),
      ],
      child: BlocBuilder<AppThemeCubit, AppThemeState>(
        builder: (context, state) {
          return MaterialApp.router(
            title: 'Ghulam Zakariya · Flutter Developer',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.light,
            darkTheme: AppTheme.dark,
            themeMode: state.themeMode,
            routerConfig: RouterGenerator.router,
          );
        },
      ),
    );
  }
}
