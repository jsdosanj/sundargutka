import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/settings_provider.dart';

class ReaderToolbar extends StatelessWidget {
  final VoidCallback onScrollToTop;

  const ReaderToolbar({super.key, required this.onScrollToTop});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        FloatingActionButton.small(
          heroTag: 'scroll_top',
          onPressed: onScrollToTop,
          tooltip: 'Scroll to top',
          child: const Icon(Icons.keyboard_arrow_up),
        ),
        const SizedBox(height: 8),
        FloatingActionButton(
          heroTag: 'reader_settings',
          onPressed: () => _showSettings(context),
          tooltip: 'Reader settings',
          child: const Icon(Icons.text_fields),
        ),
      ],
    );
  }

  void _showSettings(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) => ChangeNotifierProvider.value(
        value: context.read<SettingsProvider>(),
        child: const _ReaderSettingsSheet(),
      ),
    );
  }
}

class _ReaderSettingsSheet extends StatelessWidget {
  const _ReaderSettingsSheet();

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<SettingsProvider>();
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              const Icon(Icons.format_size),
              const SizedBox(width: 8),
              const Text('Font Size'),
              Expanded(
                child: Slider(
                  value: settings.fontSize,
                  min: 14,
                  max: 36,
                  onChanged: settings.setFontSize,
                ),
              ),
              Text('${settings.fontSize.round()}'),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _ThemeButton(
                label: 'Light',
                color: Colors.white,
                selected: settings.backgroundTheme == 'light',
                onTap: () => settings.setBackgroundTheme('light'),
              ),
              _ThemeButton(
                label: 'Sepia',
                color: const Color(0xFFF5E6C8),
                selected: settings.backgroundTheme == 'sepia',
                onTap: () => settings.setBackgroundTheme('sepia'),
              ),
              _ThemeButton(
                label: 'Dark',
                color: const Color(0xFF121212),
                selected: settings.backgroundTheme == 'dark',
                onTap: () => settings.setBackgroundTheme('dark'),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _ToggleChip(
                label: 'Vishraams',
                selected: settings.showVishraams,
                onTap: () => settings.setShowVishraams(!settings.showVishraams),
              ),
              _ToggleChip(
                label: 'Hindi',
                selected: settings.showHindi,
                onTap: () => settings.setShowHindi(!settings.showHindi),
              ),
              _ToggleChip(
                label: 'Lareevar',
                selected: settings.lareevarMode,
                onTap: () => settings.setLareevarMode(!settings.lareevarMode),
              ),
            ],
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}

class _ThemeButton extends StatelessWidget {
  final String label;
  final Color color;
  final bool selected;
  final VoidCallback onTap;

  const _ThemeButton({
    required this.label,
    required this.color,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
              border: Border.all(
                color: selected
                    ? const Color(0xFFFF8C00)
                    : Colors.grey.withOpacity(0.4),
                width: selected ? 3 : 1,
              ),
            ),
          ),
          const SizedBox(height: 4),
          Text(label, style: const TextStyle(fontSize: 11)),
        ],
      ),
    );
  }
}

class _ToggleChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _ToggleChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return FilterChip(
      label: Text(label),
      selected: selected,
      onSelected: (_) => onTap(),
    );
  }
}
