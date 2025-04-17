class User {
  final int id;
  final String name;
  final String email;
  final String avatar;
  final Address address;
  final String phone;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.avatar,
    required this.address,
    required this.phone,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      avatar: json['avatar'] ?? '',
      address: Address.fromJson(json['address'] ?? {}),
      phone: json['phone'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'avatar': avatar,
      'address': address.toJson(),
      'phone': phone,
    };
  }

  // Create a mock user for demo purposes
  factory User.mock() {
    return User(
      id: 1,
      name: 'John Doe',
      email: 'john.doe@example.com',
      avatar: 'https://robohash.org/John?set=set4',
      address: Address(
        street: '123 Main Street',
        city: 'Anytown',
        zipcode: '12345',
        country: 'USA',
      ),
      phone: '+1 (555) 123-4567',
    );
  }
}

class Address {
  final String street;
  final String city;
  final String zipcode;
  final String country;

  Address({
    required this.street,
    required this.city,
    required this.zipcode,
    required this.country,
  });

  factory Address.fromJson(Map<String, dynamic> json) {
    return Address(
      street: json['street'] ?? '',
      city: json['city'] ?? '',
      zipcode: json['zipcode'] ?? '',
      country: json['country'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'street': street,
      'city': city,
      'zipcode': zipcode,
      'country': country,
    };
  }
}
