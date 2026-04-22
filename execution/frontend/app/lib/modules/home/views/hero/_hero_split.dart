import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/config/app_env.dart';
import '../../../../core/theme/e_colors.dart';
import '../../../../core/theme/e_spacing.dart';
import '../../../../core/theme/e_text_styles.dart';
import '../../../../core/theme/personality_theme.dart';
import '../../controllers/home_controller.dart';
import '_hero_cta.dart';

const _kHeroPlaceholder = 'https://picsum.photos/1600/900?random=42';

class HeroSplit extends StatelessWidget {
  const HeroSplit({super.key});

  @override
  Widget build(BuildContext context) {
    final pt = PersonalityTheme.fromEnv();
    final width = MediaQuery.of(context).size.width;

    return Obx(() {
      final ctrl = Get.find<HomeController>();
      final imageUrl = ctrl.heroImageUrl.isEmpty ? null : ctrl.heroImageUrl;
      final overline = ctrl.heroOverline;
      final tagline = ctrl.heroTagline;

      return Container(
        height: 680,
        color: EColors.surface,
        child: Row(
          children: [
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal:
                      width > ESpacing.desktopBreak
                          ? ESpacing.pagePaddingHDesktop
                          : ESpacing.pagePaddingH,
                  vertical: ESpacing.xxxl,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (overline.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(bottom: ESpacing.md),
                        child: Text(overline.toUpperCase(), style: ETextStyles.overline),
                      ),
                    Text(AppEnv.clientName, style: ETextStyles.displayLg),
                    if (tagline.isNotEmpty) ...[
                      const SizedBox(height: ESpacing.lg),
                      Text(
                        tagline,
                        style: ETextStyles.bodyLg.copyWith(color: EColors.onSurfaceMuted),
                      ),
                    ],
                    const SizedBox(height: ESpacing.xxl),
                    HeroCta(pt: pt),
                  ],
                ),
              ),
            ),
            Expanded(
              child: CachedNetworkImage(
                imageUrl: imageUrl ?? _kHeroPlaceholder,
                fit: BoxFit.cover,
                height: double.infinity,
                placeholder: (_, _) => Container(color: EColors.primaryLight),
                errorWidget: (_, _, _) => Container(color: EColors.primaryLight),
              ),
            ),
          ],
        ),
      );
    });
  }
}
