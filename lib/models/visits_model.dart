import 'package:my_doggo_app/models/animal_model.dart';
import 'package:my_doggo_app/models/vet_model.dart';

class Visit {
  final int id;
  final int animalId;
  final Animal animal;
  final int? vaccinationTypeId;
  final DateTime visitDate;
  final DateTime? nextVisitDate;
  final String visitReason;
  final int vetId;
  final Vet vet;

  Visit({
    required this.id,
    required this.animalId,
    required this.animal,
    this.vaccinationTypeId,
    required this.visitDate,
    this.nextVisitDate,
    required this.visitReason,
    required this.vetId,
    required this.vet,
  });

  factory Visit.fromJson(Map<String, dynamic> json) {
    return Visit(
      id: json['id'],
      animalId: json['animalId'],
      animal: Animal.fromJson(json['animal']),
      vaccinationTypeId: json['vaccinationTypeId'],
      visitDate: DateTime.parse(json['visitDate']),
      nextVisitDate: json['nextVisitDate'] != null ? DateTime.parse(json['nextVisitDate']) : null,
      visitReason: json['visitReason'],
      vetId: json['vetId'],
      vet: Vet.fromJson(json['vet']),
    );
  }
}