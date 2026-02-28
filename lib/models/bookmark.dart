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

  factory Bookmark.fromJson(Map<String, dynamic> json) => Bookmark(
        id: json['id'] as String,
        baniId: json['baniId'] as String,
        baniName: json['baniName'] as String,
        verseIndex: json['verseIndex'] as int,
        versePreview: json['versePreview'] as String,
        createdAt: DateTime.parse(json['createdAt'] as String),
      );

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
