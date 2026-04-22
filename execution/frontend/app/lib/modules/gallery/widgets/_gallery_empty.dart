import 'package:flutter/material.dart';
import '../../../core/theme/e_colors.dart';
import '../../../core/theme/e_spacing.dart';
import '../../../core/theme/e_text_styles.dart';
import '../../../core/widgets/shimmer_placeholder.dart';

/// Shown on the homepage when no gallery photos have been uploaded yet.
class GalleryEmpty extends StatelessWidget {
  const GalleryEmpty({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: ESpacing.pagePaddingH,
        vertical: ESpacing.sectionGap,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('GALLERY', style: ETextStyles.overline.copyWith(color: EColors.primary)),
          const SizedBox(height: ESpacing.sm),
          Text('Our Craft', style: ETextStyles.h2),
          const SizedBox(height: ESpacing.xl),
          Row(
            children: List.generate(
              3,
              (i) => Expanded(
                child: Padding(
                  padding: EdgeInsets.only(right: i < 2 ? ESpacing.md : 0),
                  // TODO(image-gen): gallery-card-placeholder
                  child: ShimmerPlaceholder(aspectRatio: 4 / 3, slot: 'gallery-placeholder-$i'),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
