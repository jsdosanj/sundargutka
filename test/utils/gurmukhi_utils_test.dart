import 'package:flutter_test/flutter_test.dart';
import 'package:sundargutka/utils/gurmukhi_utils.dart';

void main() {
  group('GurmukhiUtils', () {
    group('isGurmukhi', () {
      test('returns true for Gurmukhi characters', () {
        expect(GurmukhiUtils.isGurmukhi('ਅ'), isTrue);
        expect(GurmukhiUtils.isGurmukhi('ਸ'), isTrue);
        expect(GurmukhiUtils.isGurmukhi('ਕ'), isTrue);
        expect(GurmukhiUtils.isGurmukhi('ੴ'), isTrue);
      });

      test('returns false for non-Gurmukhi characters', () {
        expect(GurmukhiUtils.isGurmukhi('A'), isFalse);
        expect(GurmukhiUtils.isGurmukhi('a'), isFalse);
        expect(GurmukhiUtils.isGurmukhi('1'), isFalse);
        expect(GurmukhiUtils.isGurmukhi(''), isFalse);
      });
    });

    group('splitIntoWords', () {
      test('splits text by spaces', () {
        final words = GurmukhiUtils.splitIntoWords('ਸਤਿ ਨਾਮੁ ਕਰਤਾ');
        expect(words.length, 3);
        expect(words[0], 'ਸਤਿ');
        expect(words[1], 'ਨਾਮੁ');
        expect(words[2], 'ਕਰਤਾ');
      });

      test('handles multiple spaces', () {
        final words = GurmukhiUtils.splitIntoWords('ਸਤਿ  ਨਾਮੁ');
        expect(words.length, 2);
      });

      test('returns empty list for empty string', () {
        final words = GurmukhiUtils.splitIntoWords('');
        expect(words, isEmpty);
      });
    });

    group('lareevarConvert', () {
      test('removes spaces between words', () {
        final result = GurmukhiUtils.lareevarConvert('ਸਤਿ ਨਾਮੁ ਕਰਤਾ');
        expect(result, 'ਸਤਿਨਾਮੁਕਰਤਾ');
      });

      test('preserves ॥ separator', () {
        final result = GurmukhiUtils.lareevarConvert('ਸਤਿ ਨਾਮੁ ॥');
        expect(result.contains('॥'), isTrue);
      });
    });

    group('wordCount', () {
      test('counts words correctly', () {
        expect(GurmukhiUtils.wordCount('ਸਤਿ ਨਾਮੁ ਕਰਤਾ'), 3);
        expect(GurmukhiUtils.wordCount('ਸਤਿ'), 1);
        expect(GurmukhiUtils.wordCount(''), 0);
      });
    });
  });
}
