
class User{
  final int id;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String? deletedAt;
  final String email;
  final String password;
  final String name;
  final String lastname;
  final int addressId;
  final Address address;
  final int role;

  User({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
    required this.email,
    required this.password,
    required this.name,
    required this.lastname,
    required this.addressId,
    required this.address,
    required this.role,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['ID'],
      createdAt: DateTime.parse(json['CreatedAt']),
      updatedAt: DateTime.parse(json['UpdatedAt']),
      deletedAt: json['DeletedAt'],
      email: json['email'],
      password: json['password'],
      name: json['name'],
      lastname: json['lastname'],
      addressId: json['addressId'],
      address: Address.fromJson(json['address']),
      role: json['role'],
    );
  }
}

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
