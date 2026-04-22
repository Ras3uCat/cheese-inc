import 'package:flutter/material.dart';
import 'package:visibility_detector/visibility_detector.dart';

class RevealOnScroll extends StatefulWidget {
  const RevealOnScroll({super.key, required this.child, this.delay = Duration.zero});

  final Widget child;
  final Duration delay;

  @override
  State<RevealOnScroll> createState() => _RevealOnScrollState();
}

class _RevealOnScrollState extends State<RevealOnScroll> {
  static const _kThreshold = 0.12;
  static const _kDuration = Duration(milliseconds: 550);
  static const _kCurve = Curves.easeOut;
  static const _kSlideOffset = Offset(0, 0.06);

  final _detectorKey = UniqueKey();
  bool _visible = false;
  bool _triggered = false;

  void _onVisibilityChanged(VisibilityInfo info) {
    if (_triggered || info.visibleFraction < _kThreshold) return;
    _triggered = true;

    Future.delayed(widget.delay, () {
      if (mounted) setState(() => _visible = true);
    });
  }

  @override
  Widget build(BuildContext context) {
    return VisibilityDetector(
      key: _detectorKey,
      onVisibilityChanged: _onVisibilityChanged,
      child: AnimatedSlide(
        offset: _visible ? Offset.zero : _kSlideOffset,
        duration: _kDuration,
        curve: _kCurve,
        child: AnimatedOpacity(
          opacity: _visible ? 1.0 : 0.0,
          duration: _kDuration,
          curve: _kCurve,
          child: widget.child,
        ),
      ),
    );
  }
}
