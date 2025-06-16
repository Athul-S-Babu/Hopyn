class Location {
  final String id;
  final String address;
  final double latitude;
  final double longitude;
  final String? name;
  final String? placeId;
  final bool isSaved;
  final bool isRecent;

  Location({
    required this.id,
    required this.address,
    required this.latitude,
    required this.longitude,
    this.name,
    this.placeId,
    this.isSaved = false,
    this.isRecent = false,
  });

  // Factory for creating dummy saved locations
  factory Location.savedLocation({
    required String id,
    required String name,
    required String address,
    required double latitude,
    required double longitude,
  }) {
    return Location(
      id: id,
      name: name,
      address: address,
      latitude: latitude,
      longitude: longitude,
      isSaved: true,
    );
  }

  // Factory for creating dummy recent locations
  factory Location.recentLocation({
    required String id,
    required String address,
    required double latitude,
    required double longitude,
  }) {
    return Location(
      id: id,
      address: address,
      latitude: latitude,
      longitude: longitude,
      isRecent: true,
    );
  }

  // Copy with method
  Location copyWith({
    String? id,
    String? address,
    double? latitude,
    double? longitude,
    String? name,
    String? placeId,
    bool? isSaved,
    bool? isRecent,
  }) {
    return Location(
      id: id ?? this.id,
      address: address ?? this.address,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      name: name ?? this.name,
      placeId: placeId ?? this.placeId,
      isSaved: isSaved ?? this.isSaved,
      isRecent: isRecent ?? this.isRecent,
    );
  }
}
