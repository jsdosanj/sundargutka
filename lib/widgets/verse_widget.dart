import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/verse.dart';
import '../providers/settings_provider.dart';
import '../utils/gurmukhi_utils.dart';
import 'vishraam_text.dart';

class VerseWidget extends StatelessWidget {
  final Verse verse;
  final int index;
  final String baniId;

  const VerseWidget({
    super.key,
    required this.verse,
    required this.index,
    required this.baniId,
  });

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<SettingsProvider>();

    final gurmukhiText = settings.lareevarMode
        ? GurmukhiUtils.lareevarConvert(verse.gurmukhi)
        : verse.gurmukhi;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (verse.section != null) ...[
            Text(
              verse.section!,
              style: TextStyle(
                  fontSize: 11,
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.5),
            ),
            const SizedBox(height: 4),
          ],
          settings.showVishraams && !settings.lareevarMode
              ? VishraamText(
                  text: gurmukhiText,
                  vishraams: verse.vishraams,
                  fontSize: settings.fontSize,
                  fontFamily: settings.fontFamily,
                  textAlign: settings.textAlign,
                )
              : Text(
                  gurmukhiText,
                  style: TextStyle(
                    fontSize: settings.fontSize,
                    fontFamily: settings.fontFamily,
                    height: 1.8,
                  ),
                  textAlign: settings.textAlign,
                ),
          if (settings.showHindi && verse.hindi != null) ...[
            const SizedBox(height: 4),
            Text(
              verse.hindi!,
              style: TextStyle(
                fontSize: settings.fontSize * 0.75,
                color: Theme.of(context)
                    .textTheme
                    .bodyMedium
                    ?.color
                    ?.withOpacity(0.7),
                height: 1.6,
              ),
              textAlign: settings.textAlign,
            ),
          ],
          const Divider(height: 16),
        ],
      ),
    );
  }
}
