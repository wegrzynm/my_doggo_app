import 'package:my_doggo_app/models/animal_details_model.dart';
import 'package:my_doggo_app/models/animal_type_model.dart';
import 'package:my_doggo_app/models/photo_model.dart';
import 'package:my_doggo_app/models/user_model.dart';
import 'package:my_doggo_app/models/visits_model.dart';

class Animal {
  final int id;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String? deletedAt;
  final int animalTypeId;
  final AnimalType animalType;
  final String name;
  final DateTime birthdate;
  final bool gender;
  final int animalDetailsId;
  final AnimalDetails animalDetails;
  final List<Visit> visits;
  final int userId;
  final User user;
  final int profilePhotoId;
  final Photo profilePhoto;

  Animal({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    required this.deletedAt,
    required this.animalTypeId,
    required this.animalType,
    required this.name,
    required this.birthdate,
    required this.gender,
    required this.animalDetailsId,
    required this.animalDetails,
    required this.visits,
    required this.userId,
    required this.user,
    required this.profilePhotoId,
    required this.profilePhoto,
  });

  factory Animal.fromJson(Map<String, dynamic> json) {
    return Animal(
      id: json['ID'],
      createdAt: DateTime.parse(json['CreatedAt']),
      updatedAt: DateTime.parse(json['UpdatedAt']),
      deletedAt: json['DeletedAt'],
      animalTypeId: json['animalTypeId'],
      animalType: AnimalType.fromJson(json['animalType']),
      name: json['name'],
      birthdate: DateTime.parse(json['birthdate']),
      gender: json['gender'],
      animalDetailsId: json['animalDetailsId'],
      animalDetails: AnimalDetails.fromJson(json['animalDetails']),
      visits: json['visits'],
      userId: json['userId'],
      user: User.fromJson(json['user']),
      profilePhotoId: json['profilePhotoId'],
      profilePhoto: Photo.fromJson(json['profilePhoto']),
    );
  }

  static List<Animal> listFromJson(List<dynamic> jsonList) {
    return jsonList.map((json) => Animal.fromJson(json)).toList();
  }
}