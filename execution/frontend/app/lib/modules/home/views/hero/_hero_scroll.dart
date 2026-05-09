import 'package:flutter/material.dart';
import '../../../../core/theme/e_colors.dart';
import '../../../../core/theme/e_spacing.dart';

class HeroScroll extends StatefulWidget {
  const HeroScroll();

  @override
  State<HeroScroll> createState() => _HeroScrollState();
}

class _HeroScrollState extends State<HeroScroll> with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: const Duration(seconds: 2))..repeat();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          'SCROLL · CH. II',
          style: TextStyle(
            fontFamily: 'JetBrainsMono',
            fontSize: 10.9,
            letterSpacing: 4.48,
            color: EColors.onSurfaceDim,
          ),
        ),
        const SizedBox(height: ESpacing.sm),
        AnimatedBuilder(
          animation: _ctrl,
          builder: (_, _) {
            final v = _ctrl.value;
            final line = Container(width: 1.0, height: 60.0, color: EColors.primary);
            if (v < 0.5) {
              return Transform.scale(scaleY: v * 2, alignment: Alignment.topCenter, child: line);
            } else {
              return Transform.scale(
                scaleY: (1 - v) * 2,
                alignment: Alignment.bottomCenter,
                child: line,
              );
            }
          },
        ),
      ],
    );
  }
}
