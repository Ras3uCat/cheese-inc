import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

/// ESpacing — fixed spacing scale used throughout all modules.
/// Based on an 8pt grid. Widgets use these constants, never raw numbers.
class ESpacing {
  ESpacing._();

  static const double xs = 4.0;
  static const double sm = 8.0;
  static const double md = 16.0;
  static const double lg = 24.0;
  static const double xl = 48.0;
  static const double xxl = 80.0;
  static const double xxxl = 128.0;

  // Page padding
  static const double pagePaddingH = 24.0;
  static const double pagePaddingHDesktop = 80.0;
  static const double sectionGapV = 80.0;
  static const double sectionGapVMobile = 56.0;
  // Platform-adaptive: 56px on native, 80px on web. Compile-time constant.
  static const double sectionGap = !kIsWeb ? sectionGapVMobile : sectionGapV;

  // Responsive breakpoints
  static const double mobileBreak = 600.0;
  static const double tabletBreak = 960.0;
  static const double desktopBreak = 1280.0;

  // Hero frame insets
  static const double framePad = 20.0;
  static const double frameSmall = 10.0;
  static const double gapMeta = 32.0;

  // Content container cap
  static const double maxWidth = 1440.0;

  // Responsive gutter — scales from 16px at narrow to 48px at wide viewports.
  static double gut(BuildContext ctx) {
    final w = MediaQuery.sizeOf(ctx).width;
    return (0.5 + w * 0.03).clamp(16.0, 48.0);
  }
}
