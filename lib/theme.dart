import 'dart:ui' show FontVariation;

import 'package:flutter/material.dart';

import 'app_state.dart';

/// Paleta de colores de cada cara.
/// Oscuro: fondo burdeos + texto mantequilla.
/// Claro: fondo mantequilla + texto burdeos.
@immutable
class Palette extends ThemeExtension<Palette> {
  const Palette({
    required this.bg,
    required this.surface,
    required this.line,
    required this.text,
    required this.muted,
    required this.accent,
    required this.onAccent,
  });

  final Color bg; // fondo de la página
  final Color surface; // tarjetas
  final Color line; // bordes y separadores
  final Color text; // texto principal
  final Color muted; // texto secundario
  final Color accent; // color de acento (botones, detalles)
  final Color onAccent; // texto sobre el acento

  /// 🌙 Programación — burdeos
  static const dev = Palette(
    bg: Color(0xFF2B0A12),
    surface: Color(0xFF3B0E1A),
    line: Color(0xFF5E1B2B),
    text: Color(0xFFF7EBC4),
    muted: Color(0xFFC9AE8A),
    accent: Color(0xFFF3D774),
    onAccent: Color(0xFF2B0A12),
  );

  /// ☀️ Diseño — butter
  static const design = Palette(
    bg: Color(0xFFFBF0C2),
    surface: Color(0xFFFFF8DC),
    line: Color(0xFFE5D08A),
    text: Color(0xFF3A0C17),
    muted: Color(0xFF7D4B53),
    accent: Color(0xFF800020),
    onAccent: Color(0xFFFBF0C2),
  );

  static Palette forMode(PortfolioMode mode) => mode.isDark ? dev : design;

  static Palette of(BuildContext context) => Theme.of(context).extension<Palette>()!;

  @override
  Palette copyWith({
    Color? bg,
    Color? surface,
    Color? line,
    Color? text,
    Color? muted,
    Color? accent,
    Color? onAccent,
  }) {
    return Palette(
      bg: bg ?? this.bg,
      surface: surface ?? this.surface,
      line: line ?? this.line,
      text: text ?? this.text,
      muted: muted ?? this.muted,
      accent: accent ?? this.accent,
      onAccent: onAccent ?? this.onAccent,
    );
  }

  @override
  Palette lerp(covariant ThemeExtension<Palette>? other, double t) {
    if (other is! Palette) return this;
    return Palette(
      bg: Color.lerp(bg, other.bg, t)!,
      surface: Color.lerp(surface, other.surface, t)!,
      line: Color.lerp(line, other.line, t)!,
      text: Color.lerp(text, other.text, t)!,
      muted: Color.lerp(muted, other.muted, t)!,
      accent: Color.lerp(accent, other.accent, t)!,
      onAccent: Color.lerp(onAccent, other.onAccent, t)!,
    );
  }
}

/// Tipografías.
class Fonts {
  static const bodyFamily = 'IosevkaCharon';
  static const bebas = 'BebasNeue';
  static const oswald = 'Oswald';

  /// Estilo para títulos grandes. Bebas Neue en ES/EN, Oswald en RU/UK.
  static TextStyle display(
    BuildContext context, {
    required double size,
    Color? color,
    double height = 0.95,
  }) {
    final lang = AppScope.of(context).lang;
    final palette = Palette.of(context);
    if (lang.isCyrillic) {
      return TextStyle(
        fontFamily: oswald,
        fontSize: size * 0.82, // Oswald es un poco más ancha que Bebas
        fontWeight: FontWeight.w600,
        fontVariations: const [FontVariation('wght', 600)],
        height: height * 1.08,
        letterSpacing: 0.5,
        color: color ?? palette.text,
      );
    }
    return TextStyle(
      fontFamily: bebas,
      fontSize: size,
      height: height,
      letterSpacing: 1,
      color: color ?? palette.text,
    );
  }

  /// Estilo para texto normal (Iosevka Charon).
  static TextStyle body(
    BuildContext context, {
    double size = 16,
    FontWeight weight = FontWeight.w400,
    Color? color,
    double height = 1.6,
  }) {
    return TextStyle(
      fontFamily: Fonts.bodyFamily,
      fontSize: size,
      fontWeight: weight,
      height: height,
      color: color ?? Palette.of(context).text,
    );
  }
}

ThemeData buildTheme(PortfolioMode mode) {
  final p = Palette.forMode(mode);
  final scheme = ColorScheme(
    brightness: mode.isDark ? Brightness.dark : Brightness.light,
    primary: p.accent,
    onPrimary: p.onAccent,
    secondary: p.accent,
    onSecondary: p.onAccent,
    error: const Color(0xFFB3261E),
    onError: Colors.white,
    surface: p.surface,
    onSurface: p.text,
  );

  final base = ThemeData(
    useMaterial3: true,
    colorScheme: scheme,
    scaffoldBackgroundColor: p.bg,
    fontFamily: Fonts.bodyFamily,
    extensions: [p],
  );

  return base.copyWith(
    textTheme: base.textTheme.apply(
      fontFamily: Fonts.bodyFamily,
      bodyColor: p.text,
      displayColor: p.text,
    ),
    textSelectionTheme: TextSelectionThemeData(
      selectionColor: p.accent.withValues(alpha: 0.35),
      cursorColor: p.accent,
    ),
    tooltipTheme: TooltipThemeData(
      decoration: BoxDecoration(
        color: p.text,
        borderRadius: BorderRadius.circular(6),
      ),
      textStyle: TextStyle(fontFamily: Fonts.bodyFamily, color: p.bg, fontSize: 13),
    ),
  );
}

/// Ayuda para diseño responsive.
class Breakpoints {
  static const double mobile = 600;
  static const double tablet = 960;
  static const double maxContent = 1120;

  static bool isMobile(BuildContext context) => MediaQuery.sizeOf(context).width < mobile;
  static bool isWide(BuildContext context) => MediaQuery.sizeOf(context).width >= tablet;

  static double gutter(BuildContext context) {
    final w = MediaQuery.sizeOf(context).width;
    if (w < mobile) return 20;
    if (w < tablet) return 40;
    return 56;
  }
}
