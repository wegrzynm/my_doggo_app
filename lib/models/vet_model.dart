import 'address_model.dart';

class Vet {
  final int? id;
  final String name;
  final int addressId;
  final Address address;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Vet({
    this.id,
    required this.name,
    required this.addressId,
    required this.address,
    this.createdAt,
    this.updatedAt,
  });

  factory Vet.fromJson(Map<String, dynamic> json) {
    return Vet(
      id: json['id'],
      name: json['name'],
      addressId: json['addressId'],
      address: Address.fromJson(json['address']),
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'])
          : null,
    );
  }
}