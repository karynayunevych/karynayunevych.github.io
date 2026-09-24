import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../app_state.dart';
import '../theme.dart';

Future<void> openUrl(String url) async {
  await launchUrl(Uri.parse(url), webOnlyWindowName: '_blank');
}

/// Centra el contenido con un ancho máximo y márgenes laterales.
class ContentWidth extends StatelessWidget {
  const ContentWidth({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: Breakpoints.maxContent),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: Breakpoints.gutter(context)),
          child: child,
        ),
      ),
    );
  }
}

/// Bloque de sección con número y título grande.
class PortfolioSection extends StatelessWidget {
  const PortfolioSection({
    super.key,
    required this.index,
    required this.title,
    required this.child,
  });

  final int index;
  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final p = Palette.of(context);
    final mode = AppScope.of(context).mode;
    final number = index.toString().padLeft(2, '0');
    final mobile = Breakpoints.isMobile(context);

    return ContentWidth(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: mobile ? 56 : 88),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              mode.isDark ? '// $number' : '$number —',
              style: Fonts.body(context, size: 14, color: p.accent, weight: FontWeight.w500),
            ),
            const SizedBox(height: 8),
            Text(title.toUpperCase(), style: Fonts.display(context, size: mobile ? 48 : 72)),
            SizedBox(height: mobile ? 28 : 40),
            child,
          ],
        ),
      ),
    );
  }
}

/// Botón principal / secundario.
class PillButton extends StatefulWidget {
  const PillButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.filled = true,
  });

  final String label;
  final VoidCallback onPressed;
  final IconData? icon;
  final bool filled;

  @override
  State<PillButton> createState() => _PillButtonState();
}

class _PillButtonState extends State<PillButton> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    final p = Palette.of(context);
    final dark = AppScope.of(context).mode.isDark;
    final radius = BorderRadius.circular(dark ? 6 : 999);
    final fg = widget.filled ? p.onAccent : p.text;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: GestureDetector(
        onTap: widget.onPressed,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          transform: Matrix4.translationValues(0, _hover ? -2 : 0, 0),
          padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 14),
          decoration: BoxDecoration(
            color: widget.filled ? p.accent : (_hover ? p.surface : Colors.transparent),
            borderRadius: radius,
            border: Border.all(color: widget.filled ? p.accent : p.line, width: 1.5),
            boxShadow: _hover && widget.filled
                ? [BoxShadow(color: p.accent.withValues(alpha: 0.3), blurRadius: 18, offset: const Offset(0, 6))]
                : const [],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (widget.icon != null) ...[
                Icon(widget.icon, size: 18, color: fg),
                const SizedBox(width: 10),
              ],
              Text(widget.label, style: Fonts.body(context, size: 15, weight: FontWeight.w500, color: fg, height: 1.2)),
            ],
          ),
        ),
      ),
    );
  }
}

/// Etiqueta pequeña (tecnologías, habilidades…).
class TagChip extends StatelessWidget {
  const TagChip(this.label, {super.key, this.large = false});

  final String label;
  final bool large;

  @override
  Widget build(BuildContext context) {
    final p = Palette.of(context);
    final dark = AppScope.of(context).mode.isDark;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: large ? 18 : 10, vertical: large ? 10 : 5),
      decoration: BoxDecoration(
        color: large ? p.surface : Colors.transparent,
        borderRadius: BorderRadius.circular(dark ? 4 : 999),
        border: Border.all(color: p.line),
      ),
      child: Text(
        label,
        style: Fonts.body(context, size: large ? 15 : 12, color: large ? p.text : p.muted, height: 1.2),
      ),
    );
  }
}
