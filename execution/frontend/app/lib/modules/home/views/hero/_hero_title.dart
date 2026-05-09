import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/theme/e_colors.dart';
import '../../../../core/theme/e_spacing.dart';
import '../../controllers/home_controller.dart';

class HeroTitle extends StatefulWidget {
  const HeroTitle({super.key});

  @override
  State<HeroTitle> createState() => _HeroTitleState();
}

class _HeroTitleState extends State<HeroTitle> with TickerProviderStateMixin {
  // Trailing space on all but last lets Wrap produce natural inline word spacing
  static const _kWords = ['Taste ', 'the ', 'Collection'];
  static const _kWordDuration = Duration(milliseconds: 1100);
  static const _kStagger = Duration(milliseconds: 40);
  static const _kCurve = Cubic(0.16, 1.0, 0.3, 1.0);

  late final List<AnimationController> _controllers;
  late final List<Animation<Offset>> _slides;
  bool _started = false;

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(
      _kWords.length,
      (_) => AnimationController(vsync: this, duration: _kWordDuration),
    );
    _slides =
        _controllers.map((c) {
          return Tween<Offset>(
            begin: const Offset(0, 1),
            end: Offset.zero,
          ).animate(CurvedAnimation(parent: c, curve: _kCurve));
        }).toList();

    final ctrl = Get.find<HomeController>();
    if (ctrl.loaderDone.value) {
      _startReveal();
    } else {
      ever(ctrl.loaderDone, (done) {
        if (done && !_started) _startReveal();
      });
    }
  }

  void _startReveal() {
    _started = true;
    for (var i = 0; i < _controllers.length; i++) {
      Future.delayed(_kStagger * i, () {
        if (mounted) _controllers[i].forward();
      });
    }
  }

  @override
  void dispose() {
    for (final c in _controllers) {
      c.dispose();
    }
    super.dispose();
  }

  TextStyle _wordStyle(String word, double fontSize) {
    if (word == 'Collection') {
      return TextStyle(
        fontFamily: 'Playfair Display',
        fontStyle: FontStyle.italic,
        fontWeight: FontWeight.w400,
        fontSize: fontSize,
        color: EColors.secondary,
        letterSpacing: fontSize * -0.03,
      );
    }
    return TextStyle(
      fontFamily: 'Playfair Display',
      fontWeight: FontWeight.w900,
      fontSize: fontSize,
      color: EColors.onSurface,
      letterSpacing: fontSize * -0.03,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: ESpacing.gapMeta, horizontal: ESpacing.xs),
      child: LayoutBuilder(
        builder: (ctx, constraints) {
          final fontSize = (constraints.maxWidth * 0.07 + 32).clamp(51.2, 144.0);
          return Wrap(
            alignment: WrapAlignment.center,
            spacing: 0.0,
            runSpacing: 4.0,
            children: List.generate(_kWords.length, (i) {
              return ClipRect(
                clipper: _HorizPadClipper(),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: SlideTransition(
                    position: _slides[i],
                    child: Text(_kWords[i], style: _wordStyle(_kWords[i], fontSize)),
                  ),
                ),
              );
            }),
          );
        },
      ),
    );
  }
}

// Clips only on the vertical axis so the slide reveal works without cutting
// italic/bold glyph overhangs on the left/right edges.
class _HorizPadClipper extends CustomClipper<Rect> {
  @override
  Rect getClip(Size size) => Rect.fromLTWH(-8, 0, size.width + 16, size.height);

  @override
  bool shouldReclip(_HorizPadClipper old) => false;
}
