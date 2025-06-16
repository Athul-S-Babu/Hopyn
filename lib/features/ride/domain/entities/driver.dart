class Driver {
  final String id;
  final String name;
  final String phoneNumber;
  final String? carModel;
  final String? carColor;
  final String? licensePlate;
  final String? profilePicture;
  final double rating;
  final int totalRides;

  Driver({
    required this.id,
    required this.name,
    required this.phoneNumber,
    this.carModel,
    this.carColor,
    this.licensePlate,
    this.profilePicture,
    required this.rating,
    required this.totalRides,
  });

  // Create a dummy driver for UI demonstration purposes
  factory Driver.dummy() {
    return Driver(
      id: '1',
      name: 'Michael Johnson',
      phoneNumber: '+1234567890',
      carModel: 'Toyota Camry',
      carColor: 'Silver',
      licensePlate: 'ABC123',
      profilePicture: 'https://example.com/driver1.jpg', // This won't be used, just for entity structure
      rating: 4.8,
      totalRides: 1245,
    );
  }

  // Get multiple dummy drivers for the ride history
  static List<Driver> getDummyDrivers() {
    return [
      Driver(
        id: '1',
        name: 'Michael Johnson',
        phoneNumber: '+1234567890',
        carModel: 'Toyota Camry',
        carColor: 'Silver',
        licensePlate: 'ABC123',
        rating: 4.8,
        totalRides: 1245,
      ),
      Driver(
        id: '2',
        name: 'Sarah Wilson',
        phoneNumber: '+1987654321',
        carModel: 'Honda Civic',
        carColor: 'Black',
        licensePlate: 'XYZ789',
        rating: 4.9,
        totalRides: 2183,
      ),
      Driver(
        id: '3',
        name: 'David Martinez',
        phoneNumber: '+1567890123',
        carModel: 'Hyundai Sonata',
        carColor: 'Blue',
        licensePlate: 'LMN456',
        rating: 4.7,
        totalRides: 987,
      ),
    ];
  }
}
