import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../modules/home/views/hero/_cheese_wheel_painter.dart';
import '../theme/e_colors.dart';
import '../theme/e_spacing.dart';
import '../theme/e_text_styles.dart';

class LoaderCenter extends StatelessWidget {
  const LoaderCenter({
    super.key,
    required this.wheelEntrance,
    required this.wheelRotation,
    required this.arcProgress,
    required this.titleOpacity,
    required this.titleLetterSpacing,
    required this.subtitleOpacity,
  });

  final Animation<double> wheelEntrance;
  final Animation<double> wheelRotation;
  final Animation<double> arcProgress;
  final Animation<double> titleOpacity;
  final Animation<double> titleLetterSpacing;
  final Animation<double> subtitleOpacity;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _WheelWithArc(entrance: wheelEntrance, rotation: wheelRotation, arcProgress: arcProgress),
        SizedBox(height: ESpacing.lg),
        AnimatedBuilder(
          animation: Listenable.merge([titleOpacity, titleLetterSpacing]),
          builder: (_, _) {
            return Opacity(
              opacity: titleOpacity.value,
              child: _TitleText(letterSpacing: titleLetterSpacing.value),
            );
          },
        ),
        SizedBox(height: ESpacing.sm),
        AnimatedBuilder(
          animation: subtitleOpacity,
          builder:
              (_, _) => Opacity(
                opacity: subtitleOpacity.value,
                child: Text(
                  'AGING THE COLLECTION · PLEASE WAIT',
                  style: ETextStyles.eyebrow,
                  textAlign: TextAlign.center,
                ),
              ),
        ),
      ],
    );
  }
}

class _WheelWithArc extends StatelessWidget {
  const _WheelWithArc({required this.entrance, required this.rotation, required this.arcProgress});

  final Animation<double> entrance;
  final Animation<double> rotation;
  final Animation<double> arcProgress;

  static const double _size = 140;
  static const double _arcStroke = 2;
  static const double _arcPad = 6;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([entrance, rotation, arcProgress]),
      builder: (_, _) {
        return Opacity(
          opacity: entrance.value,
          child: Transform.scale(
            scale: 0.8 + entrance.value * 0.2,
            child: SizedBox(
              width: _size + (_arcPad + _arcStroke) * 2,
              height: _size + (_arcPad + _arcStroke) * 2,
              child: CustomPaint(
                painter: _ArcPainter(progress: arcProgress.value),
                child: Padding(
                  padding: EdgeInsets.all(_arcPad + _arcStroke),
                  child: Transform.rotate(
                    angle: rotation.value * 2 * math.pi,
                    child: const CustomPaint(
                      size: Size.square(_size),
                      painter: CheeseWheelPainter(),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _ArcPainter extends CustomPainter {
  const _ArcPainter({required this.progress});

  final double progress;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 4;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -math.pi / 2,
      progress * 2 * math.pi,
      false,
      Paint()
        ..color = EColors.primary
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2
        ..strokeCap = StrokeCap.round,
    );
  }

  @override
  bool shouldRepaint(_ArcPainter old) => progress != old.progress;
}

class _TitleText extends StatelessWidget {
  const _TitleText({required this.letterSpacing});

  final double letterSpacing;

  @override
  Widget build(BuildContext context) {
    final baseStyle = ETextStyles.displayLg.copyWith(letterSpacing: letterSpacing);
    return Text.rich(
      TextSpan(
        children: [
          TextSpan(text: 'Cheese ', style: baseStyle),
          TextSpan(text: '& ', style: baseStyle.copyWith(color: EColors.primary)),
          TextSpan(text: 'Inc.', style: baseStyle),
        ],
      ),
      textAlign: TextAlign.center,
    );
  }
}
