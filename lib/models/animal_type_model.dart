class AnimalType {
  final int id;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String? deletedAt;
  final String name;
  final String description;

  AnimalType({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
    required this.name,
    required this.description,
  });

  factory AnimalType.fromJson(Map<String, dynamic> json) {
    return AnimalType(
      id: json['ID'],
      createdAt: DateTime.parse(json['CreatedAt']),
      updatedAt: DateTime.parse(json['UpdatedAt']),
      deletedAt: json['DeletedAt'],
      name: json['name'],
      description: json['description'],
    );
  }
}
