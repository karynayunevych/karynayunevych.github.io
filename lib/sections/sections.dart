import 'package:flutter/material.dart';

import '../app_state.dart';
import '../content.dart';
import '../i18n.dart';
import '../theme.dart';
import '../widgets/common.dart';

// ─────────────── Sobre mí ───────────────

class AboutBlock extends StatelessWidget {
  const AboutBlock({super.key, required this.content});
  final ModeContent content;

  @override
  Widget build(BuildContext context) {
    final p = Palette.of(context);
    final wide = Breakpoints.isWide(context);

    final text = Text(
      context.tr(content.about),
      style: Fonts.body(context, size: wide ? 20 : 17, height: 1.7),
    );

    final languages = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          context.tr(S.languages).toUpperCase(),
          style: Fonts.body(context, size: 13, weight: FontWeight.w700, color: p.accent),
        ),
        const SizedBox(height: 14),
        for (final l in Profile.spokenLanguages)
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Row(
              children: [
                Container(width: 6, height: 6, color: p.accent),
                const SizedBox(width: 12),
                Text(context.tr(l), style: Fonts.body(context, size: 16, height: 1.3)),
              ],
            ),
          ),
      ],
    );

    if (!wide) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [text, const SizedBox(height: 36), languages],
      );
    }
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(flex: 3, child: text),
        const SizedBox(width: 72),
        Expanded(flex: 1, child: languages),
      ],
    );
  }
}

// ─────────────── Experiencia / Formación ───────────────

class TimelineBlock extends StatelessWidget {
  const TimelineBlock({super.key, required this.items});
  final List<TimelineItem> items;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [for (final item in items) _TimelineRow(item: item)],
    );
  }
}

class _TimelineRow extends StatelessWidget {
  const _TimelineRow({required this.item});
  final TimelineItem item;

  @override
  Widget build(BuildContext context) {
    final p = Palette.of(context);
    final mobile = Breakpoints.isMobile(context);

    final period = Text(
      context.tr(item.period).toUpperCase(),
      style: Fonts.body(context, size: 13, weight: FontWeight.w500, color: p.muted, height: 1.4),
    );

    final details = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          context.tr(item.title).toUpperCase(),
          style: Fonts.display(context, size: mobile ? 30 : 38, height: 1),
        ),
        const SizedBox(height: 8),
        Text(
          '${item.org} · ${context.tr(item.place)}',
          style: Fonts.body(context, size: 15, weight: FontWeight.w500, color: p.accent, height: 1.4),
        ),
        if (item.description != null) ...[
          const SizedBox(height: 10),
          Text(context.tr(item.description!), style: Fonts.body(context, size: 15, color: p.muted)),
        ],
      ],
    );

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 28),
      decoration: BoxDecoration(border: Border(top: BorderSide(color: p.line))),
      child: mobile
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [period, const SizedBox(height: 10), details],
            )
          : Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(width: 200, child: Padding(padding: const EdgeInsets.only(top: 6), child: period)),
                Expanded(child: details),
              ],
            ),
    );
  }
}

// ─────────────── Habilidades ───────────────

class SkillsBlock extends StatelessWidget {
  const SkillsBlock({super.key, required this.skills});
  final List<Tr> skills;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: [for (final s in skills) TagChip(context.tr(s), large: true)],
    );
  }
}

// ─────────────── Proyectos / Trabajos ───────────────

class ProjectsBlock extends StatelessWidget {
  const ProjectsBlock({super.key, required this.projects});
  final List<ProjectItem> projects;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final w = constraints.maxWidth;
        final columns = w >= 880 ? 3 : (w >= 560 ? 2 : 1);
        const gap = 20.0;
        final itemWidth = (w - gap * (columns - 1)) / columns;
        return Wrap(
          spacing: gap,
          runSpacing: gap,
          children: [
            for (var i = 0; i < projects.length; i++)
              SizedBox(width: itemWidth, child: ProjectCard(project: projects[i], index: i)),
          ],
        );
      },
    );
  }
}

class ProjectCard extends StatefulWidget {
  const ProjectCard({super.key, required this.project, required this.index});
  final ProjectItem project;
  final int index;

  @override
  State<ProjectCard> createState() => _ProjectCardState();
}

