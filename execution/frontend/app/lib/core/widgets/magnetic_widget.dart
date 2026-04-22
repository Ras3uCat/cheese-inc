import 'package:flutter/material.dart';

class MagneticWidget extends StatefulWidget {
  const MagneticWidget({
    super.key,
    required this.child,
    this.triggerRadius = 80.0,
    this.maxDisplace = 12.0,
  });

  final Widget child;
  final double triggerRadius;
  final double maxDisplace;

  @override
  State<MagneticWidget> createState() => _MagneticWidgetState();
}

class _MagneticWidgetState extends State<MagneticWidget> {
  Offset _target = Offset.zero;
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (_, constraints) {
        final center = Offset(constraints.maxWidth / 2, constraints.maxHeight / 2);
        return MouseRegion(
          onHover: (event) {
            final delta = event.localPosition - center;
            final dist = delta.distance;
            if (dist < widget.triggerRadius) {
              setState(() {
                _target = Offset(
                  (delta.dx / widget.triggerRadius) * widget.maxDisplace,
                  (delta.dy / widget.triggerRadius) * widget.maxDisplace,
                );
                _hovered = true;
              });
            }
          },
          onExit:
              (_) => setState(() {
                _target = Offset.zero;
                _hovered = false;
              }),
          child: TweenAnimationBuilder<Offset>(
            tween: Tween<Offset>(begin: Offset.zero, end: _target),
            duration:
                _hovered ? const Duration(milliseconds: 60) : const Duration(milliseconds: 300),
            curve: _hovered ? Curves.linear : Curves.easeOutCubic,
            builder: (_, offset, child) => Transform.translate(offset: offset, child: child),
            child: widget.child,
          ),
        );
      },
    );
  }
}
