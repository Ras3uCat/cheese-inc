import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/theme/e_colors.dart';
import '../../../../core/theme/e_spacing.dart';
import '../../../../core/theme/e_text_styles.dart';
import '../../../../core/widgets/magnetic_widget.dart';
import '../../../../core/widgets/tilt_card.dart';
import '../../../booking/models/service_model.dart';

class CatalogueCard extends StatefulWidget {
  const CatalogueCard({super.key, required this.service, required this.index});

  final ServiceModel service;
  final int index;

  @override
  State<CatalogueCard> createState() => _CatalogueCardState();
}

class _CatalogueCardState extends State<CatalogueCard> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final numLabel = widget.index < 9 ? '0${widget.index + 1}' : '${widget.index + 1}';

    return TiltCard(
      child: MouseRegion(
        onEnter: (_) => setState(() => _hovered = true),
        onExit: (_) => setState(() => _hovered = false),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          padding: const EdgeInsets.all(ESpacing.lg),
          decoration: BoxDecoration(
            color: EColors.secondary.withValues(alpha: _hovered ? 0.04 : 0.0),
            border: Border.all(color: EColors.secondary.withValues(alpha: _hovered ? 0.6 : 0.2)),
            borderRadius: BorderRadius.circular(2),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(numLabel, style: ETextStyles.svcNum),
                  Text(widget.service.category.toUpperCase(), style: ETextStyles.svcTag),
                ],
              ),
              const SizedBox(height: ESpacing.sm),
              SizedBox(
                height: 100,
                child: CustomPaint(
                  size: Size.infinite,
                  painter: _ServiceIllustrationPainter(slug: widget.service.slug),
                ),
              ),
              const SizedBox(height: ESpacing.md),
              Text(widget.service.name, style: ETextStyles.h3.copyWith(color: EColors.onSurface)),
              const SizedBox(height: ESpacing.xs),
              Text(
                widget.service.description,
                style: ETextStyles.bodySm.copyWith(color: EColors.onSurfaceDim),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
              Divider(color: EColors.secondary.withValues(alpha: 0.2), height: ESpacing.lg),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(widget.service.formattedPrice, style: ETextStyles.price),
                  MagneticWidget(
                    child: TextButton(
                      onPressed: () => Get.toNamed('${ERoutes.services}/${widget.service.slug}'),
                      child: Text('View Details →', style: ETextStyles.label),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ServiceIllustrationPainter extends CustomPainter {
  const _ServiceIllustrationPainter({required this.slug});

  final String slug;

  @override
  void paint(Canvas canvas, Size size) {
    final paint =
        Paint()
          ..color = EColors.secondary.withValues(alpha: 0.65)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.5
          ..strokeCap = StrokeCap.round;

    switch (slug) {
      case 'cheese-tasting':
        _drawWineGlass(canvas, size, paint);
      case 'cheese-board-curation':
        _drawCheeseBoard(canvas, size, paint);
      case 'cheesemaking-class':
        _drawBeaker(canvas, size, paint);
      default:
        _drawWedge(canvas, size, paint);
    }
  }

  void _drawWineGlass(Canvas canvas, Size size, Paint paint) {
    final cx = size.width * 0.4;
    final top = size.height * 0.1;
    final mid = size.height * 0.55;
    final base = size.height * 0.9;
    final bw = size.width * 0.12;

    final bowl =
        Path()
          ..moveTo(cx - bw, top)
          ..quadraticBezierTo(cx - bw * 1.4, mid * 0.5, cx, mid)
          ..quadraticBezierTo(cx + bw * 1.4, mid * 0.5, cx + bw, top);
    canvas.drawPath(bowl, paint);
    canvas.drawLine(Offset(cx, mid), Offset(cx, base - 4), paint);
    canvas.drawLine(Offset(cx - bw * 1.2, base), Offset(cx + bw * 1.2, base), paint);

    canvas.drawCircle(Offset(size.width * 0.7, size.height * 0.4), size.width * 0.07, paint);
  }

  void _drawCheeseBoard(Canvas canvas, Size size, Paint paint) {
    final l = size.width * 0.1;
    final t = size.height * 0.2;
    final w = size.width * 0.55;
    final h = size.height * 0.55;
    canvas.drawRRect(RRect.fromRectXY(Rect.fromLTWH(l, t, w, h), 4, 4), paint);

    canvas.drawOval(
      Rect.fromCenter(center: Offset(l + w * 0.3, t + h * 0.4), width: w * 0.3, height: h * 0.35),
      paint,
    );
    canvas.drawOval(
      Rect.fromCenter(center: Offset(l + w * 0.7, t + h * 0.55), width: w * 0.22, height: h * 0.28),
      paint,
    );

    final wx = size.width * 0.73;
    final wy = size.height * 0.25;
    final wedge =
        Path()
          ..moveTo(wx, wy)
          ..lineTo(wx + size.width * 0.18, wy + size.height * 0.15)
          ..lineTo(wx, wy + size.height * 0.3)
          ..close();
    canvas.drawPath(wedge, paint);
  }

  void _drawBeaker(Canvas canvas, Size size, Paint paint) {
    final cx = size.width / 2;
    final top = size.height * 0.08;
    final bot = size.height * 0.88;
    final hw = size.width * 0.18;
    final bw = size.width * 0.22;

    final jar =
        Path()
          ..moveTo(cx - hw, top)
          ..quadraticBezierTo(cx - bw, size.height * 0.5, cx - bw, bot)
          ..lineTo(cx + bw, bot)
          ..quadraticBezierTo(cx + bw, size.height * 0.5, cx + hw, top);
    canvas.drawPath(jar, paint);
    canvas.drawLine(Offset(cx - hw * 1.3, top), Offset(cx + hw * 1.3, top), paint);

    final liquidPaint =
        Paint()
          ..color = EColors.secondary.withValues(alpha: 0.25)
          ..style = PaintingStyle.fill;
    final liquid =
        Path()
          ..moveTo(cx - bw + 2, bot)
          ..lineTo(cx + bw - 2, bot)
          ..quadraticBezierTo(cx + bw - 2, size.height * 0.6, cx + hw * 0.8, size.height * 0.55)
          ..quadraticBezierTo(cx - hw * 0.8, size.height * 0.5, cx - bw + 2, size.height * 0.6)
          ..close();
    canvas.drawPath(liquid, liquidPaint);
  }

  void _drawWedge(Canvas canvas, Size size, Paint paint) {
    final wedge =
        Path()
          ..moveTo(size.width * 0.2, size.height * 0.8)
          ..lineTo(size.width * 0.8, size.height * 0.8)
          ..lineTo(size.width * 0.5, size.height * 0.15)
          ..close();
    canvas.drawPath(wedge, paint);
  }

  @override
  bool shouldRepaint(_ServiceIllustrationPainter _) => false;
}
