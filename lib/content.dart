// ─────────────────────────────────────────────────────────────
//  CONTENIDO DEL PORTFOLIO
//  Este es el archivo que más vas a tocar: aquí están todos
//  tus textos, proyectos, estudios y enlaces.
//  Cada texto va en 4 idiomas: Tr('español', 'english', 'русский', 'українська')
// ─────────────────────────────────────────────────────────────

import 'app_state.dart';
import 'i18n.dart';

/// Datos personales y enlaces.
class Profile {
  static const firstName = 'Karyna';
  static const lastName = 'Yunevych';

  static const githubUser = 'karynayunevych';
  static const githubUrl = 'https://github.com/$githubUser';

  /// Déjalo vacío ('') para ocultar el botón.
  static const email = '';
  static const linkedinUrl = '';
  static const behanceUrl = ''; // útil para la parte de diseño
  static const instagramUrl = '';

  /// Idiomas que hablas (se muestran en ambas caras).
  static const spokenLanguages = [
    Tr('Español', 'Spanish', 'Испанский', 'Іспанська'),
    Tr('Inglés', 'English', 'Английский', 'Англійська'),
    Tr('Ruso', 'Russian', 'Русский', 'Російська'),
    Tr('Ucraniano', 'Ukrainian', 'Украинский', 'Українська'),
  ];
}

class TimelineItem {
  const TimelineItem({
    required this.title,
    required this.org,
    required this.place,
    required this.period,
    this.description,
  });

  final Tr title;
  final String org;
  final Tr place;
  final Tr period;
  final Tr? description;
}

class ProjectItem {
  const ProjectItem({
    required this.title,
    required this.description,
    this.tags = const [],
    this.url,
    this.placeholder = false,
  });

  final Tr title;
  final Tr description;
  final List<String> tags;
  final String? url;

  /// true = tarjeta de "Próximamente".
  final bool placeholder;
}

/// Todo lo que cambia entre las dos caras.
class ModeContent {
  const ModeContent({
    required this.greeting,
    required this.role,
    required this.tagline,
    required this.hint,
    required this.about,
    required this.experience,
    required this.education,
    required this.skills,
    required this.projectsTitle,
    required this.projects,
  });

  final Tr greeting;
  final Tr role;
  final Tr tagline;
  final Tr hint; // invita a cambiar de tema
  final Tr about;
  final List<TimelineItem> experience;
  final List<TimelineItem> education;
  final List<Tr> skills;
  final Tr projectsTitle;
  final List<ProjectItem> projects;
}

ModeContent contentFor(PortfolioMode mode) => mode.isDark ? devContent : designContent;

