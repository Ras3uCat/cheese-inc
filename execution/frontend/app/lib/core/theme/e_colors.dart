import 'package:flutter/material.dart';
import '../config/app_env.dart';

/// EColors — all brand colors resolved from AppEnv (client.json).
/// Always consume EColors.xxx — never hardcode hex values in widgets.
class EColors {
  EColors._();

  static Color _hex(String hex) {
    final clean = hex.replaceAll('#', '').trim();
    final value = int.parse(clean.length == 6 ? 'FF$clean' : clean, radix: 16);
    return Color(value);
  }

  static Color get primary => _hex(AppEnv.colorPrimary);
  static Color get secondary => _hex(AppEnv.colorSecondary);
  static Color get accent => _hex(AppEnv.colorAccent);
  static Color get surface => _hex(AppEnv.colorSurface);
  static Color get onSurface => _hex(AppEnv.colorOnSurface);
  static Color get error => _hex(AppEnv.colorError);

  // Derived
  static Color get primaryLight => primary.withValues(alpha: 0.15);
  static Color get primaryMedium => primary.withValues(alpha: 0.5);
  static Color get surfaceVariant => onSurface.withValues(alpha: 0.05);
  // Cream alternate background — used for alternating section backgrounds.
  static Color get surfaceAlt => secondary;
  static Color get onSurfaceMuted => onSurface.withValues(alpha: 0.5);
  static Color get onSurfaceDim => _hex(AppEnv.colorOnSurfaceDim);

  static Color get surface2 => _hex(AppEnv.colorSurface2);
  static Color get surface3 => _hex(AppEnv.colorSurface3);
  static Color get parchment => _hex(AppEnv.colorParchment);
  static Color get rind => _hex(AppEnv.colorRind);
  static Color get mold => _hex(AppEnv.colorMold);

  static Color get borderSubtle => onSurface.withValues(alpha: 0.08);
  static Color get borderMedium => onSurface.withValues(alpha: 0.12);
  static Color get borderStrong => onSurface.withValues(alpha: 0.25);
  static Color get divider => borderMedium;

  static Color get transparent => Colors.transparent;
  static Color get white => Colors.white;
  static Color get black => Colors.black;
}
