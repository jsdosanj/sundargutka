import 'package:flutter_test/flutter_test.dart';
import 'package:sundargutka/models/bani.dart';

void main() {
  group('Bani model', () {
    test('fromJson creates Bani correctly', () {
      final json = {
        'id': 'japji_sahib',
        'nameGurmukhi': 'ਜਪੁ',
        'nameEnglish': 'Japji Sahib',
        'category': 'taksal',
        'fileName': 'japji_sahib.json',
        'totalVerses': 40,
        'isNitnem': true,
      };

      final bani = Bani.fromJson(json);

      expect(bani.id, 'japji_sahib');
      expect(bani.nameGurmukhi, 'ਜਪੁ');
      expect(bani.nameEnglish, 'Japji Sahib');
      expect(bani.category, 'taksal');
      expect(bani.fileName, 'japji_sahib.json');
      expect(bani.totalVerses, 40);
      expect(bani.isNitnem, true);
    });

    test('toJson produces correct map', () {
      const bani = Bani(
        id: 'test_bani',
        nameGurmukhi: 'ਟੈਸਟ',
        nameEnglish: 'Test Bani',
        category: 'taksal',
        fileName: 'test_bani.json',
        totalVerses: 10,
        isNitnem: false,
      );

      final json = bani.toJson();
      expect(json['id'], 'test_bani');
      expect(json['nameEnglish'], 'Test Bani');
      expect(json['totalVerses'], 10);
      expect(json['isNitnem'], false);
    });

    test('equality based on id', () {
      const bani1 = Bani(
        id: 'japji_sahib',
        nameGurmukhi: 'ਜਪੁ',
        nameEnglish: 'Japji Sahib',
        category: 'taksal',
        fileName: 'japji_sahib.json',
        totalVerses: 40,
      );
      const bani2 = Bani(
        id: 'japji_sahib',
        nameGurmukhi: 'ਜਪੁ',
        nameEnglish: 'Japji Sahib',
        category: 'taksal',
        fileName: 'japji_sahib.json',
        totalVerses: 40,
      );

      expect(bani1, bani2);
    });

    test('isNitnem defaults to false', () {
      final bani = Bani.fromJson({
        'id': 'test',
        'nameGurmukhi': 'ਟੈਸਟ',
        'nameEnglish': 'Test',
        'category': 'taksal',
        'fileName': 'test.json',
        'totalVerses': 1,
      });
      expect(bani.isNitnem, false);
    });
  });
}
