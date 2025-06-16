


import 'package:hopyn/features/home/domain/entities/vehicle_type.dart';

import '../../../ride/domain/entities/driver.dart';
import 'location.dart';

enum RideStatus {
  initial,
  searching,
  driverAssigned,
  driverArriving,
  inProgress,
  completed,
  cancelled,
}

class Ride {
  final String id;
  final Location? pickupLocation;
  final Location? dropoffLocation;
  final VehicleType? vehicleType;
  final Driver? driver;
  final RideStatus status;
  final DateTime? startTime;
  final DateTime? endTime;
  final double? distance; // in kilometers
  final double? duration; // in minutes
  final double? fare;
  final String? paymentMethod;
  final String? notes;

  Ride({
    required this.id,
    this.pickupLocation,
    this.dropoffLocation,
    this.vehicleType,
    this.driver,
    this.status = RideStatus.initial,
    this.startTime,
    this.endTime,
    this.distance,
    this.duration,
    this.fare,
    this.paymentMethod = 'Credit Card',
    this.notes,
  });

  // Empty ride
  factory Ride.empty() {
    return Ride(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
    );
  }

  // Completed ride for history
  factory Ride.completed({
    required String id,
    required Location pickupLocation,
    required Location dropoffLocation,
    required VehicleType vehicleType,
    required Driver driver,
    required DateTime startTime,
    required DateTime endTime,
    required double distance,
    required double duration,
    required double fare,
    String paymentMethod = 'Credit Card',
  }) {
    return Ride(
      id: id,
      pickupLocation: pickupLocation,
      dropoffLocation: dropoffLocation,
      vehicleType: vehicleType,
      driver: driver,
      status: RideStatus.completed,
      startTime: startTime,
      endTime: endTime,
      distance: distance,
      duration: duration,
      fare: fare,
      paymentMethod: paymentMethod,
    );
  }

  // Copy with method
  Ride copyWith({
    String? id,
    Location? pickupLocation,
    Location? dropoffLocation,
    VehicleType? vehicleType,
    Driver? driver,
    RideStatus? status,
    DateTime? startTime,
    DateTime? endTime,
    double? distance,
    double? duration,
    double? fare,
    String? paymentMethod,
    String? notes,
  }) {
    return Ride(
      id: id ?? this.id,
      pickupLocation: pickupLocation ?? this.pickupLocation,
      dropoffLocation: dropoffLocation ?? this.dropoffLocation,
      vehicleType: vehicleType ?? this.vehicleType,
      driver: driver ?? this.driver,
      status: status ?? this.status,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      distance: distance ?? this.distance,
      duration: duration ?? this.duration,
      fare: fare ?? this.fare,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      notes: notes ?? this.notes,
    );
  }
}