// ─────────────────────────────────────────────
//  🌙 CARA OSCURA — PROGRAMACIÓN
// ─────────────────────────────────────────────
const devContent = ModeContent(
  greeting: Tr('> hola, soy', "> hi, I'm", '> привет, я', '> привіт, я'),
  role: Tr(
    'Desarrolladora de software',
    'Software developer',
    'Разработчица ПО',
    'Розробниця ПЗ',
  ),
  tagline: Tr(
    'Programo en PLANFORM y estudio Ingeniería Informática en la Universidad de Burgos.',
    'I code at PLANFORM and study Computer Engineering at the University of Burgos.',
    'Программирую в PLANFORM и изучаю компьютерную инженерию в Университете Бургоса.',
    'Програмую в PLANFORM і вивчаю комп’ютерну інженерію в Університеті Бургоса.',
  ),
  hint: Tr(
    'Esta web tiene dos caras. Cambia el tema para conocer a la diseñadora ↗',
    'This site has two sides. Switch the theme to meet the designer ↗',
    'У этого сайта две стороны. Переключи тему, чтобы увидеть дизайнерскую ↗',
    'Цей сайт має дві сторони. Перемкни тему, щоб побачити дизайнерську ↗',
  ),
  // ✏️ Cambia este texto por tu presentación
  about: Tr(
    'Soy programadora en PLANFORM y estudiante de Ingeniería Informática en la UBU. '
        'Me gusta convertir ideas en productos que funcionan de verdad, cuidando tanto el código como la experiencia de quien lo usa. '
        'Como también estudio diseño gráfico, me muevo cómoda entre los dos mundos.',
    'I work as a developer at PLANFORM and study Computer Engineering at UBU. '
        'I love turning ideas into products that actually work, caring about both the code and the experience of the people using it. '
        'Since I also study graphic design, I feel at home in both worlds.',
    'Я разработчица в PLANFORM и студентка компьютерной инженерии в UBU. '
        'Люблю превращать идеи в продукты, которые действительно работают, заботясь и о коде, и об опыте пользователя. '
        'Так как я также изучаю графический дизайн, мне комфортно в обоих мирах.',
    'Я розробниця в PLANFORM і студентка комп’ютерної інженерії в UBU. '
        'Люблю перетворювати ідеї на продукти, які справді працюють, дбаючи і про код, і про досвід користувача. '
        'Оскільки я також вивчаю графічний дизайн, мені комфортно в обох світах.',
  ),
  experience: [
    TimelineItem(
      title: Tr('Programadora', 'Developer', 'Разработчица', 'Розробниця'),
      org: 'PLANFORM',
      place: Tr('España', 'Spain', 'Испания', 'Іспанія'),
      period: Tr('Actualidad', 'Present', 'Сейчас', 'Зараз'), // ✏️ p. ej. Tr('2025 — hoy', '2025 — now', ...)
      description: Tr(
        'Desarrollo de software en el equipo de PLANFORM.',
        'Software development in the PLANFORM team.',
        'Разработка ПО в команде PLANFORM.',
        'Розробка ПЗ у команді PLANFORM.',
      ),
    ),
  ],
  education: [
    TimelineItem(
      title: Tr(
        'Grado en Ingeniería Informática',
        'BSc in Computer Engineering',
        'Бакалавриат: компьютерная инженерия',
        'Бакалаврат: комп’ютерна інженерія',
      ),
      org: 'Universidad de Burgos (UBU)',
      place: Tr('Burgos', 'Burgos', 'Бургос', 'Бургос'),
      period: Tr('En curso', 'In progress', 'В процессе', 'Триває'),
    ),
  ],
  // ✏️ Pon aquí tus tecnologías reales
  skills: [
    Tr.all('Flutter'),
    Tr.all('Dart'),
    Tr.all('Git'),
    Tr.all('GitHub'),
    Tr.all('HTML / CSS'),
    Tr.all('SQL'),
  ],
  projectsTitle: Tr('Proyectos', 'Projects', 'Проекты', 'Проєкти'),
  projects: [
    ProjectItem(
      title: Tr('Este portfolio', 'This portfolio', 'Это портфолио', 'Це портфоліо'),
      description: Tr(
        'Una web, dos caras: tema oscuro para el código y claro para el diseño. 4 idiomas.',
        'One site, two sides: dark theme for code, light theme for design. 4 languages.',
        'Один сайт, две стороны: тёмная тема для кода, светлая для дизайна. 4 языка.',
        'Один сайт, дві сторони: темна тема для коду, світла для дизайну. 4 мови.',
      ),
      tags: ['Flutter', 'Dart', 'GitHub Pages'],
      url: 'https://github.com/karynayunevych/karynayunevych.github.io',
    ),
    ProjectItem(
      title: Tr('Próximo proyecto', 'Next project', 'Следующий проект', 'Наступний проєкт'),
      description: Tr(
        'Aquí irá mi siguiente proyecto.',
        'My next project will live here.',
        'Здесь будет мой следующий проект.',
        'Тут буде мій наступний проєкт.',
      ),
      placeholder: true,
    ),
    ProjectItem(
      title: Tr('Próximo proyecto', 'Next project', 'Следующий проект', 'Наступний проєкт'),
      description: Tr(
        'Aquí irá otro proyecto.',
        'Another project will live here.',
        'Здесь будет ещё один проект.',
        'Тут буде ще один проєкт.',
      ),
      placeholder: true,
    ),
  ],
);

