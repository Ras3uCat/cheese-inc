import 'package:flutter/material.dart';
import '../../../../core/theme/e_colors.dart';
import '../../../../core/theme/e_spacing.dart';

class HeroMeta extends StatelessWidget {
  const HeroMeta({super.key, required this.loaderDone});

  final bool loaderDone;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final isMobile = width <= ESpacing.mobileBreak;

    return Padding(
      padding: const EdgeInsets.only(top: ESpacing.gapMeta),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _MetaCol(
            label: 'Chapter One',
            value: 'The Collection',
            align: TextAlign.left,
            delay: const Duration(milliseconds: 50),
            loaderDone: loaderDone,
          ),
          if (!isMobile)
            _MetaCol(
              label: 'Filed From',
              value: 'Tacoma, WA',
              align: TextAlign.center,
              delay: const Duration(milliseconds: 150),
              loaderDone: loaderDone,
            ),
          _MetaCol(
            label: 'Volume',
            value: 'MMXXVI · N°014',
            align: TextAlign.right,
            delay: const Duration(milliseconds: 250),
            loaderDone: loaderDone,
          ),
        ],
      ),
    );
  }
}

class _MetaCol extends StatefulWidget {
  const _MetaCol({
    required this.label,
    required this.value,
    required this.align,
    required this.delay,
    required this.loaderDone,
  });

  final String label;
  final String value;
  final TextAlign align;
  final Duration delay;
  final bool loaderDone;

  @override
  State<_MetaCol> createState() => _MetaColState();
}

class _MetaColState extends State<_MetaCol> {
  bool _visible = false;

  @override
  void initState() {
    super.initState();
    if (widget.loaderDone) {
      Future.delayed(widget.delay, () {
        if (mounted) setState(() => _visible = true);
      });
    }
  }

  @override
  void didUpdateWidget(_MetaCol old) {
    super.didUpdateWidget(old);
    if (!old.loaderDone && widget.loaderDone) {
      Future.delayed(widget.delay, () {
        if (mounted) setState(() => _visible = true);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSlide(
      offset: _visible ? Offset.zero : const Offset(0, 0.04),
      duration: const Duration(milliseconds: 700),
      curve: Curves.easeOut,
      child: AnimatedOpacity(
        opacity: _visible ? 1.0 : 0.0,
        duration: const Duration(milliseconds: 700),
        curve: Curves.easeOut,
        child: Column(
          crossAxisAlignment:
              widget.align == TextAlign.left
                  ? CrossAxisAlignment.start
                  : widget.align == TextAlign.right
                  ? CrossAxisAlignment.end
                  : CrossAxisAlignment.center,
          children: [
            Text(
              widget.label,
              textAlign: widget.align,
              style: TextStyle(
                fontFamily: 'JetBrainsMono',
                fontSize: 10.0,
                letterSpacing: 4.8,
                color: EColors.onSurfaceDim.withValues(alpha: 0.5),
              ),
            ),
            const SizedBox(height: 4.0),
            Text(
              widget.value,
              textAlign: widget.align,
              style: TextStyle(
                fontFamily: 'Playfair Display',
                fontSize: 17.6,
                fontStyle: FontStyle.italic,
                color: EColors.onSurface,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
