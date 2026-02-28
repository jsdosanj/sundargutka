import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'config/routes.dart';
import 'config/theme.dart';
import 'providers/settings_provider.dart';
import 'screens/home_screen.dart';

class SundarGutkaApp extends StatelessWidget {
  const SundarGutkaApp({super.key});

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<SettingsProvider>();

    ThemeData themeData;
    switch (settings.backgroundTheme) {
      case 'sepia':
        themeData = AppTheme.sepiaTheme;
        break;
      case 'dark':
        themeData = AppTheme.darkTheme;
        break;
      default:
        themeData = AppTheme.lightTheme;
    }

    return MaterialApp(
      title: 'Sundar Gutka',
      debugShowCheckedModeBanner: false,
      theme: themeData,
      routes: AppRoutes.routes,
      home: const HomeScreen(),
    );
  }
}
