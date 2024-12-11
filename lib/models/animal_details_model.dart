import 'package:my_doggo_app/models/chip_model.dart';

class AnimalDetails {
  final int id;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String? deletedAt;
  final String breed;
  final String dogHairType;
  final bool isNeutered;
  final ChipNo chipNo;

  AnimalDetails({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
    required this.breed,
    required this.dogHairType,
    required this.isNeutered,
    required this.chipNo,
  });

  factory AnimalDetails.fromJson(Map<String, dynamic> json) {
    return AnimalDetails(
      id: json['ID'],
      createdAt: DateTime.parse(json['CreatedAt']),
      updatedAt: DateTime.parse(json['UpdatedAt']),
      deletedAt: json['DeletedAt'],
      breed: json['breed'],
      dogHairType: json['dogHairType'],
      isNeutered: json['isNeutered'],
      chipNo: ChipNo.fromJson(json['chipNo']),
    );
  }
}