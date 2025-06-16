import 'package:flutter_riverpod/flutter_riverpod.dart';


import '../../../ride/domain/entities/driver.dart';
import '../../domain/entities/location.dart';
import '../../domain/entities/ride.dart';
import '../../domain/entities/vehicle_type.dart';

// Saved locations state
final savedLocationsProvider = Provider<List<Location>>((ref) {
  // Dummy saved locations for UI
  return [
    Location.savedLocation(
      id: '1',
      name: 'Home',
      address: '123 Home Street, San Francisco, CA',
      latitude: 37.7749,
      longitude: -122.4194,
    ),
    Location.savedLocation(
      id: '2',
      name: 'Work',
      address: '456 Office Building, San Francisco, CA',
      latitude: 37.7898,
      longitude: -122.4009,
    ),
    Location.savedLocation(
      id: '3',
      name: 'Gym',
      address: '789 Fitness Center, San Francisco, CA',
      latitude: 37.7831,
      longitude: -122.4181,
    ),
  ];
});

// Recent locations state
final recentLocationsProvider = Provider<List<Location>>((ref) {
  // Dummy recent locations for UI
  return [
    Location.recentLocation(
      id: '4',
      address: 'San Francisco Airport (SFO), San Francisco, CA',
      latitude: 37.6213,
      longitude: -122.3790,
    ),
    Location.recentLocation(
      id: '5',
      address: 'Golden Gate Park, San Francisco, CA',
      latitude: 37.7694,
      longitude: -122.4862,
    ),
    Location.recentLocation(
      id: '6',
      address: 'Ferry Building, San Francisco, CA',
      latitude: 37.7955,
      longitude: -122.3937,
    ),
  ];
});

// Vehicle types provider
final vehicleTypesProvider = Provider<List<VehicleType>>((ref) {
  return VehicleType.getDummyTypes();
});

// Selected vehicle type provider
final selectedVehicleTypeProvider = StateProvider<VehicleType?>((ref) {
  final vehicleTypes = ref.watch(vehicleTypesProvider);
  return vehicleTypes.isNotEmpty ? vehicleTypes.first : null;
});

// Current ride state
class CurrentRideState {
  final Ride ride;
  final bool isLoading;
  final String? errorMessage;

  CurrentRideState({
    required this.ride,
    this.isLoading = false,
    this.errorMessage,
  });

  CurrentRideState copyWith({
    Ride? ride,
    bool? isLoading,
    String? errorMessage,
  }) {
    return CurrentRideState(
      ride: ride ?? this.ride,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
    );
  }
}

// Current ride notifier
class CurrentRideNotifier extends StateNotifier<CurrentRideState> {
  CurrentRideNotifier() : super(CurrentRideState(ride: Ride.empty()));

  // Set pickup location
  void setPickupLocation(Location location) {
    state = state.copyWith(
      ride: state.ride.copyWith(
        pickupLocation: location,
      ),
    );
  }

  // Set dropoff location
  void setDropoffLocation(Location location) {
    state = state.copyWith(
      ride: state.ride.copyWith(
        dropoffLocation: location,
      ),
    );
  }

  // Set vehicle type
  void setVehicleType(VehicleType vehicleType) {
    state = state.copyWith(
      ride: state.ride.copyWith(
        vehicleType: vehicleType,
      ),
    );
  }

  // Request ride
  Future<bool> requestRide() async {
    if (state.ride.pickupLocation == null ||
        state.ride.dropoffLocation == null ||
        state.ride.vehicleType == null) {
      state = state.copyWith(
        errorMessage: 'Incomplete ride details',
      );
      return false;
    }

    state = state.copyWith(isLoading: true);

    // Simulate network request
    await Future.delayed(const Duration(seconds: 2));

    try {
      // Generate random distance and duration for fare calculation
      const distance = 8.5; // km
      const duration = 22.0; // minutes
      
      // Calculate fare
      final fare = state.ride.vehicleType!.calculateFare(distance, duration);
      
      // Simulate finding a driver
      state = state.copyWith(
        ride: state.ride.copyWith(
          status: RideStatus.searching,
          distance: distance,
          duration: duration,
          fare: fare,
        ),
        isLoading: false,
      );
      
      return true;
    } catch (e) {
      state = state.copyWith(
        errorMessage: 'Failed to request ride',
        isLoading: false,
      );
      return false;
    }
  }

