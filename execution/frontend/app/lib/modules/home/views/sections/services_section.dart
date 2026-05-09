import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/theme/e_colors.dart';
import '../../../../core/theme/e_spacing.dart';
import '../../../../core/theme/e_text_styles.dart';
import '../../../../core/theme/personality_theme.dart';
import '../../../../core/config/app_env.dart';
import '../../../booking/models/artist_model.dart';
import '../../../booking/models/service_model.dart';
import '../../controllers/home_controller.dart';
import '_catalogue_card.dart';
import 'section_shared_widgets.dart';

const _kDemoServices = [
  ServiceModel(
    id: 'demo-1',
    name: 'Cheese Tasting',
    category: 'Experience',
    durationMinutes: 60,
    price: 45,
    description: 'A guided flight of six handpicked cheeses paired with local honey and fig jam.',
  ),
  ServiceModel(
    id: 'demo-2',
    name: 'Cheese Board Curation',
    category: 'Experience',
    durationMinutes: 30,
    price: 85,
    description: 'A bespoke board built to your occasion — weddings, dinner parties, date nights.',
  ),
  ServiceModel(
    id: 'demo-3',
    name: 'Cheesemaking Class',
    category: 'Workshop',
    durationMinutes: 180,
    price: 120,
    description: 'Make your own mozzarella or ricotta from scratch. Take it home the same day.',
  ),
];

// ─── Services Section ─────────────────────────────────────────────────────────
class ServicesSection extends StatelessWidget {
  const ServicesSection({super.key});

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.sizeOf(context).width > ESpacing.tabletBreak;

    return Obx(() {
      final ctrl = Get.find<HomeController>();
      final items = ctrl.services.isEmpty ? _kDemoServices : ctrl.services;

      return SectionWrapper(
        child: Column(
          children: [
            OrnamentalHeader(title: ctrl.servicesTitle),
            const SizedBox(height: ESpacing.xxl),
            if (isDesktop)
              _CatalogueGrid(items: items)
            else
              Column(
                children: [
                  for (var i = 0; i < items.length; i++)
                    Padding(
                      padding: const EdgeInsets.only(bottom: ESpacing.lg),
                      child: CatalogueCard(service: items[i], index: i),
                    ),
                ],
              ),
          ],
        ),
      );
    });
  }
}

// ─── Catalogue Grid (desktop) ─────────────────────────────────────────────────

class _CatalogueGrid extends StatelessWidget {
  const _CatalogueGrid({required this.items});
  final List<ServiceModel> items;

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 3,
      crossAxisSpacing: ESpacing.lg,
      mainAxisSpacing: ESpacing.lg,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: [for (var i = 0; i < items.length; i++) CatalogueCard(service: items[i], index: i)],
    );
  }
}

class TeamSection extends StatelessWidget {
  const TeamSection({super.key});

  @override
  Widget build(BuildContext context) {
    final pt = PersonalityTheme.fromEnv();
    final isMobile = MediaQuery.sizeOf(context).width < ESpacing.tabletBreak;

    return Obx(() {
      final ctrl = Get.find<HomeController>();
      if (ctrl.teamMembers.isEmpty) return const SizedBox.shrink();

      return SectionWrapper(
        useAltBackground: true,
        child: Column(
          children: [
            SectionHeader(
              overline: 'The Team',
              title: 'Meet Our Specialists',
              textAlign: pt.heroTextAlign,
            ),
            const SizedBox(height: ESpacing.xxl),
            Wrap(
              spacing: ESpacing.lg,
              runSpacing: ESpacing.lg,
              alignment: WrapAlignment.center,
              children:
                  ctrl.teamMembers.map((m) => _TeamCard(member: m, isMobile: isMobile)).toList(),
            ),
          ],
        ),
      );
    });
  }
}

class _TeamCard extends StatelessWidget {
  const _TeamCard({required this.member, required this.isMobile});
  final ArtistModel member;
  final bool isMobile;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: isMobile ? double.infinity : 260,
      child: Card(
        clipBehavior: Clip.antiAlias,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: 200,
              width: double.infinity,
              child:
                  member.photoUrl != null
                      ? Image.network(member.photoUrl!, fit: BoxFit.cover)
                      : Container(
                        color: EColors.primaryLight,
                        child: Center(
                          child: Icon(Icons.person_outline, size: 64, color: EColors.primary),
                        ),
                      ),
            ),
            Padding(
              padding: const EdgeInsets.all(ESpacing.lg),
              child: Column(
                children: [
                  Text(member.name, style: ETextStyles.h3),
                  if (member.specialty.isNotEmpty) ...[
                    const SizedBox(height: ESpacing.xs),
                    Text(member.specialty, style: ETextStyles.bodySmMuted),
                  ],
                  if (member.bio.isNotEmpty) ...[
                    const SizedBox(height: ESpacing.sm),
                    Text(
                      member.bio,
                      style: ETextStyles.bodySmMuted,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
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

class CtaSection extends StatelessWidget {
  const CtaSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final ctrl = Get.find<HomeController>();
      return Container(
        color: EColors.surface,
        padding: const EdgeInsets.symmetric(
          vertical: ESpacing.xxxl,
          horizontal: ESpacing.pagePaddingH,
        ),
        child: Column(
          children: [
            OrnamentalHeader(title: ctrl.ctaTitle),
            const SizedBox(height: ESpacing.xxl),
            ElevatedButton(
              onPressed:
                  AppEnv.moduleEnabled('booking')
                      ? () => Get.toNamed(ERoutes.booking)
                      : () => Get.toNamed(ERoutes.contact),
              style: ElevatedButton.styleFrom(
                backgroundColor: EColors.primary,
                foregroundColor: Colors.white,
                minimumSize: const Size(220, 52),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                textStyle: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.5,
                ),
              ),
              child: Text(ctrl.ctaButtonLabel.toUpperCase()),
            ),
          ],
        ),
      );
    });
  }
}
