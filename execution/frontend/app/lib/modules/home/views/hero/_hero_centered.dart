import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/config/app_env.dart';
import '../../../../core/theme/e_colors.dart';
import '../../../../core/theme/e_spacing.dart';
import '../../../../core/theme/e_text_styles.dart';
import '../../../../core/theme/personality_theme.dart';
import '../../controllers/home_controller.dart';
import '_hero_cta.dart';

class HeroCentered extends StatelessWidget {
  const HeroCentered({super.key});

  @override
  Widget build(BuildContext context) {
    final pt = PersonalityTheme.fromEnv();

    return Obx(() {
      final ctrl = Get.find<HomeController>();
      final tagline = ctrl.heroTagline;

      return Container(
        height: 600,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [EColors.primaryLight, EColors.surface],
          ),
        ),
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: pt.heroContentMaxWidth),
            child: Padding(
              padding: const EdgeInsets.all(ESpacing.pagePaddingH),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    AppEnv.clientName,
                    style: ETextStyles.displayLg,
                    textAlign: TextAlign.center,
                  ),
                  if (tagline.isNotEmpty) ...[
                    const SizedBox(height: ESpacing.lg),
                    Text(
                      tagline,
                      style: ETextStyles.bodyLg.copyWith(color: EColors.onSurfaceMuted),
                      textAlign: TextAlign.center,
                    ),
                  ],
                  const SizedBox(height: ESpacing.xxl),
                  HeroCta(pt: pt),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }
}
