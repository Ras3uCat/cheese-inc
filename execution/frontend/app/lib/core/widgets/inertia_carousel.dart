import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import '../theme/e_colors.dart';
import '../theme/e_spacing.dart';

/// InertiaCarousel — horizontally scrolling carousel with momentum/inertia feel.
/// Used for gallery on mobile (<600px). Items are passed as widgets.
/// Duration law: 350ms easeOutCubic per snap.
class InertiaCarousel extends StatefulWidget {
  const InertiaCarousel({
    super.key,
    required this.itemCount,
    required this.itemBuilder,
    this.itemWidth = 280,
    this.gap = ESpacing.xs,
  });

  final int itemCount;
  final Widget Function(BuildContext context, int index) itemBuilder;
  final double itemWidth;
  final double gap;

  @override
  State<InertiaCarousel> createState() => _InertiaCarouselState();
}

class _InertiaCarouselState extends State<InertiaCarousel> {
  late ScrollController _controller;
  int _current = 0;

  @override
  void initState() {
    super.initState();
    _controller = ScrollController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _snapTo(int index) {
    final clamped = index.clamp(0, widget.itemCount - 1);
    setState(() => _current = clamped);
    final offset = clamped * (widget.itemWidth + widget.gap);
    _controller.animateTo(
      offset,
      duration: const Duration(milliseconds: 350),
      curve: Curves.easeOutCubic,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          height: widget.itemWidth, // square items
          child: ScrollConfiguration(
            behavior: _NoOverscroll(),
            child: ListView.separated(
              controller: _controller,
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: ESpacing.pagePaddingH),
              itemCount: widget.itemCount,
              separatorBuilder: (_, _) => SizedBox(width: widget.gap),
              itemBuilder:
                  (ctx, i) => GestureDetector(
                    onTap: () => _snapTo(i),
                    child: SizedBox(width: widget.itemWidth, child: widget.itemBuilder(ctx, i)),
                  ),
            ),
          ),
        ),
        const SizedBox(height: ESpacing.md),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(widget.itemCount, (i) {
            return GestureDetector(
              onTap: () => _snapTo(i),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                curve: Curves.easeOutCubic,
                margin: const EdgeInsets.symmetric(horizontal: 3),
                width: _current == i ? 20 : 6,
                height: 6,
                decoration: BoxDecoration(
                  color: _current == i ? EColors.primary : EColors.divider,
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
            );
          }),
        ),
      ],
    );
  }
}

class _NoOverscroll extends ScrollBehavior {
  @override
  Widget buildOverscrollIndicator(BuildContext context, Widget child, ScrollableDetails details) =>
      child;

  @override
  Set<PointerDeviceKind> get dragDevices => {
    PointerDeviceKind.touch,
    PointerDeviceKind.mouse,
    PointerDeviceKind.stylus,
  };
}
