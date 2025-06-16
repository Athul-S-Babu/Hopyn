enum VehicleCategoryType {
  economy,
  comfort,
  premium,
  xl,
}

class VehicleType {
  final String id;
  final String name;
  final String description;
  final double baseFare;
  final double perKilometerRate;
  final double perMinuteRate;
  final int maxPassengers;
  final String iconPath;
  final VehicleCategoryType category;
  final double estimatedTime; // in minutes
  
  VehicleType({
    required this.id,
    required this.name,
    required this.description,
    required this.baseFare,
    required this.perKilometerRate,
    required this.perMinuteRate,
    required this.maxPassengers,
    required this.iconPath,
    required this.category,
    required this.estimatedTime,
  });
  
  // Calculate fare based on distance and duration
  double calculateFare(double distance, double duration) {
    return baseFare + (distance * perKilometerRate) + (duration * perMinuteRate);
  }
  
  // Create dummy vehicle types for UI
  static List<VehicleType> getDummyTypes() {
    return [
      VehicleType(
        id: '1',
        name: 'Economy',
        description: 'Affordable rides for everyday use',
        baseFare: 2.50,
        perKilometerRate: 0.75,
        perMinuteRate: 0.15,
        maxPassengers: 4,
        iconPath: 'assets/images/economy.svg',
        category: VehicleCategoryType.economy,
        estimatedTime: 4.0,
      ),
      VehicleType(
        id: '2',
        name: 'Comfort',
        description: 'Newer cars with extra legroom',
        baseFare: 4.00,
        perKilometerRate: 1.25,
        perMinuteRate: 0.25,
        maxPassengers: 4,
        iconPath: 'assets/images/comfort.svg',
        category: VehicleCategoryType.comfort,
        estimatedTime: 6.0,
      ),
      VehicleType(
        id: '3',
        name: 'Premium',
        description: 'Luxury rides with top-rated drivers',
        baseFare: 6.50,
        perKilometerRate: 2.00,
        perMinuteRate: 0.40,
        maxPassengers: 4,
        iconPath: 'assets/images/premium.svg',
        category: VehicleCategoryType.premium,
        estimatedTime: 5.0,
      ),
      VehicleType(
        id: '4',
        name: 'XL',
        description: 'Spacious vehicles for groups up to 6',
        baseFare: 5.00,
        perKilometerRate: 1.50,
        perMinuteRate: 0.30,
        maxPassengers: 6,
        iconPath: 'assets/images/xl.svg',
        category: VehicleCategoryType.xl,
        estimatedTime: 8.0,
      ),
    ];
  }
}
