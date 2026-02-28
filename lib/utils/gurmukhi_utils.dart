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
    return splitIntoWords(text).where((w) => isGurmukhi(w[0])).toList();
  }

  /// Counts the number of words in a Gurmukhi string.
  static int wordCount(String text) => splitIntoWords(text).length;
}
