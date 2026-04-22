import 'package:flutter/material.dart';

/// TiltCard — applies a subtle 3D perspective tilt on hover (web/desktop).
/// On touch devices, tilt is disabled; the child is rendered as-is.
/// Max tilt: ±8deg on each axis.
class TiltCard extends StatefulWidget {
  const TiltCard({super.key, required this.child, this.maxTiltDeg = 8.0});

  final Widget child;
  final double maxTiltDeg;

  @override
  State<TiltCard> createState() => _TiltCardState();
}

class _TiltCardState extends State<TiltCard> {
  double _rx = 0;
  double _ry = 0;
  bool _hovered = false;

  void _onHover(PointerEvent event, Size size) {
    final localX = event.localPosition.dx;
    final localY = event.localPosition.dy;
    final cx = size.width / 2;
    final cy = size.height / 2;
    final maxRad = widget.maxTiltDeg * 3.14159 / 180;
    setState(() {
      _ry = ((localX - cx) / cx) * maxRad;
      _rx = -((localY - cy) / cy) * maxRad;
    });
  }

  void _onExit() {
    setState(() {
      _rx = 0;
      _ry = 0;
      _hovered = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final size = Size(constraints.maxWidth, constraints.maxHeight);
        return MouseRegion(
          onEnter: (_) => setState(() => _hovered = true),
          onHover: (e) => _onHover(e, size),
          onExit: (_) => _onExit(),
          child: AnimatedContainer(
            duration:
                _hovered ? const Duration(milliseconds: 50) : const Duration(milliseconds: 300),
            curve: Curves.easeOutCubic,
            transform:
                Matrix4.identity()
                  ..setEntry(3, 2, 0.001)
                  ..rotateX(_rx)
                  ..rotateY(_ry),
            transformAlignment: Alignment.center,
            child: widget.child,
          ),
        );
      },
    );
  }
}
