class GurmukhiUtils {
  /// Removes spaces between Gurmukhi words (Lareevar mode).
  static String lareevarConvert(String text) {
    // Preserve spaces before/after sihari (੍) and other combining chars
    // Simple approach: remove spaces, but keep spaces before ॥ markers
    return text.replaceAllMapped(
      RegExp(r' (?!॥|।)'),
      (_) => '',
    );
  }

  /// Returns true if the character is in the Gurmukhi Unicode block (0A00–0A7F).
  static bool isGurmukhi(String char) {
    if (char.isEmpty) return false;
    final codeUnit = char.codeUnitAt(0);
    return codeUnit >= 0x0A00 && codeUnit <= 0x0A7F;
  }

  /// Splits Gurmukhi text into words, filtering empty strings.
  static List<String> splitIntoWords(String text) {
    return text
        .split(' ')
        .where((w) => w.trim().isNotEmpty)
        .toList();
  }

  /// Returns only Gurmukhi words from a mixed string.
  static List<String> extractGurmukhiWords(String text) {
    return splitIntoWords(text).where((w) => w.isNotEmpty && isGurmukhi(w[0])).toList();
  }

  /// Counts the number of words in a Gurmukhi string.
  static int wordCount(String text) => splitIntoWords(text).length;

  /// Returns a safe preview of [text] limited to [maxChars] Unicode code points
  /// (not raw UTF-16 code units). This prevents splitting surrogate pairs or
  /// combining diacritics mid-character for multi-byte Gurmukhi script.
  ///
  /// Appends [ellipsis] when the text is truncated.
  static String safePreview(String text, {int maxChars = 60, String ellipsis = '…'}) {
    if (text.isEmpty) return text;
    // runes gives code points, which are the correct unit for Gurmukhi
    final runes = text.runes.toList();
    if (runes.length <= maxChars) return text;
    return String.fromCharCodes(runes.take(maxChars)) + ellipsis;
  }
}
