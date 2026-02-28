class Bookmark {
  final String id;
  final String baniId;
  final String baniName;
  final int verseIndex;
  final String versePreview;
  final DateTime createdAt;

  const Bookmark({
    required this.id,
    required this.baniId,
    required this.baniName,
    required this.verseIndex,
    required this.versePreview,
    required this.createdAt,
  });

  factory Bookmark.fromJson(Map<String, dynamic> json) {
    final id = json['id'];
    final baniId = json['baniId'];
    final baniName = json['baniName'];
    final verseIndex = json['verseIndex'];
    final versePreview = json['versePreview'];
    final createdAtRaw = json['createdAt'];

    if (id is! String ||
        baniId is! String ||
        baniName is! String ||
        verseIndex is! int ||
        versePreview is! String ||
        createdAtRaw is! String) {
      throw const FormatException('Bookmark JSON has missing or invalid fields.');
    }

    // verseIndex must be non-negative
    if (verseIndex < 0) {
      throw const FormatException('Bookmark verseIndex must be non-negative.');
    }

    final DateTime createdAt;
    try {
      createdAt = DateTime.parse(createdAtRaw);
    } on FormatException {
      throw const FormatException('Bookmark createdAt is not a valid ISO-8601 date.');
    }

    return Bookmark(
      id: id,
      baniId: baniId,
      baniName: baniName,
      verseIndex: verseIndex,
      versePreview: versePreview,
      createdAt: createdAt,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'baniId': baniId,
        'baniName': baniName,
        'verseIndex': verseIndex,
        'versePreview': versePreview,
        'createdAt': createdAt.toIso8601String(),
      };

  @override
  bool operator ==(Object other) => other is Bookmark && other.id == id;

  @override
  int get hashCode => id.hashCode;
}
