import 'package:flutter_test/flutter_test.dart';
import 'package:sundargutka/models/verse.dart';

void main() {
  group('Vishraam model', () {
    test('fromJson creates Vishraam correctly', () {
      final v = Vishraam.fromJson({'position': 3, 'type': 'long'});
      expect(v.position, 3);
      expect(v.type, 'long');
    });

    test('toJson produces correct map', () {
      const v = Vishraam(position: 5, type: 'short');
      final json = v.toJson();
      expect(json['position'], 5);
      expect(json['type'], 'short');
    });
  });

  group('Verse model', () {
    test('fromJson creates Verse correctly', () {
      final json = {
        'id': 1,
        'verseNumber': 1,
        'section': 'Mool Mantar',
        'gurmukhi': 'ੴ ਸਤਿ ਨਾਮੁ',
        'hindi': 'ੴ सति नामु',
        'english': 'One God',
        'translation': 'One Universal Creator',
        'vishraams': [
          {'position': 1, 'type': 'short'},
          {'position': 3, 'type': 'long'},
        ],
      };

      final verse = Verse.fromJson(json);
      expect(verse.id, 1);
      expect(verse.gurmukhi, 'ੴ ਸਤਿ ਨਾਮੁ');
      expect(verse.section, 'Mool Mantar');
      expect(verse.vishraams.length, 2);
      expect(verse.vishraams[0].position, 1);
      expect(verse.vishraams[0].type, 'short');
      expect(verse.vishraams[1].type, 'long');
    });

    test('fromJson handles missing optional fields', () {
      final verse = Verse.fromJson({
        'id': 1,
        'verseNumber': 1,
        'gurmukhi': 'ੴ',
      });
      expect(verse.hindi, isNull);
      expect(verse.english, isNull);
      expect(verse.section, isNull);
      expect(verse.vishraams, isEmpty);
    });

    test('toJson round-trips correctly', () {
      const verse = Verse(
        id: 1,
        gurmukhi: 'ੴ ਸਤਿ ਨਾਮੁ',
        verseNumber: 1,
        vishraams: [Vishraam(position: 2, type: 'long')],
      );

      final json = verse.toJson();
      final verse2 = Verse.fromJson(json);
      expect(verse2.id, verse.id);
      expect(verse2.gurmukhi, verse.gurmukhi);
      expect(verse2.vishraams.length, 1);
    });
  });
}
