import 'package:flutter/material.dart';
import 'package:visibility_detector/visibility_detector.dart';

/// Fades + slides its child in the first time it scrolls into view.
///
/// Driven by an [AnimationController] (no `setState`). Stagger a group by
/// passing increasing [delay]s. Respects the OS "reduce motion" setting.
class RevealOnScroll extends StatefulWidget {
  const RevealOnScroll({
    super.key,
    required this.child,
    this.delay = Duration.zero,
    this.duration = const Duration(milliseconds: 650),
    this.offset = const Offset(0, 40),
    this.curve = Curves.easeOutCubic,
    this.visibleFraction = 0.08,
  });

  final Widget child;
  final Duration delay;
  final Duration duration;
  final Offset offset;
  final Curve curve;
  final double visibleFraction;

  @override
  State<RevealOnScroll> createState() => _RevealOnScrollState();
}

class _RevealOnScrollState extends State<RevealOnScroll>
    with SingleTickerProviderStateMixin {
  final Key _key = UniqueKey();
  late final AnimationController _controller =
      AnimationController(vsync: this, duration: widget.duration);
  bool _triggered = false;

  void _onVisibility(VisibilityInfo info) {
    if (_triggered) return;
    if (info.visibleFraction >= widget.visibleFraction) {
      _triggered = true;
      if (widget.delay == Duration.zero) {
        _controller.forward();
      } else {
        Future.delayed(widget.delay, () {
          if (mounted) _controller.forward();
        });
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final reduceMotion = MediaQuery.maybeOf(context)?.disableAnimations ?? false;
    if (reduceMotion) return widget.child;

    return VisibilityDetector(
      key: _key,
      onVisibilityChanged: _onVisibility,
      child: AnimatedBuilder(
        animation: _controller,
        child: widget.child,
        builder: (context, child) {
          final t = widget.curve.transform(_controller.value);
          return Opacity(
            opacity: t,
            child: Transform.translate(
              offset: Offset(
                widget.offset.dx * (1 - t),
                widget.offset.dy * (1 - t),
              ),
              child: child,
            ),
          );
        },
      ),
    );
  }
}
