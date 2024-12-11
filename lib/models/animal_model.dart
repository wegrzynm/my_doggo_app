class Animal {
  final int id;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String? deletedAt;
  final int animalTypeId;
  final AnimalType animalType;
  final String name;
  final DateTime birthdate;
  final int animalDetailsId;
  final AnimalDetails animalDetails;
  final dynamic visits;
  final int userId;
  final User user;
  final int profilePhotoId;
  final Photo profilePhoto;

  Animal({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
    required this.animalTypeId,
    required this.animalType,
    required this.name,
    required this.birthdate,
    required this.animalDetailsId,
    required this.animalDetails,
    this.visits,
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

class ChipNo {
  final String value;
  final bool isValid;

  ChipNo({required this.value, required this.isValid});

  factory ChipNo.fromJson(Map<String, dynamic> json) {
    return ChipNo(
      value: json['String'],
      isValid: json['Valid'],
    );
  }
}

class User {
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