import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/theme/e_colors.dart';
import '../../../core/theme/e_spacing.dart';
import '../../../core/theme/e_text_styles.dart';
import '../controllers/testimonials_controller.dart';
import '../models/testimonial_model.dart';
import '../../home/views/sections/section_shared_widgets.dart';

const _kDemoTestimonials = [
  TestimonialModel(
    id: 'demo-1',
    author: 'Margaret H.',
    role: 'Regular Customer',
    quote:
        'The aged cheddar is the best I have ever tasted. I drive 40 minutes just to pick some up every week.',
    rating: 5,
    displayOrder: 0,
    isActive: true,
  ),
  TestimonialModel(
    id: 'demo-2',
    author: 'James T.',
    role: 'Cheese Board Enthusiast',
    quote:
        'They built us a board for our wedding. Guests are still talking about it six months later.',
    rating: 5,
    displayOrder: 1,
    isActive: true,
  ),
  TestimonialModel(
    id: 'demo-3',
    author: 'Sofia R.',
    role: 'Workshop Graduate',
    quote:
        'The cheesemaking class was a revelation. I had no idea fresh mozzarella could be this easy — or this good.',
    rating: 5,
    displayOrder: 2,
    isActive: true,
  ),
];

/// Embeddable testimonials section — for use on home page or /testimonials.
/// Requires TestimonialsController to be registered.
class TestimonialsSection extends GetView<TestimonialsController> {
  const TestimonialsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.sizeOf(context).width >= ESpacing.tabletBreak;

    return Obx(() {
      if (controller.isLoading.value) {
        return const SizedBox(height: 120, child: Center(child: CircularProgressIndicator()));
      }
      final items = controller.testimonials.isEmpty ? _kDemoTestimonials : controller.testimonials;

      return Container(
        color: EColors.surface,
        padding: EdgeInsets.symmetric(
          horizontal: isDesktop ? ESpacing.pagePaddingHDesktop : ESpacing.pagePaddingH,
          vertical: ESpacing.sectionGap,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            OrnamentalHeader(title: 'Testimonials'),
            const SizedBox(height: ESpacing.xxl),
            if (isDesktop)
              _DesktopThreeCol(items: items.take(3).toList())
            else
              _MobileStack(items: items.take(3).toList()),
          ],
        ),
      );
    });
  }
}

// ─── Desktop: 3-col with vertical dividers ────────────────────────────────────

class _DesktopThreeCol extends StatelessWidget {
  const _DesktopThreeCol({required this.items});
  final List<TestimonialModel> items;

  @override
  Widget build(BuildContext context) {
    final cols = <Widget>[];
    for (var i = 0; i < items.length; i++) {
      cols.add(Expanded(child: _QuoteBlock(item: items[i])));
      if (i < items.length - 1) {
        cols.add(
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: ESpacing.lg),
            child: VerticalDivider(color: EColors.divider, thickness: 1, width: 1),
          ),
        );
      }
    }
    return IntrinsicHeight(
      child: Row(crossAxisAlignment: CrossAxisAlignment.stretch, children: cols),
    );
  }
}

// ─── Mobile: stacked with horizontal dividers ─────────────────────────────────

class _MobileStack extends StatelessWidget {
  const _MobileStack({required this.items});
  final List<TestimonialModel> items;

  @override
  Widget build(BuildContext context) {
    final rows = <Widget>[];
    for (var i = 0; i < items.length; i++) {
      rows.add(_QuoteBlock(item: items[i]));
      if (i < items.length - 1) {
        rows.add(
          Padding(
            padding: const EdgeInsets.symmetric(vertical: ESpacing.lg),
            child: Divider(color: EColors.divider, thickness: 1, height: 1),
          ),
        );
      }
    }
    return Column(children: rows);
  }
}

// ─── Individual quote ─────────────────────────────────────────────────────────

class _QuoteBlock extends StatelessWidget {
  const _QuoteBlock({required this.item});
  final TestimonialModel item;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '"${item.quote}"',
          style: ETextStyles.bodyLg.copyWith(
            color: EColors.onSurfaceMuted,
            fontStyle: FontStyle.italic,
          ),
        ),
        const SizedBox(height: ESpacing.md),
        Text(item.author, style: ETextStyles.label.copyWith(color: EColors.onSurface)),
        if (item.role != null)
          Text(item.role!, style: ETextStyles.caption.copyWith(color: EColors.onSurfaceMuted)),
      ],
    );
  }
}
