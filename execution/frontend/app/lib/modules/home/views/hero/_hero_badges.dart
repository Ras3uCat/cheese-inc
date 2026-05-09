import 'package:flutter/material.dart';
import '../../../../core/theme/e_colors.dart';
import '../../../../core/theme/e_spacing.dart';

class HeroBadges extends StatelessWidget {
  const HeroBadges({super.key});

  static const _kBadges = [
    ('◦ Good Food Awards ', '2024'),
    ('◦ ACS Gold ', '2023'),
    ('◦ PNW Slow Food ', '2025'),
  ];

  TextStyle get _labelStyle => TextStyle(
    fontFamily: 'JetBrainsMono',
    fontSize: 10.9,
    letterSpacing: 3.2,
    color: EColors.onSurfaceDim,
  );

  TextStyle get _yearStyle => TextStyle(
    fontFamily: 'Playfair Display',
    fontStyle: FontStyle.italic,
    fontSize: 15.2,
    color: EColors.secondary,
  );

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.sizeOf(context).width <= ESpacing.mobileBreak;
    final badges = _kBadges.map((b) => _badgeSpan(b.$1, b.$2)).toList();

    return Wrap(
      spacing: 20.0,
      runSpacing: 6.0,
      alignment: isMobile ? WrapAlignment.center : WrapAlignment.start,
      children: badges,
    );
  }

  Widget _badgeSpan(String label, String year) {
    return RichText(
      text: TextSpan(
        children: [
          TextSpan(text: label.toUpperCase(), style: _labelStyle),
          TextSpan(text: year, style: _yearStyle),
        ],
      ),
    );
  }
}
