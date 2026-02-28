import 'package:characters/characters.dart';

/// Basic transliteration utilities for Gurmukhi.
/// Full transliteration requires a comprehensive mapping table.
/// This is a placeholder for future implementation.
class TransliterationUtils {
  /// Basic Gurmukhi to Latin transliteration map (partial).
  static const Map<String, String> _gurmukhiToLatin = {
    'ਅ': 'a',
    'ਆ': 'aa',
    'ਇ': 'i',
    'ਈ': 'ee',
    'ਉ': 'u',
    'ਊ': 'oo',
    'ਏ': 'e',
    'ਐ': 'ai',
    'ਓ': 'o',
    'ਔ': 'au',
    'ਕ': 'k',
    'ਖ': 'kh',
    'ਗ': 'g',
    'ਘ': 'gh',
    'ਚ': 'ch',
    'ਛ': 'chh',
    'ਜ': 'j',
    'ਝ': 'jh',
    'ਟ': 't',
    'ਠ': 'th',
    'ਡ': 'd',
    'ਢ': 'dh',
    'ਣ': 'n',
    'ਤ': 't',
    'ਥ': 'th',
    'ਦ': 'd',
    'ਧ': 'dh',
    'ਨ': 'n',
    'ਪ': 'p',
    'ਫ': 'ph',
    'ਬ': 'b',
    'ਭ': 'bh',
    'ਮ': 'm',
    'ਯ': 'y',
    'ਰ': 'r',
    'ਲ': 'l',
    'ਵ': 'v',
    'ਸ': 's',
    'ਹ': 'h',
  };

  /// Attempts a basic character-by-character transliteration.
  /// For production use, integrate with a full transliteration library.
  static String toRoman(String gurmukhi) {
    final buffer = StringBuffer();
    for (final char in gurmukhi.characters) {
      buffer.write(_gurmukhiToLatin[char] ?? char);
    }
    return buffer.toString();
  }

  /// Placeholder: returns the text unchanged until full implementation.
  static String toDevanagari(String gurmukhi) => gurmukhi;
}
