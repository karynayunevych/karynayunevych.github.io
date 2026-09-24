import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../app_state.dart';
import '../content.dart';
import '../i18n.dart';
import '../theme.dart';
import '../widgets/common.dart';
import '../widgets/nav_bar.dart';

/// Portada: saludo, nombre enorme, rol, frase y botones.
class HeroSection extends StatelessWidget {
  const HeroSection({
    super.key,
    required this.content,
    required this.onPrimary,
    required this.onContact,
  });

  final ModeContent content;
  final VoidCallback onPrimary;
  final VoidCallback onContact;

  @override
  Widget build(BuildContext context) {
    final p = Palette.of(context);
    final mode = AppScope.of(context).mode;
    final size = MediaQuery.sizeOf(context);
    final mobile = size.width < Breakpoints.mobile;

    final nameSize = size.width < Breakpoints.mobile
        ? 88.0
        : size.width < Breakpoints.tablet
            ? 140.0
            : 184.0;

    return ConstrainedBox(
      constraints: BoxConstraints(minHeight: math.max(560, size.height - NavBar.height)),
      child: Stack(
        children: [
          Positioned.fill(
            child: CustomPaint(
              painter: mode.isDark ? _DotGridPainter(p.line) : _ShapesPainter(p.accent, p.line),
            ),
          ),
          ContentWidth(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: mobile ? 64 : 96),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    context.tr(content.greeting),
                    style: Fonts.body(context, size: mobile ? 16 : 20, color: p.accent, weight: FontWeight.w500),
                  ),
                  const SizedBox(height: 12),
                  // El nombre siempre en latín (Bebas Neue), también en RU/UK.
                  Text(
                    Profile.firstName.toUpperCase(),
                    style: TextStyle(fontFamily: Fonts.bebas, fontSize: nameSize, height: 0.88, color: p.text),
                  ),
                  Text(
                    Profile.lastName.toUpperCase(),
                    style: TextStyle(
                      fontFamily: Fonts.bebas,
                      fontSize: nameSize,
                      height: 0.88,
                      color: mode.isDark ? p.accent : null,
                      foreground: mode.isDark ? null : _outline(p.accent),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      Flexible(
                        child: Text(
                          context.tr(content.role).toUpperCase(),
                          style: Fonts.display(context, size: mobile ? 30 : 44, height: 1.05),
                        ),
                      ),
                      if (mode.isDark) ...[const SizedBox(width: 8), const _BlinkingCursor()],
                    ],
                  ),
                  const SizedBox(height: 20),
                  ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 620),
                    child: Text(
                      context.tr(content.tagline),
                      style: Fonts.body(context, size: mobile ? 16 : 18, color: p.muted),
                    ),
                  ),
                  const SizedBox(height: 36),
                  Wrap(
                    spacing: 14,
                    runSpacing: 14,
                    children: [
                      PillButton(
                        label: context.tr(mode.isDark ? S.seeProjects : S.seeWork),
                        icon: Icons.arrow_downward,
                        onPressed: onPrimary,
                      ),
                      PillButton(
                        label: context.tr(S.getInTouch),
                        icon: Icons.mail_outline,
                        filled: false,
                        onPressed: onContact,
                      ),
                    ],
                  ),
                  const SizedBox(height: 48),
                  _TwoSidesHint(text: context.tr(content.hint)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// En modo claro el apellido va solo con contorno (efecto "outline").
  static Paint _outline(Color color) => Paint()
    ..style = PaintingStyle.stroke
    ..strokeWidth = 2
    ..color = color;
}

class _TwoSidesHint extends StatelessWidget {
  const _TwoSidesHint({required this.text});
  final String text;

  @override
  Widget build(BuildContext context) {
    final p = Palette.of(context);
    final dark = AppScope.of(context).mode.isDark;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        border: Border.all(color: p.line),
        borderRadius: BorderRadius.circular(dark ? 4 : 999),
        color: p.surface.withValues(alpha: 0.6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(dark ? Icons.light_mode_outlined : Icons.dark_mode_outlined, size: 16, color: p.accent),
          const SizedBox(width: 10),
          Flexible(child: Text(text, style: Fonts.body(context, size: 13, color: p.muted, height: 1.4))),
        ],
      ),
    );
  }
}

class _BlinkingCursor extends StatefulWidget {
  const _BlinkingCursor();

  @override
  State<_BlinkingCursor> createState() => _BlinkingCursorState();
}

class _BlinkingCursorState extends State<_BlinkingCursor> with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1000),
  )..repeat();

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final p = Palette.of(context);
    return AnimatedBuilder(
      animation: _c,
      builder: (context, _) => Opacity(
        opacity: _c.value < 0.5 ? 1 : 0,
        child: Container(width: 16, height: 34, color: p.accent),
      ),
    );
  }
}

/// Fondo de la cara "código": cuadrícula de puntos que se desvanece.
class _DotGridPainter extends CustomPainter {
  _DotGridPainter(this.color);
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    const gap = 28.0;
    final paint = Paint();
    for (double x = gap / 2; x < size.width; x += gap) {
      for (double y = gap / 2; y < size.height; y += gap) {
        // Más visible a la derecha, se desvanece hacia la izquierda.
        final t = (x / size.width).clamp(0.0, 1.0);
        paint.color = color.withValues(alpha: 0.15 + 0.6 * t * t);
        canvas.drawCircle(Offset(x, y), 1.4, paint);
      }
    }
  }

  @override
  bool shouldRepaint(_DotGridPainter old) => old.color != color;
}

/// Fondo de la cara "diseño": formas geométricas grandes.
class _ShapesPainter extends CustomPainter {
  _ShapesPainter(this.accent, this.line);
  final Color accent;
  final Color line;

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    final r = math.min(w, h);
    // En pantallas estrechas las formas quedarían detrás del nombre:
    // allí las hacemos muy suaves.
    final strong = w >= 960;

    // Círculo grande relleno, medio fuera de la pantalla.
    canvas.drawCircle(
      Offset(w * 0.92, h * 0.28),
      r * 0.32,
      Paint()..color = accent.withValues(alpha: strong ? 0.9 : 0.12),
    );
    // Anillo.
    canvas.drawCircle(
      Offset(w * 0.78, h * 0.72),
      r * 0.2,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2
        ..color = accent.withValues(alpha: strong ? 1 : 0.3),
    );
    // Semicírculo suave.
    canvas.drawArc(
      Rect.fromCircle(center: Offset(w * 0.62, h), radius: r * 0.26),
      math.pi,
      math.pi,
      true,
      Paint()..color = line,
    );
  }

  @override
  bool shouldRepaint(_ShapesPainter old) => old.accent != accent || old.line != line;
}
