import 'package:flutter/material.dart';
import 'package:my_portfolio/presentation/resources/resources.dart';
import 'package:visibility_detector/visibility_detector.dart';

/// Counts up from 0 to [value] the first time it scrolls into view.
/// Driven by an [AnimationController] (no `setState`).
class AnimatedCounter extends StatefulWidget {
  const AnimatedCounter({
    super.key,
    required this.value,
    this.suffix = '',
    this.label,
    this.duration = const Duration(milliseconds: 1400),
  });

  final int value;
  final String suffix;
  final String? label;
  final Duration duration;

  @override
  State<AnimatedCounter> createState() => _AnimatedCounterState();
}

class _AnimatedCounterState extends State<AnimatedCounter>
    with SingleTickerProviderStateMixin {
  final Key _key = UniqueKey();
  late final AnimationController _controller =
      AnimationController(vsync: this, duration: widget.duration);

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return VisibilityDetector(
      key: _key,
      onVisibilityChanged: (info) {
        if (info.visibleFraction > 0.3 && !_controller.isAnimating &&
            _controller.value == 0) {
          _controller.forward();
        }
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AnimatedBuilder(
            animation: _controller,
            builder: (context, _) {
              final v = (_controller.value * widget.value).round();
              return ShaderMask(
                shaderCallback: (rect) =>
                    colors.accentGradient.createShader(rect),
                child: Text(
                  '$v${widget.suffix}',
                  style: AppTextStyles.heading(44)
                      .copyWith(color: colors.onPrimary),
                ),
              );
            },
          ),
          if (widget.label != null)
            Text(
              widget.label!,
              style: context.textTheme.bodyMedium
                  ?.copyWith(color: colors.textSecondary),
            ),
        ],
      ),
    );
  }
}
