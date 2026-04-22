import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../../../../core/theme/e_colors.dart';
import '../../../../core/theme/e_spacing.dart';
import '../../../../core/theme/e_text_styles.dart';
import '../../../../core/theme/personality_theme.dart';
import '../../../../core/widgets/shimmer_placeholder.dart';
import '../../../../core/widgets/tilt_card.dart';
import '../../../booking/models/service_model.dart';

class SectionWrapper extends StatelessWidget {
  const SectionWrapper({super.key, required this.child, this.useAltBackground = false});

  final Widget child;
  final bool useAltBackground;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final hPad =
        width > ESpacing.desktopBreak ? ESpacing.pagePaddingHDesktop : ESpacing.pagePaddingH;

    return Container(
      color: useAltBackground ? EColors.surfaceVariant : EColors.surface,
      padding: EdgeInsets.symmetric(horizontal: hPad, vertical: ESpacing.sectionGap),
      child: child,
    );
  }
}

class SectionHeader extends StatelessWidget {
  const SectionHeader({
    super.key,
    required this.title,
    this.overline,
    this.subtitle,
    this.textAlign = TextAlign.left,
  });

  final String title;
  final String? overline;
  final String? subtitle;
  final TextAlign textAlign;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment:
          textAlign == TextAlign.center ? CrossAxisAlignment.center : CrossAxisAlignment.start,
      children: [
        if (overline != null && overline!.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(bottom: ESpacing.xs),
            child: Text(overline!.toUpperCase(), style: ETextStyles.overline, textAlign: textAlign),
          ),
        Text(title, style: ETextStyles.displayMd, textAlign: textAlign),
        if (subtitle != null && subtitle!.isNotEmpty) ...[
          const SizedBox(height: ESpacing.sm),
          Text(subtitle!, style: ETextStyles.bodyMuted, textAlign: textAlign),
        ],
      ],
    );
  }
}

class ServiceCard extends StatelessWidget {
  const ServiceCard({super.key, required this.service, required this.pt, required this.onTap});

  final ServiceModel service;
  final PersonalityTheme pt;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return TiltCard(child: _ServiceCardInner(service: service, onTap: onTap));
  }
}

class _ServiceCardInner extends StatelessWidget {
  const _ServiceCardInner({required this.service, required this.onTap});

  final ServiceModel service;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: EColors.surfaceVariant,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: EColors.divider),
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // TODO(image-gen): service-card-${service.slug}
            service.imageUrl != null && service.imageUrl!.isNotEmpty
                ? AspectRatio(
                  aspectRatio: 4 / 3,
                  child: CachedNetworkImage(
                    imageUrl: service.imageUrl!,
                    fit: BoxFit.cover,
                    placeholder:
                        (_, _) => ShimmerPlaceholder(
                          aspectRatio: 4 / 3,
                          slot: 'service-card-${service.slug}',
                        ),
                    errorWidget:
                        (_, _, _) => ShimmerPlaceholder(
                          aspectRatio: 4 / 3,
                          slot: 'service-card-${service.slug}',
                        ),
                  ),
                )
                : _localServiceImage(service.slug),
            Padding(
              padding: const EdgeInsets.all(ESpacing.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(service.name, style: ETextStyles.h4.copyWith(color: EColors.onSurface)),
                  const SizedBox(height: ESpacing.xs),
                  Text(
                    '${service.formattedDuration} · ${service.formattedPrice}',
                    style: ETextStyles.bodySm.copyWith(color: EColors.primary),
                  ),
                  if (service.description.isNotEmpty) ...[
                    const SizedBox(height: ESpacing.xs),
                    Text(
                      service.description,
                      style: ETextStyles.bodySm.copyWith(color: EColors.onSurfaceMuted),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Widget _localServiceImage(String slug) {
  final assets = {
    'cheese-tasting': 'assets/images/service_card_cheese_tasting.jpg',
    'cheese-board-curation': 'assets/images/service_card_cheese_board_curation.jpg',
    'cheesemaking-class': 'assets/images/service_card_cheesemaking_class.jpg',
  };
  final path = assets[slug];
  if (path == null) {
    return ShimmerPlaceholder(aspectRatio: 4 / 3, slot: 'service-card-$slug');
  }
  return AspectRatio(aspectRatio: 4 / 3, child: Image.asset(path, fit: BoxFit.cover));
}

class OrnamentalHeader extends StatelessWidget {
  const OrnamentalHeader({super.key, required this.title});
  final String title;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: Divider(color: EColors.secondary, thickness: 1)),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: ESpacing.lg),
          child: Text(
            title.toUpperCase(),
            style: ETextStyles.overline.copyWith(
              color: EColors.onSurface,
              fontSize: 13,
              fontWeight: FontWeight.w700,
              letterSpacing: 4,
            ),
          ),
        ),
        Expanded(child: Divider(color: EColors.secondary, thickness: 1)),
      ],
    );
  }
}
