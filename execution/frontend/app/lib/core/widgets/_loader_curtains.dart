import 'package:flutter/material.dart';
import '../theme/e_colors.dart';

class LoaderCurtains extends StatelessWidget {
  const LoaderCurtains({super.key, required this.topAnimation, required this.bottomAnimation});

  final Animation<Offset> topAnimation;
  final Animation<Offset> bottomAnimation;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final halfH = size.height / 2;

    return Stack(
      children: [
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: SlideTransition(
            position: topAnimation,
            child: SizedBox(height: halfH, child: ColoredBox(color: EColors.surface)),
          ),
        ),
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: SlideTransition(
            position: bottomAnimation,
            child: SizedBox(height: halfH, child: ColoredBox(color: EColors.surface)),
          ),
        ),
      ],
    );
  }
}
