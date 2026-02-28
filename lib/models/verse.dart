class Vishraam {
  final int position;
  final String type; // 'long' or 'short'

  const Vishraam({required this.position, required this.type});

  factory Vishraam.fromJson(Map<String, dynamic> json) => Vishraam(
        position: json['position'] as int,
        type: json['type'] as String,
      );

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

  factory Verse.fromJson(Map<String, dynamic> json) => Verse(
        id: json['id'] as int,
        gurmukhi: json['gurmukhi'] as String,
        hindi: json['hindi'] as String?,
        english: json['english'] as String?,
        translation: json['translation'] as String?,
        vishraams: (json['vishraams'] as List<dynamic>? ?? [])
            .map((v) => Vishraam.fromJson(v as Map<String, dynamic>))
            .toList(),
        verseNumber: json['verseNumber'] as int,
        section: json['section'] as String?,
      );

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
