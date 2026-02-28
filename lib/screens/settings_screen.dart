import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../config/constants.dart';
import '../providers/settings_provider.dart';
import '../widgets/font_size_slider.dart';
import '../widgets/theme_selector.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<SettingsProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        children: [
          const _SectionTitle('Display'),
          Card(
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.format_size),
                  title: const Text('Font Size'),
                  subtitle: Text('${settings.fontSize.round()}px'),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: FontSizeSlider(
                    value: settings.fontSize,
                    onChanged: (v) => settings.setFontSize(v),
                  ),
                ),
                const Divider(),
                ListTile(
                  leading: const Icon(Icons.font_download),
                  title: const Text('Font Family'),
                  trailing: DropdownButton<String>(
                    value: settings.fontFamily,
                    underline: const SizedBox(),
                    items: AppConstants.availableFonts
                        .map((f) => DropdownMenuItem(value: f, child: Text(f)))
                        .toList(),
                    onChanged: (v) {
                      if (v != null) settings.setFontFamily(v);
                    },
                  ),
                ),
                const Divider(),
                ListTile(
                  leading: const Icon(Icons.format_align_left),
                  title: const Text('Text Alignment'),
                  trailing: ToggleButtons(
                    isSelected: [
                      settings.textAlign == TextAlign.left,
                      settings.textAlign == TextAlign.center,
                      settings.textAlign == TextAlign.right,
                    ],
                    onPressed: (i) {
                      final aligns = [
                        TextAlign.left,
                        TextAlign.center,
                        TextAlign.right,
                      ];
                      settings.setTextAlign(aligns[i]);
                    },
                    children: const [
                      Icon(Icons.format_align_left),
                      Icon(Icons.format_align_center),
                      Icon(Icons.format_align_right),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const _SectionTitle('Theme'),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: ThemeSelector(
                selected: settings.backgroundTheme,
                onSelected: (t) => settings.setBackgroundTheme(t),
              ),
            ),
          ),
          const _SectionTitle('Reading'),
          Card(
            child: Column(
              children: [
                SwitchListTile(
                  secondary: const Icon(Icons.text_fields),
                  title: const Text('Lareevar Mode'),
                  subtitle: const Text('Remove spaces between words'),
                  value: settings.lareevarMode,
                  onChanged: settings.setLareevarMode,
                ),
                const Divider(),
                SwitchListTile(
                  secondary: const Icon(Icons.translate),
                  title: const Text('Show Hindi Transliteration'),
                  value: settings.showHindi,
                  onChanged: settings.setShowHindi,
                ),
                const Divider(),
                SwitchListTile(
                  secondary: const Icon(Icons.pause),
                  title: const Text('Show Vishraams'),
                  subtitle: const Text(
                    'Highlight pauses (orange = long, green = short)',
                  ),
                  value: settings.showVishraams,
                  onChanged: settings.setShowVishraams,
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;
  const _SectionTitle(this.title);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
      child: Text(
        title,
        style: Theme.of(context).textTheme.labelLarge?.copyWith(
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
    );
  }
}