class _ProjectCardState extends State<ProjectCard> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    final p = Palette.of(context);
    final dark = AppScope.of(context).mode.isDark;
    final project = widget.project;
    final clickable = project.url != null;
    final radius = BorderRadius.circular(dark ? 6 : 28);

    return MouseRegion(
      cursor: clickable ? SystemMouseCursors.click : MouseCursor.defer,
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: GestureDetector(
        onTap: clickable ? () => openUrl(project.url!) : null,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          curve: Curves.easeOut,
          transform: Matrix4.translationValues(0, _hover ? -6 : 0, 0),
          decoration: BoxDecoration(
            color: p.surface,
            borderRadius: radius,
            border: Border.all(color: _hover ? p.accent : p.line, width: 1.5),
          ),
          clipBehavior: Clip.antiAlias,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(
                height: 170,
                child: CustomPaint(
                  painter: dark
                      ? _CodeCoverPainter(p, widget.index)
                      : _DesignCoverPainter(p, widget.index),
                  child: Center(
                    child: project.placeholder
                        ? Text(
                            context.tr(S.comingSoon).toUpperCase(),
                            style: Fonts.display(context, size: 30, color: p.muted),
                          )
                        : dark
                            ? Text('</>', style: Fonts.body(context, size: 44, weight: FontWeight.w700, color: p.accent))
                            : null,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(22),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            context.tr(project.title).toUpperCase(),
                            style: Fonts.display(context, size: 30, height: 1),
                          ),
                        ),
                        if (clickable)
                          AnimatedRotation(
                            turns: _hover ? 0 : -0.125,
                            duration: const Duration(milliseconds: 220),
                            child: Icon(Icons.arrow_forward, color: p.accent),
                          ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Text(
                      context.tr(project.description),
                      style: Fonts.body(context, size: 14, color: p.muted, height: 1.5),
                    ),
                    if (project.tags.isNotEmpty) ...[
                      const SizedBox(height: 16),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [for (final t in project.tags) TagChip(t)],
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Portada de tarjeta en la cara "código": líneas tipo editor.
class _CodeCoverPainter extends CustomPainter {
  _CodeCoverPainter(this.p, this.seed);
  final Palette p;
  final int seed;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawRect(Offset.zero & size, Paint()..color = p.bg);
    final paint = Paint();
    const widths = [0.42, 0.66, 0.3, 0.55, 0.74, 0.38, 0.5];
    var y = 22.0;
    var i = seed;
    while (y < size.height - 12) {
      final indent = (i % 3) * 18.0;
      final w = widths[i % widths.length] * (size.width - 60);
      paint.color = (i % 4 == 0 ? p.accent : p.line).withValues(alpha: i % 4 == 0 ? 0.35 : 0.8);
      canvas.drawRRect(
        RRect.fromRectAndRadius(Rect.fromLTWH(24 + indent, y, w, 7), const Radius.circular(4)),
        paint,
      );
      y += 18;
      i++;
    }
  }

  @override
  bool shouldRepaint(_CodeCoverPainter old) => old.p != p || old.seed != seed;
}

/// Portada de tarjeta en la cara "diseño": composición geométrica.
class _DesignCoverPainter extends CustomPainter {
  _DesignCoverPainter(this.p, this.seed);
  final Palette p;
  final int seed;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawRect(Offset.zero & size, Paint()..color = p.line.withValues(alpha: 0.45));
    final w = size.width;
    final h = size.height;
    final accent = Paint()..color = p.accent.withValues(alpha: 0.85);
    final soft = Paint()..color = p.bg;

    switch (seed % 3) {
      case 0:
        canvas.drawCircle(Offset(w * 0.75, h * 0.5), h * 0.42, accent);
        canvas.drawRect(Rect.fromLTWH(w * 0.08, h * 0.2, w * 0.32, h * 0.6), soft);
      case 1:
        canvas.drawRect(Rect.fromLTWH(w * 0.55, 0, w * 0.45, h), accent);
        canvas.drawCircle(Offset(w * 0.3, h * 0.55), h * 0.3, soft);
      default:
        final path = Path()
          ..moveTo(w * 0.15, h)
          ..lineTo(w * 0.5, h * 0.12)
          ..lineTo(w * 0.85, h)
          ..close();
        canvas.drawPath(path, accent);
        canvas.drawCircle(Offset(w * 0.5, h * 0.72), h * 0.14, soft);
    }
  }

  @override
  bool shouldRepaint(_DesignCoverPainter old) => old.p != p || old.seed != seed;
}

// ─────────────── Contacto ───────────────

class ContactBlock extends StatelessWidget {
  const ContactBlock({super.key});

  @override
  Widget build(BuildContext context) {
    final p = Palette.of(context);
    final mobile = Breakpoints.isMobile(context);
    final dark = AppScope.of(context).mode.isDark;

    return ContentWidth(
      child: Container(
        margin: EdgeInsets.only(bottom: mobile ? 56 : 88),
        padding: EdgeInsets.all(mobile ? 28 : 56),
        decoration: BoxDecoration(
          color: p.accent,
          borderRadius: BorderRadius.circular(dark ? 8 : 40),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              context.tr(S.letsTalk).toUpperCase(),
              style: Fonts.display(context, size: mobile ? 56 : 96, color: p.onAccent),
            ),
            const SizedBox(height: 16),
            ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 560),
              child: Text(
                context.tr(S.contactText),
                style: Fonts.body(context, size: mobile ? 16 : 18, color: p.onAccent),
              ),
            ),
            const SizedBox(height: 32),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                if (Profile.email.isNotEmpty)
                  _ContactButton(
                    icon: Icons.mail_outline,
                    label: Profile.email,
                    url: 'mailto:${Profile.email}',
                  ),
                const _ContactButton(icon: Icons.code, label: 'GitHub', url: Profile.githubUrl),
                if (Profile.linkedinUrl.isNotEmpty)
                  const _ContactButton(icon: Icons.work_outline, label: 'LinkedIn', url: Profile.linkedinUrl),
                if (Profile.behanceUrl.isNotEmpty)
                  const _ContactButton(icon: Icons.palette_outlined, label: 'Behance', url: Profile.behanceUrl),
                if (Profile.instagramUrl.isNotEmpty)
                  const _ContactButton(icon: Icons.camera_alt_outlined, label: 'Instagram', url: Profile.instagramUrl),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _ContactButton extends StatefulWidget {
  const _ContactButton({required this.icon, required this.label, required this.url});
  final IconData icon;
  final String label;
  final String url;

  @override
  State<_ContactButton> createState() => _ContactButtonState();
}

class _ContactButtonState extends State<_ContactButton> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    final p = Palette.of(context);
    final dark = AppScope.of(context).mode.isDark;
    // Sobre el bloque de acento: invertimos colores.
    final fg = _hover ? p.accent : p.onAccent;
    final bg = _hover ? p.onAccent : Colors.transparent;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: GestureDetector(
        onTap: () => openUrl(widget.url),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 13),
          decoration: BoxDecoration(
            color: bg,
            borderRadius: BorderRadius.circular(dark ? 6 : 999),
            border: Border.all(color: p.onAccent, width: 1.5),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(widget.icon, size: 18, color: fg),
              const SizedBox(width: 10),
              Text(widget.label, style: Fonts.body(context, size: 15, weight: FontWeight.w500, color: fg, height: 1.2)),
            ],
          ),
        ),
      ),
    );
  }
}

// ─────────────── Footer ───────────────

class Footer extends StatelessWidget {
  const Footer({super.key});

  @override
  Widget build(BuildContext context) {
    final p = Palette.of(context);
    final year = DateTime.now().year;
    return Container(
      decoration: BoxDecoration(border: Border(top: BorderSide(color: p.line))),
      padding: const EdgeInsets.symmetric(vertical: 28),
      child: ContentWidth(
        child: Wrap(
          alignment: WrapAlignment.spaceBetween,
          spacing: 16,
          runSpacing: 8,
          children: [
            Text(
              '© $year ${Profile.firstName} ${Profile.lastName}',
              style: Fonts.body(context, size: 13, color: p.muted),
            ),
            Text(context.tr(S.madeWith), style: Fonts.body(context, size: 13, color: p.muted)),
          ],
        ),
      ),
    );
  }
}
