import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:my_portfolio/presentation/features/home/bloc/navigation_state.dart';

/// Drives smooth section navigation, the scroll-progress bar and the
/// back-to-top button. Holds a [GlobalKey] per section so nav clicks can
/// `ensureVisible` the right widget.
@injectable
class NavigationCubit extends Cubit<NavigationState> {
  NavigationCubit() : super(const NavigationState());

  final Map<HomeSection, GlobalKey> keys = {
    for (final section in HomeSection.values) section: GlobalKey(),
  };

  GlobalKey keyOf(HomeSection section) => keys[section]!;

  Future<void> scrollTo(HomeSection section) async {
    final context = keys[section]?.currentContext;
    if (context == null) return;
    emit(state.copyWith(activeSection: section));
    await Scrollable.ensureVisible(
      context,
      duration: const Duration(milliseconds: 700),
      curve: Curves.easeInOutCubic,
      alignment: section == HomeSection.home ? 0 : 0.05,
    );
  }

  /// Called from the page's scroll listener.
  void onScroll(double offset, double maxScrollExtent) {
    final progress =
        maxScrollExtent <= 0 ? 0.0 : (offset / maxScrollExtent).clamp(0.0, 1.0);
    final showBackToTop = offset > 500;
    final scrolled = offset > 24;
    if (progress != state.scrollProgress ||
        showBackToTop != state.showBackToTop ||
        scrolled != state.scrolled) {
      emit(state.copyWith(
        scrollProgress: progress,
        showBackToTop: showBackToTop,
        scrolled: scrolled,
      ));
    }
  }

  /// Reports the section currently dominating the viewport (from reveal
  /// visibility callbacks) so the header can highlight the active nav item.
  void setActiveSection(HomeSection section) {
    if (section != state.activeSection) {
      emit(state.copyWith(activeSection: section));
    }
  }
}
