import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/theme/e_spacing.dart';
import '../../../core/theme/e_text_styles.dart';
import '../../../core/widgets/inertia_carousel.dart';
import '../../../core/widgets/shimmer_placeholder.dart';
import '../../../core/widgets/tilt_card.dart';
import '../controllers/gallery_controller.dart';
import '../models/gallery_photo_model.dart';

class GallerySection extends GetView<GalleryController> {
  const GallerySection({super.key, this.isHomepage = false});

  final bool isHomepage;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isLoading.value) {
        return isHomepage
            ? const SizedBox.shrink()
            : const Padding(
              padding: EdgeInsets.symmetric(vertical: 48),
              child: Center(child: CircularProgressIndicator()),
            );
      }
      if (controller.photos.isEmpty) return const SizedBox.shrink();
      if (isHomepage) {
        return _HomepageGallery(
          photos: controller.photos.take(8).toList(),
          onTap: (i) => _showLightbox(context, i),
        );
      }
      return _FullGallery(photos: controller.photos, onTap: (i) => _showLightbox(context, i));
    });
  }

  void _showLightbox(BuildContext context, int initialIndex) {
    showDialog<void>(
      context: context,
      barrierColor: Colors.black87,
      builder: (_) => _LightboxDialog(photos: controller.photos, initialIndex: initialIndex),
    );
  }
}

// ── Homepage gallery: 4-col grid on desktop, InertiaCarousel on mobile ────────

class _HomepageGallery extends StatelessWidget {
  const _HomepageGallery({required this.photos, required this.onTap});

  final List<GalleryPhotoModel> photos;
  final void Function(int) onTap;

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.sizeOf(context).width < ESpacing.mobileBreak;

    if (isMobile) {
      return InertiaCarousel(
        itemCount: photos.length,
        itemBuilder: (ctx, i) => _GalleryCell(photo: photos[i], index: i, onTap: () => onTap(i)),
      );
    }

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        crossAxisSpacing: ESpacing.xs,
        mainAxisSpacing: ESpacing.xs,
      ),
      itemCount: photos.length,
      itemBuilder: (ctx, i) => _GalleryCell(photo: photos[i], index: i, onTap: () => onTap(i)),
    );
  }
}

// ── Full gallery page: responsive grid ────────────────────────────────────────

class _FullGallery extends StatelessWidget {
  const _FullGallery({required this.photos, required this.onTap});

  final List<GalleryPhotoModel> photos;
  final void Function(int) onTap;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (_, constraints) {
        final cols =
            constraints.maxWidth > 900
                ? 4
                : constraints.maxWidth > 600
                ? 3
                : 2;
        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: cols,
            crossAxisSpacing: ESpacing.xs,
            mainAxisSpacing: ESpacing.xs,
          ),
          itemCount: photos.length,
          itemBuilder: (ctx, i) => _GalleryCell(photo: photos[i], index: i, onTap: () => onTap(i)),
        );
      },
    );
  }
}

// ── Individual gallery cell ────────────────────────────────────────────────────

class _GalleryCell extends StatelessWidget {
  const _GalleryCell({required this.photo, required this.index, required this.onTap});

  final GalleryPhotoModel photo;
  final int index;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return TiltCard(
      child: GestureDetector(
        onTap: onTap,
        child: AspectRatio(
          aspectRatio: 1 / 1,
          child: CachedNetworkImage(
            imageUrl: photo.publicUrl,
            fit: BoxFit.cover,
            // TODO(image-gen): gallery-item-$index
            placeholder:
                (_, _) => ShimmerPlaceholder(aspectRatio: 1 / 1, slot: 'gallery-item-$index'),
            errorWidget:
                (_, _, _) => ShimmerPlaceholder(aspectRatio: 1 / 1, slot: 'gallery-item-$index'),
          ),
        ),
      ),
    );
  }
}

// ── Lightbox ──────────────────────────────────────────────────────────────────

class _LightboxDialog extends StatefulWidget {
  const _LightboxDialog({required this.photos, required this.initialIndex});
  final List<GalleryPhotoModel> photos;
  final int initialIndex;

  @override
  State<_LightboxDialog> createState() => _LightboxDialogState();
}

class _LightboxDialogState extends State<_LightboxDialog> {
  late int _current;
  late PageController _page;

  @override
  void initState() {
    super.initState();
    _current = widget.initialIndex;
    _page = PageController(initialPage: widget.initialIndex);
  }

  @override
  void dispose() {
    _page.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final photo = widget.photos[_current];
    return Dialog.fullscreen(
      backgroundColor: Colors.transparent,
      child: Stack(
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(color: Colors.transparent),
          ),
          Center(
            child: PageView.builder(
              controller: _page,
              itemCount: widget.photos.length,
              onPageChanged: (i) => setState(() => _current = i),
              itemBuilder:
                  (_, i) => InteractiveViewer(
                    child: CachedNetworkImage(
                      imageUrl: widget.photos[i].publicUrl,
                      fit: BoxFit.contain,
                      placeholder: (_, _) => const Center(child: CircularProgressIndicator()),
                      errorWidget:
                          (_, _, _) =>
                              const Icon(Icons.broken_image, color: Colors.white, size: 48),
                    ),
                  ),
            ),
          ),
          Positioned(
            top: 16,
            right: 16,
            child: IconButton(
              icon: const Icon(Icons.close, color: Colors.white, size: 32),
              onPressed: () => Navigator.pop(context),
            ),
          ),
          if (photo.caption != null)
            Positioned(
              bottom: 32,
              left: 0,
              right: 0,
              child: Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.black54,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    photo.caption!,
                    style: ETextStyles.bodySm.copyWith(color: Colors.white),
                  ),
                ),
              ),
            ),
          if (widget.photos.length > 1 && _current > 0)
            Positioned(
              left: 8,
              top: 0,
              bottom: 0,
              child: Center(
                child: IconButton(
                  icon: const Icon(Icons.chevron_left, color: Colors.white, size: 40),
                  onPressed:
                      () => _page.previousPage(
                        duration: const Duration(milliseconds: 250),
                        curve: Curves.easeOutCubic,
                      ),
                ),
              ),
            ),
          if (widget.photos.length > 1 && _current < widget.photos.length - 1)
            Positioned(
              right: 8,
              top: 0,
              bottom: 0,
              child: Center(
                child: IconButton(
                  icon: const Icon(Icons.chevron_right, color: Colors.white, size: 40),
                  onPressed:
                      () => _page.nextPage(
                        duration: const Duration(milliseconds: 250),
                        curve: Curves.easeOutCubic,
                      ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
