import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../theme/e_colors.dart';

class AmbientHeroBackground extends StatefulWidget {
  const AmbientHeroBackground({super.key});

  @override
  State<AmbientHeroBackground> createState() => _AmbientHeroBackgroundState();
}

class _AmbientHeroBackgroundState extends State<AmbientHeroBackground>
    with SingleTickerProviderStateMixin {
  static const _kLoopDuration = Duration(seconds: 9);

  late final AnimationController _ctrl;
  late final Animation<double> _tween;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: _kLoopDuration)..repeat(reverse: true);
    _tween = CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut);
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  static Color get _surfaceLighter {
    final base = EColors.surface;
    return Color.fromARGB(
      (base.a * 255).round(),
      (base.r * 255 + 18).clamp(0, 255).toInt(),
      (base.g * 255 + 12).clamp(0, 255).toInt(),
      (base.b * 255 + 8).clamp(0, 255).toInt(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        AnimatedBuilder(
          animation: _tween,
          builder: (_, _) {
            final t = _tween.value;
            final topStop = Color.lerp(EColors.surface, _surfaceLighter, t)!;
            final bottomStop = Color.lerp(_surfaceLighter, EColors.surface, t)!;

            return DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [topStop, bottomStop],
                ),
              ),
            );
          },
        ),
        const CustomPaint(painter: _NoisePainter(), size: Size.infinite),
      ],
    );
  }
}

class _NoisePainter extends CustomPainter {
  const _NoisePainter();

  static const int _kSeed = 42;
  static const int _kCount = 2500;
  static const double _kRadius = 0.7;
  static const double _kOpacity = 0.035;

  @override
  void paint(Canvas canvas, Size size) {
    final rng = math.Random(_kSeed);
    final paint =
        Paint()
          ..color = Colors.white.withValues(alpha: _kOpacity)
          ..style = PaintingStyle.fill;

    for (var i = 0; i < _kCount; i++) {
      final x = rng.nextDouble() * size.width;
      final y = rng.nextDouble() * size.height;
      canvas.drawCircle(Offset(x, y), _kRadius, paint);
    }
  }

  @override
  bool shouldRepaint(_NoisePainter oldDelegate) => false;
}
