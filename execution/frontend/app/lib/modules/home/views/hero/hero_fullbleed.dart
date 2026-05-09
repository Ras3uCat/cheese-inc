import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/theme/e_colors.dart';
import '../../../../core/theme/e_spacing.dart';
import '../../../../core/widgets/ambient_hero_background.dart';
import '../../controllers/home_controller.dart';
import '_hero_badges.dart';
import '_hero_foot.dart';
import '_hero_meta.dart';
import '_hero_tag.dart';
import '_hero_title.dart';
import '_specks_painter.dart';
import '_wheel_layer.dart';

export '_hero_centered.dart';
export '_hero_split.dart';

class HeroFullbleed extends StatelessWidget {
  const HeroFullbleed({super.key});

  Widget _gradientOverlay() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.black.withValues(alpha: 0.3),
            Colors.black.withValues(alpha: 0.65),
          ],
        ),
      ),
    );
  }

  Widget _frameBorder() {
    return Positioned.fill(
      child: IgnorePointer(
        child: LayoutBuilder(
          builder: (ctx, c) {
            final m =
                c.maxWidth <= ESpacing.mobileBreak
                    ? ESpacing.frameSmall
                    : ESpacing.framePad;
            return Padding(
              padding: EdgeInsets.all(m),
              child: DecoratedBox(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: EColors.onSurface.withValues(alpha: 0.12),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final height = size.height;
    final ctrl = Get.find<HomeController>();

    return SizedBox(
      height: height,
      // MouseRegion here (above the Stack) ensures hover events reach it even
      // when SafeArea content absorbs hit tests inside the Stack.
      child: MouseRegion(
        onHover: (e) {
          final nx = ((e.localPosition.dx / size.width) * 2 - 1).clamp(
            -1.0,
            1.0,
          );
          final ny = ((e.localPosition.dy / height) * 2 - 1).clamp(-1.0, 1.0);
          ctrl.heroTilt.value = Offset(nx, ny);
        },
        onExit: (_) => ctrl.heroTilt.value = Offset.zero,
        child: Obx(() {
          final ctrl = Get.find<HomeController>();
          final loaderDone = ctrl.loaderDone.value;
          final scrollPx = ctrl.scrollOffset.value;

          return Stack(
            fit: StackFit.expand,
            clipBehavior: Clip.hardEdge,
            children: [
              const AmbientHeroBackground(),
              CustomPaint(
                painter: SpecksPainter(
                  primary: EColors.primary,
                  secondary: EColors.secondary,
                  accent: EColors.accent,
                ),
                child: const SizedBox.expand(),
              ),
              WheelLayer(scrollPx: scrollPx, viewportHeight: height),
              _gradientOverlay(),
              _frameBorder(),
              SafeArea(
                child: Padding(
                  padding: EdgeInsets.only(
                    top: kToolbarHeight,
                    left: ESpacing.gut(context),
                    right: ESpacing.gut(context),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Spacer(flex: 1),
                      HeroMeta(loaderDone: loaderDone),
                      const Spacer(flex: 2),
                      const HeroTitle(),
                      const Spacer(flex: 2),
                      HeroTag(loaderDone: loaderDone),
                      const Spacer(flex: 4),
                      HeroFoot(loaderDone: loaderDone),
                      const SizedBox(height: 56),
                    ],
                  ),
                ),
              ),
              Positioned(
                left: ESpacing.gut(context),
                bottom: 32.0,
                child: const HeroBadges(),
              ),
            ],
          );
        }),
      ),
    );
  }
}
