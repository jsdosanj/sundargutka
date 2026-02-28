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

  factory CustomList.fromJson(Map<String, dynamic> json) => CustomList(
        id: json['id'] as String,
        name: json['name'] as String,
        baniIds: List<String>.from(json['baniIds'] as List),
        createdAt: DateTime.parse(json['createdAt'] as String),
      );

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
