import 'package:flutter/material.dart';
import '../theme/e_colors.dart';
import '../theme/e_spacing.dart';
import '../theme/e_text_styles.dart';
import '_loader_center.dart';
import '_loader_curtains.dart';

class AppLoader extends StatefulWidget {
  const AppLoader({super.key, this.onComplete, this.onDismiss});

  final VoidCallback? onComplete;
  final VoidCallback? onDismiss;

  @override
  State<AppLoader> createState() => _AppLoaderState();
}

class _AppLoaderState extends State<AppLoader> with TickerProviderStateMixin {
  late final AnimationController _progressCtrl;
  late final AnimationController _wheelRotCtrl;
  late final AnimationController _exitCtrl;

  late final Animation<double> _wheelEntrance;
  late final Animation<double> _arcProgress;
  late final Animation<double> _titleOpacity;
  late final Animation<double> _titleLetterSpacing;
  late final Animation<double> _subtitleOpacity;

  late final Animation<double> _gridOpacity;
  late final Animation<double> _bgOpacity;
  late final Animation<Offset> _topCurtain;
  late final Animation<Offset> _bottomCurtain;

  double _counterValue = 0;
  bool _exiting = false;

  static const _easeOutQuint = _EaseOutQuint();
  static const _curtainCurve = Cubic(0.76, 0, 0.24, 1);
  static const _titleCurve = Cubic(0.16, 1, 0.3, 1);

  @override
  void initState() {
    super.initState();

    _progressCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 2200));

    _wheelRotCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 20000))
      ..repeat();

    _exitCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 1400));

    _wheelEntrance = CurvedAnimation(
      parent: _progressCtrl,
      curve: const Interval(200 / 2200, (200 + 800) / 2200, curve: Curves.easeOut),
    );

    _arcProgress = _progressCtrl.drive(CurveTween(curve: _easeOutQuint));

    _titleOpacity = CurvedAnimation(
      parent: _progressCtrl,
      curve: Interval(500 / 2200, (500 + 1000) / 2200, curve: _titleCurve),
    );

    _titleLetterSpacing = Tween<double>(begin: 8.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _progressCtrl,
        curve: Interval(500 / 2200, (500 + 1000) / 2200, curve: _titleCurve),
      ),
    );

    _subtitleOpacity = CurvedAnimation(
      parent: _progressCtrl,
      curve: Interval(1000 / 2200, (1000 + 600) / 2200, curve: Curves.easeOut),
    );

    _gridOpacity = Tween<double>(begin: 1, end: 0).animate(
      CurvedAnimation(
        parent: _exitCtrl,
        curve: const Interval(0, 400 / 1400, curve: Curves.easeOut),
      ),
    );

    _bgOpacity = Tween<double>(begin: 1, end: 0).animate(
      CurvedAnimation(
        parent: _exitCtrl,
        curve: const Interval(0, 600 / 1400, curve: Curves.easeOut),
      ),
    );

    _topCurtain = Tween<Offset>(begin: Offset.zero, end: const Offset(0, -1)).animate(
      CurvedAnimation(parent: _exitCtrl, curve: Interval(0, 1100 / 1400, curve: _curtainCurve)),
    );

    _bottomCurtain = Tween<Offset>(begin: Offset.zero, end: const Offset(0, 1)).animate(
      CurvedAnimation(parent: _exitCtrl, curve: Interval(0, 1100 / 1400, curve: _curtainCurve)),
    );

    _progressCtrl.addListener(() {
      if (mounted) {
        setState(() {
          _counterValue = _easeOutQuint.transform(_progressCtrl.value);
        });
      }
    });

    _progressCtrl.addStatusListener((status) {
      if (status == AnimationStatus.completed && !_exiting) {
        _beginExit();
      }
    });

    Future.delayed(const Duration(milliseconds: 200), () {
      if (mounted) _progressCtrl.forward();
    });
  }

  void _beginExit() {
    _exiting = true;
    Future.delayed(const Duration(milliseconds: 400), () {
      if (!mounted) return;
      widget.onComplete?.call();
      _exitCtrl.forward();
      Future.delayed(const Duration(milliseconds: 1400), () {
        if (mounted) widget.onDismiss?.call();
      });
    });
  }

  @override
  void dispose() {
    _progressCtrl.dispose();
    _wheelRotCtrl.dispose();
    _exitCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([_exitCtrl, _progressCtrl]),
      builder: (context, _) {
        return Stack(
          fit: StackFit.expand,
          children: [
            Opacity(opacity: _bgOpacity.value, child: ColoredBox(color: EColors.surface)),
            Opacity(
              opacity: _gridOpacity.value,
              child: _LoaderGrid(
                counterValue: _counterValue,
                wheelEntrance: _wheelEntrance,
                wheelRotation: _wheelRotCtrl,
                arcProgress: _arcProgress,
                titleOpacity: _titleOpacity,
                titleLetterSpacing: _titleLetterSpacing,
                subtitleOpacity: _subtitleOpacity,
              ),
            ),
            LoaderCurtains(topAnimation: _topCurtain, bottomAnimation: _bottomCurtain),
          ],
        );
      },
    );
  }
}

class _LoaderGrid extends StatelessWidget {
  const _LoaderGrid({
    required this.counterValue,
    required this.wheelEntrance,
    required this.wheelRotation,
    required this.arcProgress,
    required this.titleOpacity,
    required this.titleLetterSpacing,
    required this.subtitleOpacity,
  });

  final double counterValue;
  final Animation<double> wheelEntrance;
  final Animation<double> wheelRotation;
  final Animation<double> arcProgress;
  final Animation<double> titleOpacity;
  final Animation<double> titleLetterSpacing;
  final Animation<double> subtitleOpacity;

  @override
  Widget build(BuildContext context) {
    final pct = (counterValue * 100).round().clamp(0, 100);
    final pctStr = pct.toString().padLeft(3, '0');

    return Padding(
      padding: const EdgeInsets.all(ESpacing.lg),
      child: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            child: _CornerLabel(lines: const ['EST. 2019', 'TACOMA, WA']),
          ),
          Positioned(
            top: 0,
            right: 0,
            child: _CornerLabel(lines: const ['47.2529° N', '122.4443° W'], align: TextAlign.right),
          ),
          Positioned(bottom: 0, left: 0, child: _CornerLabel(lines: ['$pctStr%'])),
          Positioned(
            bottom: 0,
            right: 0,
            child: _CornerLabel(lines: const ['LOT 014 — 2026'], align: TextAlign.right),
          ),
          Center(
            child: LoaderCenter(
              wheelEntrance: wheelEntrance,
              wheelRotation: wheelRotation,
              arcProgress: arcProgress,
              titleOpacity: titleOpacity,
              titleLetterSpacing: titleLetterSpacing,
              subtitleOpacity: subtitleOpacity,
            ),
          ),
        ],
      ),
    );
  }
}

class _CornerLabel extends StatelessWidget {
  const _CornerLabel({required this.lines, this.align = TextAlign.left});

  final List<String> lines;
  final TextAlign align;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment:
          align == TextAlign.right ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: lines.map((l) => Text(l, style: ETextStyles.eyebrow, textAlign: align)).toList(),
    );
  }
}

class _EaseOutQuint extends Curve {
  const _EaseOutQuint();

  @override
  double transformInternal(double t) {
    final v = 1 - t;
    return 1 - v * v * v * v * v;
  }
}
