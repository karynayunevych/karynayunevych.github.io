import 'package:flutter/material.dart';

import '../app_state.dart';
import '../i18n.dart';
import '../theme.dart';
import 'theme_reveal.dart';

class NavLink {
  const NavLink(this.label, this.onTap);
  final String label;
  final VoidCallback onTap;
}

/// Barra superior: logo, enlaces, idioma y botón claro/oscuro.
class NavBar extends StatelessWidget {
  const NavBar({
    super.key,
    required this.links,
    required this.onLogoTap,
    required this.onModeChanged,
  });

  static const height = 72.0;

  final List<NavLink> links;
  final VoidCallback onLogoTap;
  final VoidCallback onModeChanged;

  @override
  Widget build(BuildContext context) {
    final p = Palette.of(context);
    final wide = Breakpoints.isWide(context);
    final gutter = Breakpoints.gutter(context);

    return Container(
      height: height,
      decoration: BoxDecoration(
        color: p.bg,
        border: Border(bottom: BorderSide(color: p.line)),
      ),
      padding: EdgeInsets.symmetric(horizontal: gutter),
      child: Row(
        children: [
          _Logo(onTap: onLogoTap),
          const Spacer(),
          if (wide)
            for (final link in links) _NavTextLink(link),
          if (wide) const SizedBox(width: 16),
          const _LangSwitcher(),
          const SizedBox(width: 12),
          _ThemeToggle(onCovered: onModeChanged),
        ],
      ),
    );
  }
}

class _Logo extends StatelessWidget {
  const _Logo({required this.onTap});
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final p = Palette.of(context);
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: onTap,
        child: Text.rich(
          TextSpan(children: [
            TextSpan(text: 'KY', style: Fonts.display(context, size: 34, height: 1)),
            TextSpan(text: '.', style: Fonts.display(context, size: 34, height: 1, color: p.accent)),
          ]),
        ),
      ),
    );
  }
}

class _NavTextLink extends StatefulWidget {
  const _NavTextLink(this.link);
  final NavLink link;

  @override
  State<_NavTextLink> createState() => _NavTextLinkState();
}

class _NavTextLinkState extends State<_NavTextLink> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    final p = Palette.of(context);
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: GestureDetector(
        onTap: widget.link.onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                widget.link.label,
                style: Fonts.body(context, size: 14, color: _hover ? p.accent : p.text, height: 1.2),
              ),
              const SizedBox(height: 4),
              AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                height: 1.5,
                width: _hover ? 24 : 0,
                color: p.accent,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Selector de idioma: ES · EN · RU · UK (menú desplegable en móvil).
class _LangSwitcher extends StatelessWidget {
  const _LangSwitcher();

  @override
  Widget build(BuildContext context) {
    final app = AppScope.of(context);
    final p = Palette.of(context);

    if (Breakpoints.isMobile(context)) {
      return PopupMenuButton<AppLang>(
        tooltip: context.tr(S.language),
        initialValue: app.lang,
        color: p.surface,
        onSelected: app.setLang,
        itemBuilder: (context) => [
          for (final l in AppLang.values)
            PopupMenuItem(
              value: l,
              child: Text(
                l.label,
                style: Fonts.body(context, color: l == app.lang ? p.accent : p.text, weight: FontWeight.w500),
              ),
            ),
        ],
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            border: Border.all(color: p.line),
            borderRadius: BorderRadius.circular(999),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(app.lang.label, style: Fonts.body(context, size: 13, weight: FontWeight.w500, height: 1.2)),
              Icon(Icons.expand_more, size: 16, color: p.muted),
            ],
          ),
        ),
      );
    }

    return Semantics(
      label: context.tr(S.language),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (final l in AppLang.values)
            MouseRegion(
              cursor: SystemMouseCursors.click,
              child: GestureDetector(
                onTap: () => app.setLang(l),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  margin: const EdgeInsets.symmetric(horizontal: 2),
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                  decoration: BoxDecoration(
                    color: l == app.lang ? p.accent : Colors.transparent,
                    borderRadius: BorderRadius.circular(app.mode.isDark ? 4 : 999),
                  ),
                  child: Text(
                    l.label,
                    style: Fonts.body(
                      context,
                      size: 12,
                      weight: FontWeight.w500,
                      height: 1.2,
                      color: l == app.lang ? p.onAccent : p.muted,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

/// Botón claro/oscuro. Muestra hacia qué cara vas a ir.
class _ThemeToggle extends StatefulWidget {
  const _ThemeToggle({required this.onCovered});
  final VoidCallback onCovered;

  @override
  State<_ThemeToggle> createState() => _ThemeToggleState();
}

class _ThemeToggleState extends State<_ThemeToggle> {
  bool _hover = false;

  void _toggle() {
    final box = context.findRenderObject() as RenderBox;
    final center = box.localToGlobal(box.size.center(Offset.zero));
    ThemeReveal.of(context).toggle(center, onCovered: widget.onCovered);
  }

  @override
  Widget build(BuildContext context) {
    final app = AppScope.of(context);
    final p = Palette.of(context);
    final dark = app.mode.isDark;
    final showLabel = !Breakpoints.isMobile(context);

    return Tooltip(
      message: context.tr(dark ? S.switchToDesign : S.switchToDev),
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        onEnter: (_) => setState(() => _hover = true),
        onExit: (_) => setState(() => _hover = false),
        child: GestureDetector(
          onTap: _toggle,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            height: 42,
            padding: EdgeInsets.symmetric(horizontal: showLabel ? 16 : 10),
            decoration: BoxDecoration(
              color: _hover ? p.accent : p.surface,
              borderRadius: BorderRadius.circular(999),
              border: Border.all(color: p.accent, width: 1.5),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                AnimatedRotation(
                  turns: _hover ? 0.15 : 0,
                  duration: const Duration(milliseconds: 250),
                  child: Icon(
                    dark ? Icons.light_mode_outlined : Icons.dark_mode_outlined,
                    size: 20,
                    color: _hover ? p.onAccent : p.accent,
                  ),
                ),
                if (showLabel) ...[
                  const SizedBox(width: 8),
                  Text(
                    context.tr(dark ? S.toDesign : S.toDev).toUpperCase(),
                    style: Fonts.body(
                      context,
                      size: 13,
                      weight: FontWeight.w700,
                      height: 1.2,
                      color: _hover ? p.onAccent : p.text,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
