class User {
  final String id;
  final String name;
  final String email;
  final String? phoneNumber;
  final String? profilePicture;
  final double? rating;
  final DateTime createdAt;

  User({
    required this.id,
    required this.name,
    required this.email,
    this.phoneNumber,
    this.profilePicture,
    this.rating,
    required this.createdAt,
  });

  // Create a dummy user for UI demonstration purposes
  factory User.dummy() {
    return User(
      id: '1',
      name: 'John Doe',
      email: 'john.doe@example.com',
      phoneNumber: '+1234567890',
      profilePicture: 'https://example.com/profile.jpg', // This won't be used, just for entity structure
      rating: 4.7,
      createdAt: DateTime.now().subtract(const Duration(days: 30)),
    );
  }

  // Empty user
  factory User.empty() {
    return User(
      id: '',
      name: '',
      email: '',
      createdAt: DateTime.now(),
    );
  }

  // Copy with method
  User copyWith({
    String? id,
    String? name,
    String? email,
    String? phoneNumber,
    String? profilePicture,
    double? rating,
    DateTime? createdAt,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      profilePicture: profilePicture ?? this.profilePicture,
      rating: rating ?? this.rating,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
