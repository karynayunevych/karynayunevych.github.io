import 'package:flutter/material.dart';

import 'app_state.dart';
import 'pages/home_page.dart';
import 'theme.dart';
import 'widgets/theme_reveal.dart';

void main() {
  runApp(PortfolioApp(controller: AppController.fromPlatform()));
}

class PortfolioApp extends StatelessWidget {
  const PortfolioApp({super.key, required this.controller});

  final AppController controller;

  @override
  Widget build(BuildContext context) {
    return AppScope(
      controller: controller,
      child: ListenableBuilder(
        listenable: controller,
        builder: (context, _) => MaterialApp(
          title: 'Karyna Yunevych',
          debugShowCheckedModeBanner: false,
          theme: buildTheme(controller.mode),
          builder: (context, child) => ThemeReveal(child: child!),
          home: const HomePage(),
        ),
      ),
    );
  }
}
