import 'dart:math' show pi;
import 'package:flutter/material.dart';
import '../theme/e_colors.dart';
import '../theme/e_spacing.dart';

class SectionDivider extends StatelessWidget {
  const SectionDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: ESpacing.xl),
      child: SizedBox(
        height: 16,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Divider(color: EColors.secondary.withValues(alpha: 0.25), thickness: 1, height: 1),
            Transform.rotate(
              angle: pi / 4,
              child: SizedBox.square(
                dimension: 8,
                child: DecoratedBox(
                  decoration: BoxDecoration(color: EColors.secondary.withValues(alpha: 0.5)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
