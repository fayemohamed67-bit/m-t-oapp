import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

import 'package:meteo_app/core/theme/app_theme.dart';
import 'package:meteo_app/providers/theme_provider.dart';
import 'package:meteo_app/screens/home_screen.dart';

void main() {
  testWidgets("L'écran d'accueil affiche le bouton Commencer",
      (WidgetTester tester) async {
    await tester.pumpWidget(
      ChangeNotifierProvider(
        create: (_) => ThemeProvider(),
        child: MaterialApp(
          theme: AppTheme.light,
          home: const HomeScreen(),
        ),
      ),
    );

    expect(find.text('Bienvenue !'), findsOneWidget);
    expect(find.text('Commencer'), findsOneWidget);
  });
}