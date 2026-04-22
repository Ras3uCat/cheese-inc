import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../core/config/app_env.dart';
import '../../../core/theme/e_text_styles.dart';
import '../../../core/widgets/app_shell.dart';
import '../../../core/widgets/reveal_on_scroll.dart';
import '../../../core/widgets/section_divider.dart';
import '../../../core/widgets/seo_wrapper.dart';
import '../../blog/widgets/blog_section.dart';
import '../../gallery/widgets/gallery_section.dart';
import '../../menu/menu_section.dart';
import '../../testimonials/widgets/testimonials_section.dart';
import '../controllers/home_controller.dart';
import 'hero/hero_fullbleed.dart';
import 'sections/services_section.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return SeoWrapper(
      title: AppEnv.clientName,
      description: 'Welcome to ${AppEnv.clientName}.',
      child: NotificationListener<ScrollNotification>(
        onNotification: (n) {
          Get.find<HomeController>().scrollOffset.value = n.metrics.pixels;
          return false;
        },
        child: AppShell(
          child: Column(children: [_buildHero(), ..._buildSections(), _buildFooter()]),
        ),
      ),
    );
  }

  Widget _buildHero() {
    return switch (AppEnv.heroVariant) {
      'split' => const HeroSplit(),
      'centered' => const HeroCentered(),
      _ => const HeroFullbleed(),
    };
  }

  List<Widget> _buildSections() {
    final sections =
        AppEnv.homeSectionList
            .where((s) => s != 'hero')
            .map(_sectionForId)
            .whereType<Widget>()
            .toList();

    final result = <Widget>[];
    for (var i = 0; i < sections.length; i++) {
      if (i > 0) result.add(const SectionDivider());
      final delay = Duration(milliseconds: 50 + i * 50);
      result.add(RevealOnScroll(delay: delay, child: sections[i]));
    }
    return result;
  }

  Widget? _sectionForId(String id) {
    return switch (id) {
      'services' => const ServicesSection(),
      'team' => const TeamSection(),
      'testimonials' => AppEnv.moduleEnabled('testimonials') ? const TestimonialsSection() : null,
      'cta' => const CtaSection(),
      'menu' => AppEnv.moduleEnabled('menu') ? const MenuSection() : null,
      'gallery' => AppEnv.moduleEnabled('gallery') ? const GallerySection(isHomepage: true) : null,
      'blog' => AppEnv.moduleEnabled('blog') ? const BlogSection() : null,
      _ => null,
    };
  }

  Widget _buildFooter() {
    final socials =
        <String, String>{
          'IG': AppEnv.instagramUrl,
          'FB': AppEnv.facebookUrl,
          'TT': AppEnv.tiktokUrl,
          'YT': AppEnv.youtubeUrl,
        }.entries.where((e) => e.value.isNotEmpty).toList();

    return Container(
      color: const Color(0xFF0D0D0D),
      padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 80),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('\u25C6', style: ETextStyles.caption.copyWith(color: Colors.amber, fontSize: 16)),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '© ${DateTime.now().year} ${AppEnv.clientName}',
                style: ETextStyles.caption.copyWith(color: Colors.white54),
              ),
              if (socials.isNotEmpty)
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children:
                      socials
                          .map(
                            (e) => TextButton(
                              onPressed:
                                  () => launchUrl(
                                    Uri.parse(e.value),
                                    mode: LaunchMode.externalApplication,
                                  ),
                              style: TextButton.styleFrom(
                                foregroundColor: Colors.white38,
                                minimumSize: Size.zero,
                                padding: const EdgeInsets.symmetric(horizontal: 8),
                                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              ),
                              child: Text(e.key, style: ETextStyles.caption),
                            ),
                          )
                          .toList(),
                ),
              Text(
                'Crafted with patience & salt',
                style: ETextStyles.caption.copyWith(color: Colors.white24),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
