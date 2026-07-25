import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:my_portfolio/presentation/resources/resources.dart';

/// Ambient background: a few large, softly-glowing blobs that drift slowly
/// behind the page content. Uses radial gradients (no backdrop blur) so it
/// stays cheap on the web canvas.
class AnimatedBackground extends StatefulWidget {
  const AnimatedBackground({super.key, required this.child});

  final Widget child;

  @override
  State<AnimatedBackground> createState() => _AnimatedBackgroundState();
}

class _AnimatedBackgroundState extends State<AnimatedBackground>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 24),
  )..repeat();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final reduceMotion = MediaQuery.maybeOf(context)?.disableAnimations ?? false;

    final blobs = [
      _Blob(color: context.colors.accent, base: const Alignment(-0.9, -0.85), size: 520, opacity: colors.isDark ? 0.16 : 0.10, phase: 0),
      _Blob(color: context.colors.secondary, base: const Alignment(1.0, -0.3), size: 460, opacity: colors.isDark ? 0.12 : 0.08, phase: 1.6),
      _Blob(color: colors.secondary, base: const Alignment(0.2, 1.0), size: 500, opacity: colors.isDark ? 0.10 : 0.06, phase: 3.1),
    ];

    return Stack(
      children: [
        Positioned.fill(
          child: RepaintBoundary(
            child: AnimatedBuilder(
              animation: _controller,
              builder: (context, _) {
                final t = reduceMotion ? 0.0 : _controller.value * 2 * math.pi;
                return Stack(
                  children: [
                    for (final blob in blobs) _buildBlob(blob, t),
                  ],
                );
              },
            ),
          ),
        ),
        widget.child,
      ],
    );
  }

  Widget _buildBlob(_Blob blob, double t) {
    final dx = math.sin(t + blob.phase) * 0.12;
    final dy = math.cos(t * 0.8 + blob.phase) * 0.12;
    return Align(
      alignment: Alignment(blob.base.x + dx, blob.base.y + dy),
      child: IgnorePointer(
        child: Container(
          width: blob.size,
          height: blob.size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: RadialGradient(
              colors: [
                blob.color.withValues(alpha: blob.opacity),
                blob.color.withValues(alpha: 0),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Blob {
  const _Blob({
    required this.color,
    required this.base,
    required this.size,
    required this.opacity,
    required this.phase,
  });

  final Color color;
  final Alignment base;
  final double size;
  final double opacity;
  final double phase;
}
