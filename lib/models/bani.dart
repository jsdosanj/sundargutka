class Bani {
  final String id;
  final String nameGurmukhi;
  final String nameEnglish;
  final String category;
  final String fileName;
  final int totalVerses;
  final bool isNitnem;

  const Bani({
    required this.id,
    required this.nameGurmukhi,
    required this.nameEnglish,
    required this.category,
    required this.fileName,
    required this.totalVerses,
    this.isNitnem = false,
  });

  factory Bani.fromJson(Map<String, dynamic> json) => Bani(
        id: json['id'] as String,
        nameGurmukhi: json['nameGurmukhi'] as String,
        nameEnglish: json['nameEnglish'] as String,
        category: json['category'] as String,
        fileName: json['fileName'] as String,
        totalVerses: json['totalVerses'] as int,
        isNitnem: json['isNitnem'] as bool? ?? false,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'nameGurmukhi': nameGurmukhi,
        'nameEnglish': nameEnglish,
        'category': category,
        'fileName': fileName,
        'totalVerses': totalVerses,
        'isNitnem': isNitnem,
      };

  @override
  String toString() => 'Bani($id, $nameEnglish)';

  @override
  bool operator ==(Object other) => other is Bani && other.id == id;

  @override
  int get hashCode => id.hashCode;
}
