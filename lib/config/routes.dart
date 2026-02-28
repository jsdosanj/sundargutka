import 'package:flutter/material.dart';
import '../screens/about_screen.dart';
import '../screens/bani_reader_screen.dart';
import '../screens/bookmarks_screen.dart';
import '../screens/custom_list_screen.dart';
import '../screens/home_screen.dart';
import '../screens/settings_screen.dart';

class AppRoutes {
  static const String home = '/';
  static const String baniReader = '/bani-reader';
  static const String settings = '/settings';
  static const String bookmarks = '/bookmarks';
  static const String customLists = '/custom-lists';
  static const String about = '/about';

  static Map<String, WidgetBuilder> get routes => {
    home: (_) => const HomeScreen(),
    settings: (_) => const SettingsScreen(),
    bookmarks: (_) => const BookmarksScreen(),
    customLists: (_) => const CustomListScreen(),
    about: (_) => const AboutScreen(),
  };
}
