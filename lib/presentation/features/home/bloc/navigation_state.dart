import 'package:freezed_annotation/freezed_annotation.dart';

part 'navigation_state.freezed.dart';

/// The scrollable sections of the home page, in order.
enum HomeSection {
  home('Home'),
  about('About'),
  skills('Skills'),
  experience('Experience'),
  education('Education'),
  projects('Projects'),
  contact('Contact');

  const HomeSection(this.label);
  final String label;
}

@freezed
abstract class NavigationState with _$NavigationState {
  const factory NavigationState({
    @Default(0.0) double scrollProgress,
    @Default(false) bool showBackToTop,
    @Default(false) bool scrolled,
    @Default(HomeSection.home) HomeSection activeSection,
  }) = _NavigationState;
}
