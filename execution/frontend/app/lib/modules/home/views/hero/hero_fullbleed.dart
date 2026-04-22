import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/theme/e_colors.dart';
import '../../../../core/theme/e_spacing.dart';
import '../../../../core/theme/e_text_styles.dart';
import '../../../../core/theme/personality_theme.dart';
import '../../../../core/widgets/ambient_hero_background.dart';
import '../../../../core/widgets/text_reveal.dart';
import '../../controllers/home_controller.dart';
import '_hero_cta.dart';

export '_hero_centered.dart';
export '_hero_split.dart';

const _kHeroLocalAsset = 'assets/images/hero_background.jpg';

class HeroFullbleed extends StatefulWidget {
  const HeroFullbleed({super.key});

  @override
  State<HeroFullbleed> createState() => _HeroFullbleedState();
}

class _HeroFullbleedState extends State<HeroFullbleed> {
  static const _kEnterDuration = Duration(milliseconds: 700);
  static const _kEnterCurve = Curves.easeOut;
  static const _kSlideOffset = Offset(0, 0.06);
  static const _kStaggerStep = Duration(milliseconds: 150);

  bool _overlineVisible = false;
  bool _titleVisible = false;
  bool _taglineVisible = false;
  bool _ctaVisible = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _startStagger());
  }

  void _startStagger() {
    Future.delayed(Duration.zero, () {
      if (mounted) setState(() => _overlineVisible = true);
    });
    Future.delayed(_kStaggerStep, () {
      if (mounted) setState(() => _titleVisible = true);
    });
    Future.delayed(_kStaggerStep * 2, () {
      if (mounted) setState(() => _taglineVisible = true);
    });
    Future.delayed(_kStaggerStep * 3, () {
      if (mounted) setState(() => _ctaVisible = true);
    });
  }

  Widget _animated({required bool visible, required Widget child}) {
    return AnimatedSlide(
      offset: visible ? Offset.zero : _kSlideOffset,
      duration: _kEnterDuration,
      curve: _kEnterCurve,
      child: AnimatedOpacity(
        opacity: visible ? 1.0 : 0.0,
        duration: _kEnterDuration,
        curve: _kEnterCurve,
        child: child,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final pt = PersonalityTheme.fromEnv();
    final height = MediaQuery.of(context).size.height;

    return SizedBox(
      height: height,
      child: Obx(() {
        final ctrl = Get.find<HomeController>();
        final imageUrl = ctrl.heroImageUrl.isEmpty ? null : ctrl.heroImageUrl;
        final overline = ctrl.heroOverline;
        final tagline = ctrl.heroTagline;
        final scrollPx = ctrl.scrollOffset.value;

        return Stack(
          fit: StackFit.expand,
          clipBehavior: Clip.hardEdge,
          children: [
            const AmbientHeroBackground(),
            Positioned(
              top: -100,
              bottom: -100,
              left: 0,
              right: 0,
              child: Transform.translate(
                offset: Offset(0, scrollPx * 0.35),
                child: RepaintBoundary(
                  child:
                      imageUrl != null && imageUrl.isNotEmpty
                          ? CachedNetworkImage(
                            imageUrl: imageUrl,
                            fit: BoxFit.cover,
                            width: double.infinity,
                            height: double.infinity,
                            placeholder:
                                (_, _) => Image.asset(
                                  _kHeroLocalAsset,
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                  height: double.infinity,
                                ),
                            errorWidget:
                                (_, _, _) => Image.asset(
                                  _kHeroLocalAsset,
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                  height: double.infinity,
                                ),
                          )
                          : Image.asset(
                            _kHeroLocalAsset,
                            fit: BoxFit.cover,
                            width: double.infinity,
                            height: double.infinity,
                          ),
                ),
              ),
            ),
            Container(
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
            ),
            Transform.translate(
              offset: Offset(0, scrollPx * 0.12),
              child: RepaintBoundary(
                child: Center(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(maxWidth: pt.heroContentMaxWidth),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: ESpacing.pagePaddingH),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment:
                            pt.heroTextAlign == TextAlign.left
                                ? CrossAxisAlignment.start
                                : CrossAxisAlignment.center,
                        children: [
                          if (overline.isNotEmpty)
                            _animated(
                              visible: _overlineVisible,
                              child: Padding(
                                padding: const EdgeInsets.only(bottom: ESpacing.md),
                                child: _OverlinePill(
                                  label: overline.toUpperCase(),
                                  align: pt.heroTextAlign,
                                ),
                              ),
                            ),
                          TextReveal(
                            text: ctrl.heroTitle,
                            style: ETextStyles.displayXL.copyWith(color: Colors.white),
                            textAlign: pt.heroTextAlign,
                            trigger: _titleVisible,
                          ),
                          if (tagline.isNotEmpty) ...[
                            const SizedBox(height: ESpacing.lg),
                            _animated(
                              visible: _taglineVisible,
                              child: Text(
                                tagline,
                                style: ETextStyles.bodyLg.copyWith(color: Colors.white70),
                                textAlign: pt.heroTextAlign,
                              ),
                            ),
                          ],
                          const SizedBox(height: ESpacing.xxl),
                          _animated(visible: _ctaVisible, child: HeroCta(pt: pt)),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const Positioned(
              bottom: ESpacing.xl,
              left: 0,
              right: 0,
              child: _PulsingScrollIndicator(),
            ),
          ],
        );
      }),
    );
  }
}

class _OverlinePill extends StatelessWidget {
  const _OverlinePill({required this.label, required this.align});

  final String label;
  final TextAlign align;

  @override
  Widget build(BuildContext context) {
    final pill = Container(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 5.0),
      decoration: BoxDecoration(
        color: EColors.accent.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: EColors.accent, width: 0.5),
      ),
      child: Text(label, style: ETextStyles.overline.copyWith(color: EColors.accent)),
    );

    if (align == TextAlign.left) return pill;
    return Row(mainAxisAlignment: MainAxisAlignment.center, children: [pill]);
  }
}

class _PulsingScrollIndicator extends StatefulWidget {
  const _PulsingScrollIndicator();

  @override
  State<_PulsingScrollIndicator> createState() => _PulsingScrollIndicatorState();
}

class _PulsingScrollIndicatorState extends State<_PulsingScrollIndicator>
    with SingleTickerProviderStateMixin {
  static const _kPulseDuration = Duration(milliseconds: 1800);
  static const _kMinOpacity = 0.3;
  static const _kMaxOpacity = 0.8;

  late final AnimationController _ctrl;
  late final Animation<double> _opacity;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: _kPulseDuration)..repeat(reverse: true);
    _opacity = Tween<double>(
      begin: _kMinOpacity,
      end: _kMaxOpacity,
    ).animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _opacity,
      builder:
          (_, _) => Icon(
            Icons.keyboard_arrow_down,
            color: Colors.white.withValues(alpha: _opacity.value),
            size: 32,
          ),
    );
  }
}
