class CustomList {
  final String id;
  final String name;
  final List<String> baniIds;
  final DateTime createdAt;

  const CustomList({
    required this.id,
    required this.name,
    required this.baniIds,
    required this.createdAt,
  });

  factory CustomList.fromJson(Map<String, dynamic> json) {
    final id = json['id'];
    final name = json['name'];
    final baniIdsRaw = json['baniIds'];
    final createdAtRaw = json['createdAt'];

    if (id is! String ||
        name is! String ||
        baniIdsRaw is! List ||
        createdAtRaw is! String) {
      throw const FormatException(
          'CustomList JSON has missing or invalid fields.');
    }

    final DateTime createdAt;
    try {
      createdAt = DateTime.parse(createdAtRaw);
    } on FormatException {
      throw const FormatException(
          'CustomList createdAt is not a valid ISO-8601 date.');
    }

    return CustomList(
      id: id,
      name: name,
      baniIds: baniIdsRaw
          .whereType<String>()
          .toList(),
      createdAt: createdAt,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'baniIds': baniIds,
        'createdAt': createdAt.toIso8601String(),
      };

  CustomList copyWith({
    String? id,
    String? name,
    List<String>? baniIds,
    DateTime? createdAt,
  }) =>
      CustomList(
        id: id ?? this.id,
        name: name ?? this.name,
        baniIds: baniIds ?? List.from(this.baniIds),
        createdAt: createdAt ?? this.createdAt,
      );

  @override
  bool operator ==(Object other) => other is CustomList && other.id == id;

  @override
  int get hashCode => id.hashCode;
}
