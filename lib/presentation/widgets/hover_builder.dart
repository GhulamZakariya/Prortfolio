import 'package:flutter/material.dart';

/// Rebuilds its [builder] with the current pointer-hover state.
///
/// Uses a [ValueNotifier] + [ValueListenableBuilder] (no `setState`) so only the
/// hover-dependent subtree rebuilds — keeps micro-interactions cheap and DRY.
class HoverBuilder extends StatefulWidget {
  const HoverBuilder({
    super.key,
    required this.builder,
    this.cursor = SystemMouseCursors.click,
    this.onTap,
  });

  final Widget Function(BuildContext context, bool hovering) builder;
  final MouseCursor cursor;
  final VoidCallback? onTap;

  @override
  State<HoverBuilder> createState() => _HoverBuilderState();
}

class _HoverBuilderState extends State<HoverBuilder> {
  final ValueNotifier<bool> _hovering = ValueNotifier<bool>(false);

  @override
  void dispose() {
    _hovering.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final child = MouseRegion(
      cursor: widget.cursor,
      onEnter: (_) => _hovering.value = true,
      onExit: (_) => _hovering.value = false,
      child: ValueListenableBuilder<bool>(
        valueListenable: _hovering,
        builder: (context, hovering, _) => widget.builder(context, hovering),
      ),
    );
    if (widget.onTap == null) return child;
    return GestureDetector(onTap: widget.onTap, child: child);
  }
}
