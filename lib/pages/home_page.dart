import 'package:flutter/material.dart';

import '../app_state.dart';
import '../content.dart';
import '../i18n.dart';
import '../sections/hero.dart';
import '../sections/sections.dart';
import '../widgets/common.dart';
import '../widgets/nav_bar.dart';

enum _Section { about, experience, education, skills, projects, contact }

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _scroll = ScrollController();
  final _keys = {for (final s in _Section.values) s: GlobalKey()};

  @override
  void dispose() {
    _scroll.dispose();
    super.dispose();
  }

  void _goTo(_Section section) {
    final ctx = _keys[section]!.currentContext;
    if (ctx == null) return;
    Scrollable.ensureVisible(
      ctx,
      duration: const Duration(milliseconds: 700),
      curve: Curves.easeInOutCubic,
    );
  }

  void _toTop() {
    if (_scroll.hasClients) {
      _scroll.animateTo(0, duration: const Duration(milliseconds: 600), curve: Curves.easeInOutCubic);
    }
  }

  @override
  Widget build(BuildContext context) {
    final app = AppScope.of(context);
    final content = contentFor(app.mode);
    final hasExperience = content.experience.isNotEmpty;

    // Numeración de secciones (01, 02…) según las que existan.
    var n = 0;
    int next() => ++n;

    final links = <NavLink>[
      NavLink(context.tr(S.about), () => _goTo(_Section.about)),
      if (hasExperience) NavLink(context.tr(S.experience), () => _goTo(_Section.experience)),
      NavLink(context.tr(S.education), () => _goTo(_Section.education)),
      NavLink(context.tr(S.skills), () => _goTo(_Section.skills)),
      NavLink(context.tr(content.projectsTitle), () => _goTo(_Section.projects)),
      NavLink(context.tr(S.contact), () => _goTo(_Section.contact)),
    ];

    return Scaffold(
      body: Column(
        children: [
          NavBar(
            links: links,
            onLogoTap: _toTop,
            // Al cambiar de cara, volvemos arriba: es "otra" página.
            onModeChanged: () {
              if (_scroll.hasClients) _scroll.jumpTo(0);
            },
          ),
          Expanded(
            child: SingleChildScrollView(
              controller: _scroll,
              child: Column(
                children: [
                  HeroSection(
                    content: content,
                    onPrimary: () => _goTo(_Section.projects),
                    onContact: () => _goTo(_Section.contact),
                  ),
                  PortfolioSection(
                    key: _keys[_Section.about],
                    index: next(),
                    title: context.tr(S.about),
                    child: AboutBlock(content: content),
                  ),
                  if (hasExperience)
                    PortfolioSection(
                      key: _keys[_Section.experience],
                      index: next(),
                      title: context.tr(S.experience),
                      child: TimelineBlock(items: content.experience),
                    ),
                  PortfolioSection(
                    key: _keys[_Section.education],
                    index: next(),
                    title: context.tr(S.education),
                    child: TimelineBlock(items: content.education),
                  ),
                  PortfolioSection(
                    key: _keys[_Section.skills],
                    index: next(),
                    title: context.tr(S.skills),
                    child: SkillsBlock(skills: content.skills),
                  ),
                  PortfolioSection(
                    key: _keys[_Section.projects],
                    index: next(),
                    title: context.tr(content.projectsTitle),
                    child: ProjectsBlock(projects: content.projects),
                  ),
                  KeyedSubtree(key: _keys[_Section.contact], child: const ContactBlock()),
                  const Footer(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
