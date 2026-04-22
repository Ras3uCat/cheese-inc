import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/router/app_router.dart';
import '../../../core/theme/e_colors.dart';
import '../../../core/theme/e_spacing.dart';
import '../../../core/theme/e_text_styles.dart';
import '../../../core/theme/personality_theme.dart';
import '../../../core/widgets/shimmer_placeholder.dart';
import '../../home/views/sections/section_shared_widgets.dart';
import '../controllers/blog_controller.dart';
import '../models/blog_post_model.dart';

/// Embeddable blog teaser — shows latest 3 posts.
/// Requires BlogController to be registered (see HomeBinding).
class BlogSection extends GetView<BlogController> {
  const BlogSection({super.key});

  @override
  Widget build(BuildContext context) {
    final pt = PersonalityTheme.fromEnv();
    final isDesktop = MediaQuery.sizeOf(context).width > ESpacing.desktopBreak;

    return Obx(() {
      if (controller.isLoading.value) {
        return const SizedBox(height: 120, child: Center(child: CircularProgressIndicator()));
      }
      if (controller.posts.isEmpty) return const SizedBox.shrink();

      final preview = controller.posts.take(3).toList();

      return SectionWrapper(
        useAltBackground: true,
        child: Column(
          children: [
            SectionHeader(
              overline: 'FROM THE BLOG',
              title: 'Stories & Craft',
              textAlign: pt.heroTextAlign,
            ),
            const SizedBox(height: ESpacing.xxl),
            isDesktop
                ? Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children:
                      preview
                          .map(
                            (p) => Expanded(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: ESpacing.sm),
                                child: _BlogCard(post: p),
                              ),
                            ),
                          )
                          .toList(),
                )
                : Column(
                  children:
                      preview
                          .map(
                            (p) => Padding(
                              padding: const EdgeInsets.only(bottom: ESpacing.lg),
                              child: _BlogCard(post: p),
                            ),
                          )
                          .toList(),
                ),
            const SizedBox(height: ESpacing.xl),
            OutlinedButton(
              onPressed: () => Get.toNamed(ERoutes.blog),
              child: const Text('View All Posts'),
            ),
          ],
        ),
      );
    });
  }
}

class _BlogCard extends StatelessWidget {
  const _BlogCard({required this.post});
  final BlogPostModel post;

  @override
  Widget build(BuildContext context) {
    final date = post.publishedAt;
    final label =
        date != null
            ? '${date.day.toString().padLeft(2, '0')}.${date.month.toString().padLeft(2, '0')}.${date.year}'
            : '';

    return GestureDetector(
      onTap: () => Get.toNamed('${ERoutes.blog}/${post.slug}'),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // TODO(image-gen): blog-card-cover
          post.coverUrl != null
              ? AspectRatio(
                aspectRatio: 4 / 3,
                child: Image.network(post.coverUrl!, fit: BoxFit.cover, width: double.infinity),
              )
              : ShimmerPlaceholder(aspectRatio: 4 / 3, slot: 'blog-card-${post.slug}'),
          const SizedBox(height: ESpacing.md),
          if (label.isNotEmpty)
            Text(label, style: ETextStyles.overline.copyWith(color: EColors.primary)),
          const SizedBox(height: ESpacing.xs),
          Text(post.title, style: ETextStyles.h3, maxLines: 2, overflow: TextOverflow.ellipsis),
          const SizedBox(height: ESpacing.sm),
          Text(
            post.body.length > 120 ? '${post.body.substring(0, 120)}…' : post.body,
            style: ETextStyles.bodySmMuted,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
