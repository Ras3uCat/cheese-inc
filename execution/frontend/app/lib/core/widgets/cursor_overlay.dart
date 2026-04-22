import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart' show Ticker;
import '../theme/e_colors.dart';

class CursorOverlay extends StatefulWidget {
  const CursorOverlay({super.key, required this.child});
  final Widget child;

  @override
  State<CursorOverlay> createState() => _CursorOverlayState();
}

class _CursorOverlayState extends State<CursorOverlay> with SingleTickerProviderStateMixin {
  static const _kLerpFactor = 0.15;
  static const _kMinDelta = 0.1;

  final _cursorPos = ValueNotifier<Offset>(Offset.zero);
  final _ringPos = ValueNotifier<Offset>(Offset.zero);
  late final Ticker _ticker;

  @override
  void initState() {
    super.initState();
    _ticker = createTicker((_) {
      final next = Offset.lerp(_ringPos.value, _cursorPos.value, _kLerpFactor)!;
      if ((next - _ringPos.value).distance > _kMinDelta) {
        _ringPos.value = next;
      }
    });
    _ticker.start();
  }

  @override
  void dispose() {
    _ticker.dispose();
    _cursorPos.dispose();
    _ringPos.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!kIsWeb) return widget.child;

    return MouseRegion(
      cursor: SystemMouseCursors.none,
      onHover: (event) => _cursorPos.value = event.position,
      child: Stack(
        children: [
          widget.child,
          IgnorePointer(
            child: RepaintBoundary(
              child: CustomPaint(
                painter: _CursorPainter(
                  cursorPos: _cursorPos,
                  ringPos: _ringPos,
                  dotColor: EColors.accent,
                  ringColor: EColors.accent.withValues(alpha: 0.6),
                ),
                child: const SizedBox.expand(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CursorPainter extends CustomPainter {
  _CursorPainter({
    required this.cursorPos,
    required this.ringPos,
    required this.dotColor,
    required this.ringColor,
  }) : super(repaint: Listenable.merge([cursorPos, ringPos]));

  final ValueNotifier<Offset> cursorPos;
  final ValueNotifier<Offset> ringPos;
  final Color dotColor;
  final Color ringColor;

  static const _kDotRadius = 6.0;
  static const _kRingRadius = 20.0;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawCircle(
      ringPos.value,
      _kRingRadius,
      Paint()
        ..color = ringColor
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.5,
    );
    canvas.drawCircle(
      cursorPos.value,
      _kDotRadius,
      Paint()
        ..color = dotColor
        ..style = PaintingStyle.fill,
    );
  }

  @override
  bool shouldRepaint(_CursorPainter old) => false;
}
