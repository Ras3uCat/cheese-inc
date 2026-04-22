import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../../../core/theme/e_colors.dart';
import '../../../../core/theme/e_spacing.dart';
import '../../../../core/theme/e_text_styles.dart';
import '../models/gallery_photo_model.dart';

class GalleryCarousel extends StatefulWidget {
  const GalleryCarousel({super.key, required this.photos, required this.onTap});

  final List<GalleryPhotoModel> photos;
  final void Function(int index) onTap;

  @override
  State<GalleryCarousel> createState() => _GalleryCarouselState();
}

class _GalleryCarouselState extends State<GalleryCarousel> {
  late final PageController _page;
  int _current = 0;

  @override
  void initState() {
    super.initState();
    _page = PageController();
  }

  @override
  void dispose() {
    _page.dispose();
    super.dispose();
  }

  void _prev() {
    if (_current > 0) {
      _page.previousPage(duration: const Duration(milliseconds: 300), curve: Curves.easeOut);
    }
  }

  void _next() {
    if (_current < widget.photos.length - 1) {
      _page.nextPage(duration: const Duration(milliseconds: 300), curve: Curves.easeOut);
    }
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final isMobile = width < ESpacing.desktopBreak;
    final height = isMobile ? 300.0 : 480.0;
    final total = widget.photos.length;

    return SizedBox(
      height: height,
      child: Stack(
        children: [
          PageView.builder(
            controller: _page,
            itemCount: total,
            onPageChanged: (i) => setState(() => _current = i),
            itemBuilder: (ctx, i) {
              return GestureDetector(
                onTap: () => widget.onTap(i),
                child: CachedNetworkImage(
                  imageUrl: widget.photos[i].publicUrl,
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: height,
                  placeholder: (_, _) => Container(color: EColors.surfaceVariant),
                  errorWidget:
                      (_, _, _) => Container(
                        color: EColors.surfaceVariant,
                        child: const Icon(Icons.broken_image, color: Colors.grey),
                      ),
                ),
              );
            },
          ),

          // Numbered progress indicator — bottom-right
          Positioned(
            bottom: ESpacing.md,
            right: ESpacing.md,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: ESpacing.sm, vertical: ESpacing.xs),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                '${(_current + 1).toString().padLeft(2, '0')} / ${total.toString().padLeft(2, '0')}',
                style: ETextStyles.overline.copyWith(color: Colors.white),
              ),
            ),
          ),

          // Web-only navigation arrows
          if (kIsWeb) ...[
            _ArrowButton(
              alignment: Alignment.centerLeft,
              icon: Icons.arrow_back_ios_new,
              onPressed: _current > 0 ? _prev : null,
            ),
            _ArrowButton(
              alignment: Alignment.centerRight,
              icon: Icons.arrow_forward_ios,
              onPressed: _current < total - 1 ? _next : null,
            ),
          ],
        ],
      ),
    );
  }
}

class _ArrowButton extends StatelessWidget {
  const _ArrowButton({required this.alignment, required this.icon, required this.onPressed});

  final Alignment alignment;
  final IconData icon;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: Align(
        alignment: alignment,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: ESpacing.xs),
          child: IconButton(
            icon: Icon(icon, color: Colors.white, size: ESpacing.lg),
            iconSize: 44,
            onPressed: onPressed,
            style: IconButton.styleFrom(backgroundColor: Colors.black.withValues(alpha: 0.3)),
          ),
        ),
      ),
    );
  }
}
