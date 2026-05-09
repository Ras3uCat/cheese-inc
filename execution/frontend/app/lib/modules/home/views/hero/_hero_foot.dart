import 'package:flutter/material.dart';
import '../../../../core/theme/e_colors.dart';
import '../../../../core/theme/e_spacing.dart';
import '../../../../core/widgets/cursor_overlay.dart';
import '../../../../core/widgets/magnetic_widget.dart';
import '_hero_scroll.dart';

class HeroFoot extends StatefulWidget {
  const HeroFoot({super.key, required this.loaderDone});

  final bool loaderDone;

  @override
  State<HeroFoot> createState() => _HeroFootState();
}

class _HeroFootState extends State<HeroFoot> {
  bool _visible = false;

  @override
  void initState() {
    super.initState();
    if (widget.loaderDone) _show();
  }

  @override
  void didUpdateWidget(HeroFoot old) {
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
          child: Builder(
            builder: (ctx) {
              final isMobile =
                  MediaQuery.sizeOf(ctx).width <= ESpacing.mobileBreak;
              return isMobile
                  ? const Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      _HeroDesc(),
                      SizedBox(height: ESpacing.lg),
                      _HeroCtaStack(),
                      SizedBox(height: ESpacing.xl),
                      HeroScroll(),
                    ],
                  )
                  : const Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Expanded(
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: _HeroDesc(),
                        ),
                      ),
                      SizedBox(width: ESpacing.lg),
                      _HeroCtaStack(),
                      Expanded(
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: HeroScroll(),
                        ),
                      ),
                    ],
                  );
            },
          ),
        ),
      ),
    );
  }
}

class _HeroDesc extends StatelessWidget {
  const _HeroDesc();

  @override
  Widget build(BuildContext context) {
    final base = TextStyle(
      fontFamily: 'Playfair Display',
      fontStyle: FontStyle.italic,
      fontSize: 17.6,
      height: 1.4,
      color: EColors.onSurface,
    );
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 300),
      child: RichText(
        text: TextSpan(
          style: base,
          children: [
            const TextSpan(text: 'A small, '),
            TextSpan(
              text: 'obsessively curated',
              style: base.copyWith(
                fontStyle: FontStyle.normal,
                fontWeight: FontWeight.w700,
                color: EColors.primary,
              ),
            ),
            const TextSpan(
              text:
                  ' cheesemongery in the Pacific Northwest.'
                  ' Boards, pairings, tours of the aging cave'
                  ' — and a monthly box for the brave of palate.',
            ),
          ],
        ),
      ),
    );
  }
}

class _HeroCtaStack extends StatelessWidget {
  const _HeroCtaStack();

  @override
  Widget build(BuildContext context) {
    return const Column(
      mainAxisSize: MainAxisSize.min,
      spacing: ESpacing.sm,
      children: [
        _CtaButton(label: 'SHOP THE COLLECTION →', isPrimary: true),
        _CtaButton(label: 'BOOK A TOUR', isPrimary: false),
      ],
    );
  }
}

class _CtaButton extends StatefulWidget {
  const _CtaButton({required this.label, required this.isPrimary});

  final String label;
  final bool isPrimary;

  @override
  State<_CtaButton> createState() => _CtaButtonState();
}

class _CtaButtonState extends State<_CtaButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _anim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _anim = CurvedAnimation(parent: _ctrl, curve: Curves.easeInOutCubic);
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Primary: fill stays red always; only border primary→white on hover.
    // Outline: transparent→primary slides up from bottom; border cream→primary.
    final defaultFill =
        widget.isPrimary
            ? EColors.primary
            : EColors.primary.withValues(alpha: 0);
    final hoverFill = EColors.primary;
    final defaultBorder =
        widget.isPrimary ? EColors.primary : EColors.onSurface;
    final hoverBorder = widget.isPrimary ? EColors.onSurface : EColors.primary;
    final defaultText = widget.isPrimary ? EColors.surface : EColors.onSurface;

    return MagneticWidget(
      child: MouseRegion(
        onEnter: (_) {
          _ctrl.forward();
          CursorState.isInteractive.value = true;
        },
        onExit: (_) {
          _ctrl.reverse();
          CursorState.isInteractive.value = false;
        },
        child: AnimatedBuilder(
          animation: _anim,
          builder: (_, _) {
            final t = _anim.value;
            final stopA = t.clamp(0.0001, 0.9999);
            final stopB = (t + 0.0001).clamp(0.0, 1.0);
            return Container(
              padding:
                  widget.isPrimary
                      ? const EdgeInsets.symmetric(
                        vertical: 17.6,
                        horizontal: 28.0,
                      )
                      : const EdgeInsets.symmetric(
                        vertical: 11.0,
                        horizontal: 19.0,
                      ),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  stops: [0.0, stopA, stopB, 1.0],
                  colors: [hoverFill, hoverFill, defaultFill, defaultFill],
                ),
                border: Border.all(
                  color: Color.lerp(defaultBorder, hoverBorder, t)!,
                ),
              ),
              child: Text(
                widget.label,
                style: TextStyle(
                  fontFamily: 'Space Grotesk',
                  fontSize: widget.isPrimary ? 13.1 : 11.5,
                  letterSpacing: widget.isPrimary ? 2.88 : 2.0,
                  color: Color.lerp(defaultText, EColors.surface, t),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
