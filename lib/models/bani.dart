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

  factory Bani.fromJson(Map<String, dynamic> json) {
    final id = json['id'];
    final nameGurmukhi = json['nameGurmukhi'];
    final nameEnglish = json['nameEnglish'];
    final category = json['category'];
    final fileName = json['fileName'];
    final totalVerses = json['totalVerses'];

    if (id is! String ||
        nameGurmukhi is! String ||
        nameEnglish is! String ||
        category is! String ||
        fileName is! String ||
        totalVerses is! int) {
      throw const FormatException('Bani JSON has missing or invalid fields.');
    }

    return Bani(
      id: id,
      nameGurmukhi: nameGurmukhi,
      nameEnglish: nameEnglish,
      category: category,
      fileName: fileName,
      totalVerses: totalVerses,
      isNitnem: json['isNitnem'] is bool ? json['isNitnem'] as bool : false,
    );
  }

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
