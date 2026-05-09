import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../../../core/theme/e_colors.dart';

class CheeseWheelPainter extends CustomPainter {
  const CheeseWheelPainter();

  static const double _kWedgeStart = -math.pi / 2; // 12 o'clock
  static const double _kWedgeSweep = 34 * math.pi / 180; // 34 degrees clockwise

  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final cy = size.height / 2;
    final r = math.min(cx, cy) - 4.0;

    _drawPasteFill(canvas, cx, cy, r);
    _drawInteriorRings(canvas, cx, cy, r);
    _drawWedgeCut(canvas, cx, cy, r);
    _drawRindBloom(canvas, cx, cy, r);
    _drawRindDashes(canvas, cx, cy, r);
    _drawTickMarks(canvas, cx, cy, r);
    _drawEyes(canvas, cx, cy, r);
    _drawCrumbs(canvas, cx, cy, r);
    _drawCenterStamp(canvas, cx, cy, r);
    _drawChapterText(canvas, cx, cy, r);
    _drawFloatingSlice(canvas, cx, cy, r);
  }

  void _drawPasteFill(Canvas canvas, double cx, double cy, double r) {
    final rect = Rect.fromCircle(center: Offset(cx, cy), radius: r * 0.9);
    final gradient = RadialGradient(
      center: Alignment.center,
      radius: 1.0,
      colors: [
        EColors.secondary.withValues(alpha: 0.85),
        EColors.parchment.withValues(alpha: 0.75),
        EColors.rind.withValues(alpha: 0.6),
      ],
      stops: const [0.0, 0.6, 1.0],
    );
    canvas.drawCircle(Offset(cx, cy), r * 0.9, Paint()..shader = gradient.createShader(rect));
  }

  void _drawInteriorRings(Canvas canvas, double cx, double cy, double r) {
    final paint =
        Paint()
          ..color = EColors.secondary.withValues(alpha: 0.12)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 0.5;
    for (final ratio in [0.75, 0.54, 0.33]) {
      canvas.drawCircle(Offset(cx, cy), r * ratio, paint);
    }
  }

  void _drawWedgeCut(Canvas canvas, double cx, double cy, double r) {
    final wedgePath =
        Path()
          ..moveTo(cx, cy)
          ..arcTo(
            Rect.fromCircle(center: Offset(cx, cy), radius: r * 0.9),
            _kWedgeStart,
            _kWedgeSweep,
            false,
          )
          ..close();

    canvas.drawPath(
      wedgePath,
      Paint()
        ..color = EColors.surface
        ..style = PaintingStyle.fill,
    );

    // Cut face radial strokes
    final strokePaint =
        Paint()
          ..color = EColors.parchment.withValues(alpha: 0.45)
          ..strokeWidth = 0.8
          ..style = PaintingStyle.stroke;
    const steps = 8;
    for (var i = 0; i <= steps; i++) {
      final angle = _kWedgeStart + (_kWedgeSweep * i / steps);
      canvas.drawLine(
        Offset(cx, cy),
        Offset(cx + math.cos(angle) * r * 0.9, cy + math.sin(angle) * r * 0.9),
        strokePaint,
      );
    }
  }

  void _drawRindBloom(Canvas canvas, double cx, double cy, double r) {
    final rect = Rect.fromCircle(center: Offset(cx, cy), radius: r);
    final gradient = RadialGradient(
      center: Alignment.center,
      radius: 1.0,
      colors: [
        EColors.rind.withValues(alpha: 0.0),
        EColors.rind.withValues(alpha: 0.0),
        EColors.rind.withValues(alpha: 0.9),
      ],
      stops: const [0.0, 0.92, 1.0],
    );
    canvas.drawCircle(Offset(cx, cy), r, Paint()..shader = gradient.createShader(rect));
  }

  void _drawRindDashes(Canvas canvas, double cx, double cy, double r) {
    final dashR = r * 0.975;
    const dashLen = 4.0;
    const dashGap = 4.0;
    final circumference = 2 * math.pi * dashR;
    final totalUnit = dashLen + dashGap;
    final count = (circumference / totalUnit).floor();
    final paint =
        Paint()
          ..color = EColors.onSurface.withValues(alpha: 0.18)
          ..strokeWidth = 1.0
          ..style = PaintingStyle.stroke
          ..strokeCap = StrokeCap.round;

    for (var i = 0; i < count; i++) {
      final startAngle = (i * totalUnit / dashR);
      final endAngle = startAngle + (dashLen / dashR);
      canvas.drawArc(
        Rect.fromCircle(center: Offset(cx, cy), radius: dashR),
        startAngle,
        endAngle - startAngle,
        false,
        paint,
      );
    }
  }

  void _drawTickMarks(Canvas canvas, double cx, double cy, double r) {
    final paint =
        Paint()
          ..color = EColors.rind.withValues(alpha: 0.35)
          ..strokeWidth = 0.8
          ..style = PaintingStyle.stroke;

    const totalTicks = 48;
    for (var i = 0; i < totalTicks; i++) {
      final angle = i * (2 * math.pi / totalTicks);
      final isLong = i % 4 == 0;
      final tickLen = isLong ? r * 0.06 : r * 0.03;
      final inner = r * 0.92;
      final outer = inner + tickLen;
      canvas.drawLine(
        Offset(cx + math.cos(angle) * inner, cy + math.sin(angle) * inner),
        Offset(cx + math.cos(angle) * outer, cy + math.sin(angle) * outer),
        paint,
      );
    }
  }

  // Fixed offsets as fractions of r — avoids Random(), fully deterministic
  static const List<(double, double, double)> _kEyes = [
    (0.22, -0.31, 3.2),
    (-0.38, 0.18, 2.6),
    (0.41, 0.27, 2.0),
    (-0.15, -0.44, 3.5),
    (0.55, -0.10, 2.2),
    (-0.50, -0.25, 2.8),
    (0.10, 0.52, 2.4),
    (-0.30, 0.42, 3.0),
    (0.48, 0.45, 1.8),
    (0.05, -0.58, 2.6),
    (-0.44, 0.55, 2.0),
    (0.62, 0.12, 2.3),
    (-0.20, -0.60, 2.9),
    (0.35, -0.50, 2.1),
  ];

  void _drawEyes(Canvas canvas, double cx, double cy, double r) {
    final paint = Paint()..color = EColors.rind.withValues(alpha: 0.7);
    for (final (dx, dy, er) in _kEyes) {
      canvas.drawOval(
        Rect.fromCenter(center: Offset(cx + dx * r, cy + dy * r), width: er * 2, height: er * 1.3),
        paint,
      );
    }
  }

  void _drawCrumbs(Canvas canvas, double cx, double cy, double r) {
    final paint = Paint()..color = EColors.parchment.withValues(alpha: 0.55);
    const goldenAngle = 137.5 * math.pi / 180;
    for (var i = 0; i < 38; i++) {
      final angle = i * goldenAngle;
      final dist = math.sqrt(i / 38.0) * r * 0.7;
      canvas.drawCircle(
        Offset(cx + math.cos(angle) * dist, cy + math.sin(angle) * dist),
        (i % 3).toDouble() + 1.2,
        paint,
      );
    }
  }

  void _drawCenterStamp(Canvas canvas, double cx, double cy, double r) {
    final outerR = r * 0.14;
    final innerR = r * 0.12;
    final ringPaint =
        Paint()
          ..color = EColors.onSurface.withValues(alpha: 0.55)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 0.8;
    canvas.drawCircle(Offset(cx, cy), outerR, ringPaint);
    canvas.drawCircle(Offset(cx, cy), innerR, ringPaint);

    _paintText(
      canvas,
      'Cheese',
      TextStyle(
        fontFamily: 'Playfair Display',
        fontSize: outerR * 0.55,
        fontStyle: FontStyle.italic,
        color: EColors.onSurface.withValues(alpha: 0.55),
      ),
      Offset(cx, cy - outerR * 0.18),
    );
    _paintText(
      canvas,
      'INC · TAC',
      TextStyle(
        fontFamily: 'JetBrains Mono',
        fontSize: outerR * 0.38,
        color: EColors.onSurface.withValues(alpha: 0.55),
        letterSpacing: 1.0,
      ),
      Offset(cx, cy + outerR * 0.36),
    );
  }

  void _drawChapterText(Canvas canvas, double cx, double cy, double r) {
    const labels = ['01', '02', '03', '04'];
    // 12/3/6/9 o'clock
    final angles = [-math.pi / 2, 0.0, math.pi / 2, math.pi];
    final dist = r * 0.68;

    for (var i = 0; i < 4; i++) {
      final angle = angles[i];
      final x = cx + math.cos(angle) * dist;
      final y = cy + math.sin(angle) * dist;
      _paintText(
        canvas,
        labels[i],
        TextStyle(
          fontFamily: 'JetBrains Mono',
          fontSize: 10.0,
          color: EColors.onSurface.withValues(alpha: 0.4),
          letterSpacing: 1.0,
        ),
        Offset(x, y),
      );
    }
  }

  void _drawFloatingSlice(Canvas canvas, double cx, double cy, double r) {
    final sliceR = r * 0.26;
    const sliceSweep = 34 * math.pi / 180;
    const sliceStart = -math.pi / 2;
    final offsetX = cx + r * 0.78;
    final offsetY = cy - r * 0.58;

    canvas.save();
    canvas.translate(offsetX, offsetY);
    canvas.rotate(0.35);

    final rect = Rect.fromCircle(center: Offset.zero, radius: sliceR);
    final gradient = RadialGradient(
      colors: [EColors.secondary.withValues(alpha: 0.8), EColors.rind.withValues(alpha: 0.6)],
    );
    final slicePath =
        Path()
          ..moveTo(0, 0)
          ..arcTo(rect, sliceStart, sliceSweep, false)
          ..close();

    canvas.drawPath(slicePath, Paint()..shader = gradient.createShader(rect));
    canvas.drawPath(
      slicePath,
      Paint()
        ..color = EColors.rind.withValues(alpha: 0.5)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 0.6,
    );

    canvas.restore();
  }

  void _paintText(Canvas canvas, String text, TextStyle style, Offset center) {
    final tp = TextPainter(
      text: TextSpan(text: text, style: style),
      textDirection: TextDirection.ltr,
    )..layout();
    tp.paint(canvas, center - Offset(tp.width / 2, tp.height / 2));
  }

  @override
  bool shouldRepaint(CheeseWheelPainter _) => false;
}
