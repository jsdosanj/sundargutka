import 'package:flutter/material.dart';

class ThemeSelector extends StatelessWidget {
  final String selected;
  final ValueChanged<String> onSelected;

  const ThemeSelector({
    super.key,
    required this.selected,
    required this.onSelected,
  });

  static const _themes = [
    _ThemeOption(id: 'light', label: 'Light', color: Colors.white),
    _ThemeOption(id: 'sepia', label: 'Sepia', color: Color(0xFFF5E6C8)),
    _ThemeOption(id: 'dark', label: 'Dark', color: Color(0xFF121212)),
  ];

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: _themes.map((theme) {
        final isSelected = selected == theme.id;
        return GestureDetector(
          onTap: () => onSelected(theme.id),
          child: Column(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: theme.color,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isSelected
                        ? const Color(0xFFFF8C00)
                        : Colors.grey.withOpacity(0.5),
                    width: isSelected ? 3 : 1,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 4,
                    ),
                  ],
                ),
                child: isSelected
                    ? Icon(
                        Icons.check,
                        color: theme.id == 'dark'
                            ? Colors.white
                            : Colors.black54,
                        size: 20,
                      )
                    : null,
              ),
              const SizedBox(height: 6),
              Text(
                theme.label,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}

class _ThemeOption {
  final String id;
  final String label;
  final Color color;
  const _ThemeOption({
    required this.id,
    required this.label,
    required this.color,
  });
}