  // Assign driver
  Future<bool> assignDriver() async {
    state = state.copyWith(isLoading: true);

    // Simulate network delay
    await Future.delayed(const Duration(seconds: 3));

    try {
      // Create a dummy driver
      final driver = Driver.dummy();

      // Update ride status
      state = state.copyWith(
        ride: state.ride.copyWith(
          driver: driver,
          status: RideStatus.driverAssigned,
          startTime: DateTime.now(),
        ),
        isLoading: false,
      );
      
      return true;
    } catch (e) {
      state = state.copyWith(
        errorMessage: 'Failed to find a driver',
        isLoading: false,
      );
      return false;
    }
  }

  // Start ride
  void startRide() {
    state = state.copyWith(
      ride: state.ride.copyWith(
        status: RideStatus.inProgress,
      ),
    );
  }

  // Complete ride
  void completeRide() {
    state = state.copyWith(
      ride: state.ride.copyWith(
        status: RideStatus.completed,
        endTime: DateTime.now(),
      ),
    );
  }

  // Cancel ride
  void cancelRide() {
    state = state.copyWith(
      ride: state.ride.copyWith(
        status: RideStatus.cancelled,
      ),
    );
  }

  // Reset ride
  void resetRide() {
    state = CurrentRideState(ride: Ride.empty());
  }
}

// Current ride provider
final currentRideProvider = StateNotifierProvider<CurrentRideNotifier, CurrentRideState>((ref) {
  return CurrentRideNotifier();
});

// Ride history provider
final rideHistoryProvider = Provider<List<Ride>>((ref) {
  // Dummy ride history for UI
  final dummyDrivers = Driver.getDummyDrivers();
  final vehicleTypes = VehicleType.getDummyTypes();
  
  return [
    Ride.completed(
      id: '1',
      pickupLocation: Location(
        id: '101',
        address: '123 Home Street, San Francisco, CA',
        latitude: 37.7749,
        longitude: -122.4194,
      ),
      dropoffLocation: Location(
        id: '102',
        address: 'San Francisco Airport (SFO), San Francisco, CA',
        latitude: 37.6213,
        longitude: -122.3790,
      ),
      vehicleType: vehicleTypes[0], // Economy
      driver: dummyDrivers[0],
      startTime: DateTime.now().subtract(const Duration(days: 2, hours: 3)),
      endTime: DateTime.now().subtract(const Duration(days: 2, hours: 2)),
      distance: 22.4,
      duration: 45.0,
      fare: 25.75,
    ),
    Ride.completed(
      id: '2',
      pickupLocation: Location(
        id: '103',
        address: 'Ferry Building, San Francisco, CA',
        latitude: 37.7955,
        longitude: -122.3937,
      ),
      dropoffLocation: Location(
        id: '104',
        address: 'Golden Gate Park, San Francisco, CA',
        latitude: 37.7694,
        longitude: -122.4862,
      ),
      vehicleType: vehicleTypes[2], // Premium
      driver: dummyDrivers[1],
      startTime: DateTime.now().subtract(const Duration(days: 5, hours: 6)),
      endTime: DateTime.now().subtract(const Duration(days: 5, hours: 5, minutes: 30)),
      distance: 8.7,
      duration: 28.0,
      fare: 32.40,
    ),
    Ride.completed(
      id: '3',
      pickupLocation: Location(
        id: '105',
        address: '456 Office Building, San Francisco, CA',
        latitude: 37.7898,
        longitude: -122.4009,
      ),
      dropoffLocation: Location(
        id: '106',
        address: '789 Fitness Center, San Francisco, CA',
        latitude: 37.7831,
        longitude: -122.4181,
      ),
      vehicleType: vehicleTypes[1], // Comfort
      driver: dummyDrivers[2],
      startTime: DateTime.now().subtract(const Duration(days: 8)),
      endTime: DateTime.now().subtract(const Duration(days: 8)).add(const Duration(minutes: 15)),
      distance: 3.2,
      duration: 12.0,
      fare: 12.85,
    ),
  ];
});
