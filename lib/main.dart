import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'app.dart';
import 'providers/bani_provider.dart';
import 'providers/bookmark_provider.dart';
import 'providers/custom_list_provider.dart';
import 'providers/settings_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final settingsProvider = SettingsProvider();
  await settingsProvider.loadSettings();

  final bookmarkProvider = BookmarkProvider();
  await bookmarkProvider.loadBookmarks();

  final customListProvider = CustomListProvider();
  await customListProvider.loadLists();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: settingsProvider),
        ChangeNotifierProvider(create: (_) => BaniProvider()),
        ChangeNotifierProvider.value(value: bookmarkProvider),
        ChangeNotifierProvider.value(value: customListProvider),
      ],
      child: const SundarGutkaApp(),
    ),
  );
}
