class Address {
  final int id;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String? deletedAt;
  final String country;
  final String city;
  final String zipCode;
  final String street;
  final String number;

  Address({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
    required this.country,
    required this.city,
    required this.zipCode,
    required this.street,
    required this.number,
  });

  factory Address.fromJson(Map<String, dynamic> json) {
    return Address(
      id: json['ID'],
      createdAt: DateTime.parse(json['CreatedAt']),
      updatedAt: DateTime.parse(json['UpdatedAt']),
      deletedAt: json['DeletedAt'],
      country: json['country'],
      city: json['city'],
      zipCode: json['zipCode'],
      street: json['street'],
      number: json['number'],
    );
  }
}