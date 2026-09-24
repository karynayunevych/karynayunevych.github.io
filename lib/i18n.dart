import 'package:flutter/widgets.dart';

import 'app_state.dart';

/// Un texto traducido a los 4 idiomas.
class Tr {
  const Tr(this.es, this.en, this.ru, this.uk);

  /// El mismo texto en todos los idiomas (nombres propios, tecnologías…).
  const Tr.all(String text)
      : es = text,
        en = text,
        ru = text,
        uk = text;

  final String es;
  final String en;
  final String ru;
  final String uk;

  String of(AppLang lang) => switch (lang) {
        AppLang.es => es,
        AppLang.en => en,
        AppLang.ru => ru,
        AppLang.uk => uk,
      };
}

extension TrContext on BuildContext {
  /// `context.tr(S.about)` → texto en el idioma actual.
  String tr(Tr text) => text.of(AppScope.of(this).lang);
}

/// Textos fijos de la interfaz.
class S {
  // Navegación
  static const about = Tr('Sobre mí', 'About', 'Обо мне', 'Про мене');
  static const experience = Tr('Experiencia', 'Experience', 'Опыт', 'Досвід');
  static const education = Tr('Formación', 'Education', 'Образование', 'Освіта');
  static const skills = Tr('Habilidades', 'Skills', 'Навыки', 'Навички');
  static const projects = Tr('Proyectos', 'Projects', 'Проекты', 'Проєкти');
  static const work = Tr('Trabajos', 'Work', 'Работы', 'Роботи');
  static const contact = Tr('Contacto', 'Contact', 'Контакты', 'Контакти');
  static const languages = Tr('Idiomas', 'Languages', 'Языки', 'Мови');

  // Botón de tema
  static const toDesign = Tr('Diseño', 'Design', 'Дизайн', 'Дизайн');
  static const toDev = Tr('Código', 'Code', 'Код', 'Код');
  static const switchToDesign = Tr(
    'Ver mi lado diseñadora',
    'See my designer side',
    'Моя дизайнерская сторона',
    'Моя дизайнерська сторона',
  );
  static const switchToDev = Tr(
    'Ver mi lado programadora',
    'See my developer side',
    'Моя техническая сторона',
    'Моя технічна сторона',
  );
  static const language = Tr('Idioma', 'Language', 'Язык', 'Мова');

  // Hero
  static const seeProjects = Tr('Ver proyectos', 'See projects', 'Смотреть проекты', 'Дивитися проєкти');
  static const seeWork = Tr('Ver trabajos', 'See work', 'Смотреть работы', 'Дивитися роботи');
  static const getInTouch = Tr('Contactar', 'Get in touch', 'Связаться', 'Зв’язатися');

  // Proyectos
  static const comingSoon = Tr('Próximamente', 'Coming soon', 'Скоро', 'Незабаром');
  static const inProgress = Tr('En curso', 'In progress', 'В процессе', 'Триває');
  static const present = Tr('Actualidad', 'Present', 'Сейчас', 'Зараз');

  // Contacto
  static const letsTalk = Tr('¿Hablamos?', "Let's talk?", 'Поговорим?', 'Поговоримо?');
  static const contactText = Tr(
    'Si tienes un proyecto, una oferta o simplemente quieres saludar, escríbeme.',
    'If you have a project, an offer or just want to say hi, drop me a line.',
    'Если у тебя есть проект, предложение или просто хочешь поздороваться — пиши.',
    'Якщо маєш проєкт, пропозицію або просто хочеш привітатися — пиши.',
  );

  // Footer
  static const madeWith = Tr('Hecho con Flutter', 'Made with Flutter', 'Сделано на Flutter', 'Зроблено на Flutter');
}
