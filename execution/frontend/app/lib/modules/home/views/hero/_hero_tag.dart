import 'package:flutter/material.dart';
import '../../../../core/theme/e_colors.dart';
import '../../../../core/theme/e_spacing.dart';

class HeroTag extends StatefulWidget {
  const HeroTag({super.key, required this.loaderDone});

  final bool loaderDone;

  @override
  State<HeroTag> createState() => _HeroTagState();
}

class _HeroTagState extends State<HeroTag> {
  bool _visible = false;

  @override
  void initState() {
    super.initState();
    if (widget.loaderDone) _show();
  }

  @override
  void didUpdateWidget(HeroTag old) {
    super.didUpdateWidget(old);
    if (!old.loaderDone && widget.loaderDone) _show();
  }

  void _show() {
    if (mounted) setState(() => _visible = true);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSlide(
      offset: _visible ? Offset.zero : const Offset(0, 0.05),
      duration: const Duration(milliseconds: 1000),
      curve: Curves.easeOut,
      child: AnimatedOpacity(
        opacity: _visible ? 1.0 : 0.0,
        duration: const Duration(milliseconds: 1000),
        curve: Curves.easeOut,
        child: Padding(
          padding: const EdgeInsets.only(top: ESpacing.xl),
          child: Row(
            children: [
              Expanded(
                child: Divider(color: EColors.onSurface.withValues(alpha: 0.25), thickness: 0.5),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: ESpacing.md),
                child: Text(
                  'AN ARTISANAL CATALOGUE · VOLUME XIV',
                  style: TextStyle(
                    fontFamily: 'JetBrainsMono',
                    fontSize: 12.5,
                    letterSpacing: 3.2,
                    color: EColors.onSurfaceDim,
                  ),
                ),
              ),
              Expanded(
                child: Divider(color: EColors.onSurface.withValues(alpha: 0.25), thickness: 0.5),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