// ─────────────────────────────────────────────
//  ☀️ CARA CLARA — DISEÑO GRÁFICO
// ─────────────────────────────────────────────
const designContent = ModeContent(
  greeting: Tr('hola, soy', "hi, I'm", 'привет, я', 'привіт, я'),
  role: Tr(
    'Diseñadora gráfica',
    'Graphic designer',
    'Графический дизайнер',
    'Графічна дизайнерка',
  ),
  tagline: Tr(
    'Estudio Diseño Gráfico en la UOC. Aquí vive mi lado más visual.',
    'I study Graphic Design at UOC. This is where my visual side lives.',
    'Изучаю графический дизайн в UOC. Здесь живёт моя визуальная сторона.',
    'Вивчаю графічний дизайн в UOC. Тут живе моя візуальна сторона.',
  ),
  hint: Tr(
    'Esta web tiene dos caras. Cambia el tema para conocer a la programadora ↗',
    'This site has two sides. Switch the theme to meet the developer ↗',
    'У этого сайта две стороны. Переключи тему, чтобы увидеть техническую ↗',
    'Цей сайт має дві сторони. Перемкни тему, щоб побачити технічну ↗',
  ),
  // ✏️ Cambia este texto por tu presentación como diseñadora
  about: Tr(
    'Estudio Diseño Gráfico en la UOC (Universitat Oberta de Catalunya). '
        'Me interesa cómo el color, la tipografía y la composición cuentan una historia antes de leer una sola palabra. '
        'Mi parte de programadora me ayuda a pensar el diseño también como sistema.',
    'I study Graphic Design at UOC (Universitat Oberta de Catalunya). '
        'I am fascinated by how colour, type and composition tell a story before you read a single word. '
        'My developer side helps me think about design as a system too.',
    'Изучаю графический дизайн в UOC (Universitat Oberta de Catalunya). '
        'Меня увлекает, как цвет, шрифт и композиция рассказывают историю ещё до того, как прочитано хоть одно слово. '
        'Моя техническая сторона помогает мне видеть дизайн как систему.',
    'Вивчаю графічний дизайн в UOC (Universitat Oberta de Catalunya). '
        'Мене захоплює, як колір, шрифт і композиція розповідають історію ще до того, як прочитано хоч одне слово. '
        'Моя технічна сторона допомагає мені бачити дизайн як систему.',
  ),
  experience: [], // ✏️ añade aquí trabajos de diseño cuando los tengas
  education: [
    TimelineItem(
      title: Tr('Diseño Gráfico', 'Graphic Design', 'Графический дизайн', 'Графічний дизайн'),
      org: 'Universitat Oberta de Catalunya (UOC)',
      place: Tr('Barcelona', 'Barcelona', 'Барселона', 'Барселона'),
      period: Tr('En curso', 'In progress', 'В процессе', 'Триває'),
    ),
  ],
  // ✏️ Pon aquí tus habilidades y programas reales
  skills: [
    Tr('Tipografía', 'Typography', 'Типографика', 'Типографіка'),
    Tr('Color', 'Colour', 'Цвет', 'Колір'),
    Tr('Composición', 'Layout', 'Композиция', 'Композиція'),
    Tr('Identidad visual', 'Visual identity', 'Айдентика', 'Айдентика'),
    Tr.all('Figma'),
    Tr.all('Adobe Illustrator'),
  ],
  projectsTitle: Tr('Trabajos', 'Work', 'Работы', 'Роботи'),
  projects: [
    ProjectItem(
      title: Tr('Identidad visual', 'Visual identity', 'Айдентика', 'Айдентика'),
      description: Tr(
        'Muy pronto: mi primer proyecto de branding.',
        'Coming soon: my first branding project.',
        'Скоро: мой первый проект по брендингу.',
        'Незабаром: мій перший проєкт з брендингу.',
      ),
      placeholder: true,
    ),
    ProjectItem(
      title: Tr('Cartelería', 'Posters', 'Плакаты', 'Плакати'),
      description: Tr(
        'Muy pronto: una serie de carteles.',
        'Coming soon: a poster series.',
        'Скоро: серия плакатов.',
        'Незабаром: серія плакатів.',
      ),
      placeholder: true,
    ),
    ProjectItem(
      title: Tr('Editorial', 'Editorial', 'Редакционный дизайн', 'Редакційний дизайн'),
      description: Tr(
        'Muy pronto: maquetación y diseño editorial.',
        'Coming soon: layout and editorial design.',
        'Скоро: вёрстка и редакционный дизайн.',
        'Незабаром: верстка і редакційний дизайн.',
      ),
      placeholder: true,
    ),
  ],
);
