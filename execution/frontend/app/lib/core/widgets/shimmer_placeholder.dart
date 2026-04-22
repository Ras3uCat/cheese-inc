import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import '../theme/e_colors.dart';

/// ShimmerPlaceholder — standard loading skeleton for all image slots.
/// Always wrap in [AspectRatio] via [aspectRatio] parameter — never fixed height.
///
/// Usage:
///   // TODO(image-gen): hero-background
///   ShimmerPlaceholder(aspectRatio: 16 / 9, slot: 'hero-background')
class ShimmerPlaceholder extends StatelessWidget {
  const ShimmerPlaceholder({super.key, required this.aspectRatio, required this.slot});

  final double aspectRatio;
  // slot is carried for documentation / image-gen tooling — not rendered.
  final String slot;

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: aspectRatio,
      child: Shimmer.fromColors(
        baseColor: EColors.surface,
        highlightColor: EColors.surfaceAlt,
        child: Container(color: EColors.surface),
      ),
    );
  }
}
