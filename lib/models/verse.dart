class Vishraam {
  final int position;
  final String type; // 'long' or 'short'

  const Vishraam({required this.position, required this.type});

  factory Vishraam.fromJson(Map<String, dynamic> json) {
    final position = json['position'];
    final type = json['type'];
    if (position is! int || type is! String) {
      throw const FormatException('Vishraam JSON has invalid fields.');
    }
    if (position < 0) {
      throw const FormatException('Vishraam position must be non-negative.');
    }
    return Vishraam(position: position, type: type);
  }

  Map<String, dynamic> toJson() => {
        'position': position,
        'type': type,
      };
}

class Verse {
  final int id;
  final String gurmukhi;
  final String? hindi;
  final String? english;
  final String? translation;
  final List<Vishraam> vishraams;
  final int verseNumber;
  final String? section;

  const Verse({
    required this.id,
    required this.gurmukhi,
    this.hindi,
    this.english,
    this.translation,
    this.vishraams = const [],
    required this.verseNumber,
    this.section,
  });

  factory Verse.fromJson(Map<String, dynamic> json) {
    final id = json['id'];
    final gurmukhi = json['gurmukhi'];
    final verseNumber = json['verseNumber'];

    if (id is! int || gurmukhi is! String || verseNumber is! int) {
      throw const FormatException('Verse JSON has missing or invalid fields.');
    }

    final List<Vishraam> vishraams;
    try {
      vishraams = (json['vishraams'] as List<dynamic>? ?? [])
          .map((v) => Vishraam.fromJson(v as Map<String, dynamic>))
          .toList();
    } on FormatException {
      rethrow;
    } catch (_) {
      throw const FormatException('Vishraam list is malformed.');
    }

    return Verse(
      id: id,
      gurmukhi: gurmukhi,
      hindi: json['hindi'] is String ? json['hindi'] as String : null,
      english: json['english'] is String ? json['english'] as String : null,
      translation: json['translation'] is String
          ? json['translation'] as String
          : null,
      vishraams: vishraams,
      verseNumber: verseNumber,
      section: json['section'] is String ? json['section'] as String : null,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'gurmukhi': gurmukhi,
        'hindi': hindi,
        'english': english,
        'translation': translation,
        'vishraams': vishraams.map((v) => v.toJson()).toList(),
        'verseNumber': verseNumber,
        'section': section,
      };
}
