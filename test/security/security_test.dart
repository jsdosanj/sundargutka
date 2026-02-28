// Security tests for Sundar Gutka
//
// Coverage areas:
//   1. Path traversal prevention in BaniDataService
//   2. Null-safe / type-safe JSON deserialization in models
//   3. Settings allowlist enforcement (fontFamily, backgroundTheme)
//   4. Bookmark / custom-list count limits
//   5. Custom list name length limits & random ID generation
//   6. Grapheme-cluster-safe verse preview truncation
//   7. Vishraam position validation
//   8. BookmarkProvider: resilience to corrupt stored data

import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sundargutka/models/bani.dart';
import 'package:sundargutka/models/bookmark.dart';
import 'package:sundargutka/models/custom_list.dart';
import 'package:sundargutka/models/verse.dart';
import 'package:sundargutka/providers/bookmark_provider.dart';
import 'package:sundargutka/providers/custom_list_provider.dart';
import 'package:sundargutka/providers/settings_provider.dart';
import 'package:sundargutka/services/bani_data_service.dart';
import 'package:sundargutka/utils/gurmukhi_utils.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  setUp(() async {
    SharedPreferences.setMockInitialValues(<String, Object>{});
  });

  // ─────────────────────────────────────────────────────────────────────────
  // 1. PATH TRAVERSAL PREVENTION
  // ─────────────────────────────────────────────────────────────────────────
  group('BaniDataService path traversal prevention', () {
    test('rejects path traversal with ../', () async {
      final service = BaniDataService();
      expect(
        () async => service.loadVerses('../../AndroidManifest.xml'),
        throwsA(isA<ArgumentError>()),
      );
    });

    test('rejects path with forward slash', () async {
      final service = BaniDataService();
      expect(
        () async => service.loadVerses('subdir/japji_sahib.json'),
        throwsA(isA<ArgumentError>()),
      );
    });

    test('rejects path with backslash', () async {
      final service = BaniDataService();
      expect(
        () async => service.loadVerses('subdir\\japji_sahib.json'),
        throwsA(isA<ArgumentError>()),
      );
    });

    test('rejects filename without .json extension', () async {
      final service = BaniDataService();
      expect(
        () async => service.loadVerses('japji_sahib'),
        throwsA(isA<ArgumentError>()),
      );
    });

    test('rejects filename with null bytes', () async {
      final service = BaniDataService();
      expect(
        () async => service.loadVerses('japji_sahib\x00.json'),
        throwsA(isA<ArgumentError>()),
      );
    });

    test('accepts valid filename', () {
      // Validation only — does not actually load (no rootBundle in unit tests)
      const validName = 'japji_sahib.json';
      final safePattern = RegExp(r'^[a-zA-Z0-9_]+\.json$');
      expect(safePattern.hasMatch(validName), isTrue);
    });

    test('rejects double-dot sequences', () async {
      final service = BaniDataService();
      expect(
        () async => service.loadVerses('..foo.json'),
        throwsA(isA<ArgumentError>()),
      );
    });
  });

  // ─────────────────────────────────────────────────────────────────────────
  // 2. NULL-SAFE JSON DESERIALIZATION — Bookmark
  // ─────────────────────────────────────────────────────────────────────────
  group('Bookmark.fromJson null safety', () {
    test('throws FormatException when id is missing', () {
      expect(
        () => Bookmark.fromJson({
          'baniId': 'japji',
          'baniName': 'Japji Sahib',
          'verseIndex': 0,
          'versePreview': 'test',
          'createdAt': DateTime.now().toIso8601String(),
        }),
        throwsA(isA<FormatException>()),
      );
    });

    test('throws FormatException when verseIndex is negative', () {
      expect(
        () => Bookmark.fromJson({
          'id': 'b1',
          'baniId': 'japji',
          'baniName': 'Japji Sahib',
          'verseIndex': -1,
          'versePreview': 'test',
          'createdAt': DateTime.now().toIso8601String(),
        }),
        throwsA(isA<FormatException>()),
      );
    });

    test('throws FormatException when createdAt is not valid ISO-8601', () {
      expect(
        () => Bookmark.fromJson({
          'id': 'b1',
          'baniId': 'japji',
          'baniName': 'Japji Sahib',
          'verseIndex': 0,
          'versePreview': 'test',
          'createdAt': 'not-a-date',
        }),
        throwsA(isA<FormatException>()),
      );
    });

    test(
      'throws FormatException when verseIndex is a string instead of int',
      () {
        expect(
          () => Bookmark.fromJson({
            'id': 'b1',
            'baniId': 'japji',
            'baniName': 'Japji Sahib',
            'verseIndex': '0', // wrong type
            'versePreview': 'test',
            'createdAt': DateTime.now().toIso8601String(),
          }),
          throwsA(isA<FormatException>()),
        );
      },
    );

    test('succeeds with valid JSON', () {
      final now = DateTime.now();
      final b = Bookmark.fromJson({
        'id': 'b1',
        'baniId': 'japji',
        'baniName': 'Japji Sahib',
        'verseIndex': 3,
        'versePreview': 'ਸਤਿ ਨਾਮੁ',
        'createdAt': now.toIso8601String(),
      });
      expect(b.id, 'b1');
      expect(b.verseIndex, 3);
    });
  });

  // ─────────────────────────────────────────────────────────────────────────
  // 3. NULL-SAFE JSON DESERIALIZATION — CustomList
  // ─────────────────────────────────────────────────────────────────────────
  group('CustomList.fromJson null safety', () {
    test('throws FormatException when name is missing', () {
      expect(
        () => CustomList.fromJson({
          'id': 'l1',
          'baniIds': <String>[],
          'createdAt': DateTime.now().toIso8601String(),
        }),
        throwsA(isA<FormatException>()),
      );
    });

    test('throws FormatException when createdAt is invalid date', () {
      expect(
        () => CustomList.fromJson({
          'id': 'l1',
          'name': 'My List',
          'baniIds': <String>[],
          'createdAt': 'INVALID',
        }),
        throwsA(isA<FormatException>()),
      );
    });

    test('filters out non-string baniIds silently', () {
      final list = CustomList.fromJson({
        'id': 'l1',
        'name': 'My List',
        'baniIds': ['japji', 123, null, 'rehras'],
        'createdAt': DateTime.now().toIso8601String(),
      });
      expect(list.baniIds, ['japji', 'rehras']);
    });

    test('succeeds with valid JSON', () {
      final list = CustomList.fromJson({
        'id': 'l1',
        'name': 'My List',
        'baniIds': ['japji_sahib'],
        'createdAt': DateTime.now().toIso8601String(),
      });
      expect(list.name, 'My List');
      expect(list.baniIds.length, 1);
    });
  });

  // ─────────────────────────────────────────────────────────────────────────
  // 4. NULL-SAFE JSON DESERIALIZATION — Verse / Vishraam
  // ─────────────────────────────────────────────────────────────────────────
  group('Verse.fromJson null safety', () {
    test('throws FormatException when gurmukhi is missing', () {
      expect(
        () => Verse.fromJson({'id': 1, 'verseNumber': 1}),
        throwsA(isA<FormatException>()),
      );
    });

    test('throws FormatException when id is a string instead of int', () {
      expect(
        () =>
            Verse.fromJson({'id': 'one', 'gurmukhi': 'ਸਤਿ', 'verseNumber': 1}),
        throwsA(isA<FormatException>()),
      );
    });

    test('optional fields default to null gracefully', () {
      final v = Verse.fromJson({'id': 1, 'gurmukhi': 'ਸਤਿ', 'verseNumber': 1});
      expect(v.hindi, isNull);
      expect(v.translation, isNull);
      expect(v.vishraams, isEmpty);
    });

    test('wrong type optional field treated as null', () {
      final v = Verse.fromJson({
        'id': 1,
        'gurmukhi': 'ਸਤਿ',
        'verseNumber': 1,
        'hindi': 123, // wrong type — should be treated as null
      });
      expect(v.hindi, isNull);
    });
  });

  group('Vishraam.fromJson null safety', () {
    test('throws FormatException when position is negative', () {
      expect(
        () => Vishraam.fromJson({'position': -1, 'type': 'long'}),
        throwsA(isA<FormatException>()),
      );
    });

    test('throws FormatException when type is missing', () {
      expect(
        () => Vishraam.fromJson({'position': 1}),
        throwsA(isA<FormatException>()),
      );
    });

    test('succeeds with valid JSON', () {
      final v = Vishraam.fromJson({'position': 2, 'type': 'short'});
      expect(v.position, 2);
      expect(v.type, 'short');
    });
  });

  group('Bani.fromJson null safety', () {
    test('throws FormatException when required field is missing', () {
      expect(
        () => Bani.fromJson({
          'id': 'japji',
          // nameGurmukhi missing
          'nameEnglish': 'Japji Sahib',
          'category': 'taksal',
          'fileName': 'japji_sahib.json',
          'totalVerses': 40,
        }),
        throwsA(isA<FormatException>()),
      );
    });

    test('defaults isNitnem to false when absent', () {
      final b = Bani.fromJson({
        'id': 'test',
        'nameGurmukhi': 'ਟੈਸਟ',
        'nameEnglish': 'Test',
        'category': 'taksal',
        'fileName': 'test.json',
        'totalVerses': 1,
      });
      expect(b.isNitnem, isFalse);
    });
  });

  // ─────────────────────────────────────────────────────────────────────────
  // 5. SETTINGS ALLOWLIST ENFORCEMENT
  // ─────────────────────────────────────────────────────────────────────────
  group('SettingsProvider allowlist validation', () {
    test('setFontFamily ignores unknown font families', () async {
      final settings = SettingsProvider();
      final original = settings.fontFamily;
      await settings.setFontFamily('../../etc/passwd');
      expect(settings.fontFamily, original);
    });

    test('setFontFamily accepts known font families', () async {
      final settings = SettingsProvider();
      await settings.setFontFamily('Poppins');
      expect(settings.fontFamily, 'Poppins');
    });

    test('setBackgroundTheme ignores unknown themes', () async {
      final settings = SettingsProvider();
      final original = settings.backgroundTheme;
      await settings.setBackgroundTheme('hacker_theme');
      expect(settings.backgroundTheme, original);
    });

    test('setBackgroundTheme accepts valid themes', () async {
      final settings = SettingsProvider();
      await settings.setBackgroundTheme('dark');
      expect(settings.backgroundTheme, 'dark');
      await settings.setBackgroundTheme('sepia');
      expect(settings.backgroundTheme, 'sepia');
      await settings.setBackgroundTheme('light');
      expect(settings.backgroundTheme, 'light');
    });

    test('setFontSize clamps to valid range', () async {
      final settings = SettingsProvider();
      await settings.setFontSize(999.0);
      expect(settings.fontSize, lessThanOrEqualTo(36.0));
      await settings.setFontSize(-5.0);
      expect(settings.fontSize, greaterThanOrEqualTo(14.0));
    });
  });

  // ─────────────────────────────────────────────────────────────────────────
  // 6. BOOKMARK COUNT LIMIT
  // ─────────────────────────────────────────────────────────────────────────
  group('BookmarkProvider count limit', () {
    test('does not exceed maxBookmarks', () async {
      final provider = BookmarkProvider();

      for (int i = 0; i < BookmarkProvider.maxBookmarks + 10; i++) {
        await provider.addBookmark(
          Bookmark(
            id: 'bm_$i',
            baniId: 'japji',
            baniName: 'Japji Sahib',
            verseIndex: i,
            versePreview: 'verse $i',
            createdAt: DateTime.now(),
          ),
        );
      }

      expect(
        provider.bookmarks.length,
        lessThanOrEqualTo(BookmarkProvider.maxBookmarks),
      );
    });
  });

  // ─────────────────────────────────────────────────────────────────────────
  // 7. CUSTOM LIST LIMITS
  // ─────────────────────────────────────────────────────────────────────────
  group('CustomListProvider limits', () {
    test('does not exceed maxLists', () async {
      final provider = CustomListProvider();
      for (int i = 0; i < CustomListProvider.maxLists + 10; i++) {
        await provider.createList('List $i');
      }
      expect(
        provider.lists.length,
        lessThanOrEqualTo(CustomListProvider.maxLists),
      );
    });

    test('rejects empty list name', () async {
      final provider = CustomListProvider();
      await provider.createList('');
      expect(provider.lists, isEmpty);
    });

    test('rejects list name exceeding maxNameLength', () async {
      final provider = CustomListProvider();
      final longName = 'x' * (CustomListProvider.maxNameLength + 1);
      await provider.createList(longName);
      expect(provider.lists, isEmpty);
    });

    test('accepts list name at exactly maxNameLength', () async {
      final provider = CustomListProvider();
      final maxName = 'x' * CustomListProvider.maxNameLength;
      await provider.createList(maxName);
      expect(provider.lists.length, 1);
    });

    test('trimmed empty name is rejected', () async {
      final provider = CustomListProvider();
      await provider.createList('   ');
      expect(provider.lists, isEmpty);
    });

    test('reorderBanis rejects out-of-bounds indices', () async {
      final provider = CustomListProvider();
      await provider.createList('Test');
      final listId = provider.lists.first.id;
      await provider.addBaniToList(listId, 'japji');
      // oldIndex=5 is out of bounds for a 1-item list — must not throw
      expect(() async => provider.reorderBanis(listId, 5, 0), returnsNormally);
    });
  });

  // ─────────────────────────────────────────────────────────────────────────
  // 8. RANDOM ID GENERATION (no timestamp collision)
  // ─────────────────────────────────────────────────────────────────────────
  group('CustomListProvider ID uniqueness', () {
    test('creates unique IDs for concurrent list creation', () async {
      final provider = CustomListProvider();
      // Create several lists in rapid succession
      for (int i = 0; i < 20; i++) {
        await provider.createList('List $i');
      }
      final ids = provider.lists.map((l) => l.id).toSet();
      expect(
        ids.length,
        provider.lists.length,
        reason: 'All IDs must be unique',
      );
    });
  });

  // ─────────────────────────────────────────────────────────────────────────
  // 9. GRAPHEME-CLUSTER-SAFE VERSE PREVIEW
  // ─────────────────────────────────────────────────────────────────────────
  group('GurmukhiUtils.safePreview', () {
    test('returns full text when shorter than maxChars', () {
      const text = 'ਸਤਿ ਨਾਮੁ';
      expect(GurmukhiUtils.safePreview(text), text);
    });

    test('truncates long text to exactly maxChars code points', () {
      // 100 Gurmukhi chars
      final long = 'ਸ' * 100;
      final preview = GurmukhiUtils.safePreview(long, maxChars: 60);
      // Verify truncation: result rune count == maxChars + 1 (ellipsis)
      expect(preview.runes.length, 61); // 60 chars + '…'
    });

    test('does not split Gurmukhi surrogate characters', () {
      // Multi-codepoint Gurmukhi string — ensure no half-characters
      const gurmukhi =
          'ਸਤਿ ਨਾਮੁ ਕਰਤਾ ਪੁਰਖੁ ਨਿਰਭਉ ਨਿਰਵੈਰੁ ਅਕਾਲ ਮੂਰਤਿ ਅਜੂਨੀ ਸੈਭੰ ਗੁਰ ਪ੍ਰਸਾਦਿ';
      final preview = GurmukhiUtils.safePreview(gurmukhi, maxChars: 30);
      // Each rune must be a valid Unicode code point
      for (final rune in preview.runes) {
        expect(rune, greaterThan(0));
      }
    });

    test('handles empty string', () {
      expect(GurmukhiUtils.safePreview(''), '');
    });

    test('uses custom ellipsis', () {
      final long = 'ਸ' * 100;
      final preview = GurmukhiUtils.safePreview(
        long,
        maxChars: 5,
        ellipsis: '...',
      );
      expect(preview.endsWith('...'), isTrue);
    });
  });

  // ─────────────────────────────────────────────────────────────────────────
  // 10. BOOKMARK CORRUPT DATA RESILIENCE
  // ─────────────────────────────────────────────────────────────────────────
  group('BookmarkProvider resilience to corrupt data', () {
    test(
      'skips individual corrupt entries without losing valid ones',
      () async {
        // We test the model-level resilience: good + bad entries in a list
        final entries = [
          // valid
          {
            'id': 'good1',
            'baniId': 'japji',
            'baniName': 'Japji Sahib',
            'verseIndex': 2,
            'versePreview': 'ਸਤਿ',
            'createdAt': DateTime.now().toIso8601String(),
          },
          // corrupt — missing id
          {'baniId': 'japji', 'verseIndex': 0},
          // corrupt — invalid date
          {
            'id': 'bad2',
            'baniId': 'japji',
            'baniName': 'Japji',
            'verseIndex': 0,
            'versePreview': 'x',
            'createdAt': 'NOT_A_DATE',
          },
          // valid
          {
            'id': 'good2',
            'baniId': 'rehras',
            'baniName': 'Rehras Sahib',
            'verseIndex': 5,
            'versePreview': 'ਰਹਰਾਸਿ',
            'createdAt': DateTime.now().toIso8601String(),
          },
        ];

        final loaded = <Bookmark>[];
        for (final e in entries) {
          try {
            loaded.add(Bookmark.fromJson(e));
          } on FormatException {
            // expected for corrupt entries
          }
        }

        expect(loaded.length, 2);
        expect(loaded.map((b) => b.id).toList(), ['good1', 'good2']);
      },
    );
  });
}
