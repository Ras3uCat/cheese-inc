import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/config/app_env.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/theme/e_colors.dart';
import '../../../../core/theme/personality_theme.dart';
import '../../../../core/widgets/magnetic_widget.dart';

class HeroCta extends StatelessWidget {
  const HeroCta({super.key, required this.pt});
  final PersonalityTheme pt;

  @override
  Widget build(BuildContext context) {
    return MagneticWidget(
      child: ElevatedButton(
        onPressed:
            AppEnv.moduleEnabled('booking')
                ? () => Get.toNamed(ERoutes.booking)
                : () => Get.toNamed(ERoutes.contact),
        style: ElevatedButton.styleFrom(
          backgroundColor: EColors.primary,
          foregroundColor: Colors.white,
          minimumSize: const Size(200, 52),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
          textStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700, letterSpacing: 1.5),
        ),
        child: const Text('EXPLORE NOW'),
      ),
    );
  }
}
