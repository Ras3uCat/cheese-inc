import 'dart:math' as math;
import 'package:flutter/material.dart';

class SpecksPainter extends CustomPainter {
  const SpecksPainter({required this.primary, required this.secondary, required this.accent});

  final Color primary;
  final Color secondary;
  final Color accent;

  static const int _kCount = 150;
  static const int _kSeed = 42;

  @override
  void paint(Canvas canvas, Size size) {
    final rng = math.Random(_kSeed);
    final colors = [primary, secondary, accent];

    for (var i = 0; i < _kCount; i++) {
      final x = rng.nextDouble() * size.width;
      final y = rng.nextDouble() * size.height;
      final radius = rng.nextDouble() * 3.0 + 2.0; // 2–5 px
      final opacity = rng.nextDouble() * 0.45 + 0.15;
      final color = colors[rng.nextInt(3)];

      canvas.drawCircle(Offset(x, y), radius, Paint()..color = color.withValues(alpha: opacity));
    }
  }

  @override
  bool shouldRepaint(SpecksPainter _) => false;
}
