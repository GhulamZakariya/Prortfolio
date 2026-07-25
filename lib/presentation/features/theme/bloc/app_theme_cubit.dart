import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:my_portfolio/presentation/features/theme/bloc/app_theme_state.dart';

/// Owns the light/dark preference. Dark is the default (the site's identity).
@injectable
class AppThemeCubit extends Cubit<AppThemeState> {
  AppThemeCubit() : super(const AppThemeState());

  void toggle() => emit(state.copyWith(isDark: !state.isDark));

  void setDark({required bool isDark}) => emit(state.copyWith(isDark: isDark));
}
