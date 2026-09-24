import 'dart:ui' show PlatformDispatcher;

import 'package:flutter/widgets.dart';

/// Las dos caras del portfolio.
/// - [dev]: tema oscuro (burdeos) → programación e ingeniería informática.
/// - [design]: tema claro (butter) → diseño gráfico.
enum PortfolioMode {
  dev,
  design;

  PortfolioMode get other => this == dev ? design : dev;
  bool get isDark => this == dev;
}

/// Idiomas disponibles.
enum AppLang {
  es,
  en,
  ru,
  uk;

  String get label => name.toUpperCase();

  /// Bebas Neue no tiene letras cirílicas: en RU/UK usamos Oswald.
  bool get isCyrillic => this == ru || this == uk;
}

/// Estado global de la app: modo (tema) e idioma.
class AppController extends ChangeNotifier {
  AppController({this.mode = PortfolioMode.dev, this.lang = AppLang.es});

  /// Lee el idioma del navegador y los parámetros de la URL.
  /// Ejemplos: `?mode=design`, `?lang=uk`, `?mode=dev&lang=en`
  /// (útil para mandar a alguien directamente a una de las dos caras).
  factory AppController.fromPlatform() {
    final query = Uri.base.queryParameters;

    AppLang? parseLang(String? code) {
      if (code == null) return null;
      for (final l in AppLang.values) {
        if (l.name == code.toLowerCase()) return l;
      }
      return null;
    }

    final lang = parseLang(query['lang']) ??
        parseLang(PlatformDispatcher.instance.locale.languageCode) ??
        AppLang.es;
    final mode = query['mode'] == 'design' ? PortfolioMode.design : PortfolioMode.dev;
    return AppController(mode: mode, lang: lang);
  }

  PortfolioMode mode;
  AppLang lang;

  void setMode(PortfolioMode value) {
    if (value == mode) return;
    mode = value;
    notifyListeners();
  }

  void setLang(AppLang value) {
    if (value == lang) return;
    lang = value;
    notifyListeners();
  }
}

/// Da acceso al [AppController] desde cualquier widget.
class AppScope extends InheritedNotifier<AppController> {
  const AppScope({
    super.key,
    required AppController controller,
    required super.child,
  }) : super(notifier: controller);

  /// Lee el controlador y se reconstruye cuando cambia.
  static AppController of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<AppScope>()!.notifier!;

  /// Lee el controlador sin suscribirse (para callbacks).
  static AppController read(BuildContext context) =>
      context.getInheritedWidgetOfExactType<AppScope>()!.notifier!;
}
