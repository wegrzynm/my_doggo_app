import 'package:my_doggo_app/models/user_model.dart';

class Photo {
  final int id;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;
  final String name;
  final String path;
  final int userId;
  final User user;

  Photo({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
    required this.name,
    required this.path,
    required this.userId,
    required this.user,
  });

  factory Photo.fromJson(Map<String, dynamic> json) {
    return Photo(
      id: json['ID'],
      createdAt: DateTime.parse(json['CreatedAt']),
      updatedAt: DateTime.parse(json['UpdatedAt']),
      deletedAt:
          json['DeletedAt'] != null ? DateTime.parse(json['DeletedAt']) : null,
      name: json['name'],
      path: json['path'],
      userId: json['userId'],
      user: User.fromJson(json['user']),
    );
  }
}