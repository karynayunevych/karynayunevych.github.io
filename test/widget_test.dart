import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:portfolio/app_state.dart';
import 'package:portfolio/main.dart';

void main() {
  testWidgets('muestra el nombre y cambia de idioma', (tester) async {
    tester.view.physicalSize = const Size(1440, 900);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    final controller = AppController();
    await tester.pumpWidget(PortfolioApp(controller: controller));

    expect(find.text('KARYNA'), findsOneWidget);
    expect(find.text('SOBRE MÍ'), findsOneWidget);

    controller.setLang(AppLang.uk);
    await tester.pump();
    expect(find.text('ПРО МЕНЕ'), findsOneWidget);

    controller.setMode(PortfolioMode.design);
    await tester.pump();
    expect(find.text('ГРАФІЧНА ДИЗАЙНЕРКА'), findsOneWidget);
  });
}
