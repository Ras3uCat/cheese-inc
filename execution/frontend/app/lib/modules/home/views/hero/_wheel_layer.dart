import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../../../core/widgets/cursor_overlay.dart';
import '_cheese_wheel_painter.dart';

class WheelLayer extends StatefulWidget {
  const WheelLayer({super.key, required this.scrollPx, required this.viewportHeight});

  final double scrollPx;
  final double viewportHeight;

  @override
  State<WheelLayer> createState() => _WheelLayerState();
}

class _WheelLayerState extends State<WheelLayer> with SingleTickerProviderStateMixin {
  late final AnimationController _rotCtrl;

  static const _kMaxDrift = 20.0;

  @override
  void initState() {
    super.initState();
    _rotCtrl = AnimationController(vsync: this, duration: const Duration(seconds: 60))..repeat();
  }

  @override
  void dispose() {
    _rotCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final clampedOffset = widget.scrollPx.clamp(0.0, widget.viewportHeight);

    return Transform.translate(
      offset: Offset(0, clampedOffset * 0.3),
      child: LayoutBuilder(
        builder: (ctx, constraints) {
          final wheelSize =
              math
                  .min(math.min(constraints.maxWidth, constraints.maxHeight) * 0.62, 620.0)
                  .toDouble();

          // CursorState.position is updated by CursorOverlay at the app root —
          // it receives all pointer events regardless of which widget has the hit.
          return AnimatedBuilder(
            animation: CursorState.position,
            builder: (_, child) {
              final cursor = CursorState.position.value;
              final w = constraints.maxWidth;
              final h = widget.viewportHeight;
              final nx = w > 0 ? ((cursor.dx / w) * 2 - 1).clamp(-1.0, 1.0) : 0.0;
              final ny = h > 0 ? ((cursor.dy / h) * 2 - 1).clamp(-1.0, 1.0) : 0.0;
              return Transform.translate(
                offset: Offset(nx * _kMaxDrift, ny * _kMaxDrift),
                child: child,
              );
            },
            child: Align(
              alignment: Alignment.center,
              child: Opacity(
                opacity: 0.85,
                child: AnimatedBuilder(
                  animation: _rotCtrl,
                  builder:
                      (_, child) =>
                          Transform.rotate(angle: _rotCtrl.value * 2 * math.pi, child: child),
                  child: CustomPaint(
                    size: Size(wheelSize, wheelSize),
                    painter: const CheeseWheelPainter(),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
