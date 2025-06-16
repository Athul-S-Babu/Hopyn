import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/utils/constants.dart';
import '../../../home/presentation/providers/home_providers.dart';

class RideMap extends ConsumerStatefulWidget {
  const RideMap({Key? key}) : super(key: key);

  @override
  ConsumerState<RideMap> createState() => _RideMapState();
}

class _RideMapState extends ConsumerState<RideMap> {
  GoogleMapController? _mapController;
  final Set<Marker> _markers = {};
  final Set<Polyline> _polylines = {};
  Timer? _animationTimer;
  bool _isPickupShown = false;
  bool _isDropoffShown = false;
  bool _isDriverShown = false;
  int _driverAnimationStep = 0;
  
  // For animation of driver position
  final List<LatLng> _driverPath = [];
  
  @override
  void initState() {
    super.initState();
    // Initialize the driver path for animation
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _setupMapData();
      _startDriverAnimation();
    });
  }
  
  @override
  void dispose() {
    _mapController?.dispose();
    _animationTimer?.cancel();
    super.dispose();
  }

  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;
    _setupMapData();
  }
  
  void _setupMapData() {
    final currentRideState = ref.read(currentRideProvider);
    final ride = currentRideState.ride;
    
    if (ride.pickupLocation != null && ride.dropoffLocation != null) {
      // Set up markers
      final pickupPosition = LatLng(
        ride.pickupLocation!.latitude,
        ride.pickupLocation!.longitude,
      );
      
      final dropoffPosition = LatLng(
        ride.dropoffLocation!.latitude,
        ride.dropoffLocation!.longitude,
      );
      
      // Create driver path
      _createDriverPath(pickupPosition, dropoffPosition);
      
      setState(() {
        // Add pickup marker
        _markers.add(
          Marker(
            markerId: const MarkerId('pickup'),
            position: pickupPosition,
            icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
            infoWindow: InfoWindow(
              title: 'Pickup',
              snippet: ride.pickupLocation!.address,
            ),
          ),
        );
        
        // Add dropoff marker
        _markers.add(
          Marker(
            markerId: const MarkerId('dropoff'),
            position: dropoffPosition,
            icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
            infoWindow: InfoWindow(
              title: 'Dropoff',
              snippet: ride.dropoffLocation!.address,
            ),
          ),
        );
        
        // Create a polyline between pickup and dropoff
        _polylines.add(
          Polyline(
            polylineId: const PolylineId('route'),
            points: [pickupPosition, dropoffPosition],
            color: Colors.blue,
            width: 5,
          ),
        );
        
        _isPickupShown = true;
        _isDropoffShown = true;
      });
      
      // Move camera to show both points
      _fitMapToBounds(pickupPosition, dropoffPosition);
    }
  }
  
  void _createDriverPath(LatLng pickup, LatLng dropoff) {
    // Create a simple path from pickup to dropoff with some points in between
    _driverPath.clear();
    
    // Start with a point some distance away from pickup
    final startLat = pickup.latitude - 0.01;
    final startLng = pickup.longitude - 0.01;
    _driverPath.add(LatLng(startLat, startLng));
    
    // Add some points leading to pickup
    const steps = 10;
    for (int i = 1; i <= steps; i++) {
      final fraction = i / steps;
      final lat = startLat + (pickup.latitude - startLat) * fraction;
      final lng = startLng + (pickup.longitude - startLng) * fraction;
      _driverPath.add(LatLng(lat, lng));
    }
    
    // Add pickup
    _driverPath.add(pickup);
    
    // Add some points between pickup and dropoff
    for (int i = 1; i < steps; i++) {
      final fraction = i / steps;
      final lat = pickup.latitude + (dropoff.latitude - pickup.latitude) * fraction;
      final lng = pickup.longitude + (dropoff.longitude - pickup.longitude) * fraction;
      _driverPath.add(LatLng(lat, lng));
    }
    
    // Add dropoff
    _driverPath.add(dropoff);
  }
  
  void _startDriverAnimation() {
    if (_driverPath.isEmpty) return;
    
    setState(() {
      _isDriverShown = true;
      // Add initial driver marker
      _updateDriverMarker(_driverPath.first);
    });
    
    // Animate driver movement
    _animationTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_driverAnimationStep < _driverPath.length - 1) {
        setState(() {
          _driverAnimationStep++;
          _updateDriverMarker(_driverPath[_driverAnimationStep]);
        });
      } else {
        timer.cancel();
      }
    });
  }
  
  void _updateDriverMarker(LatLng position) {
    _markers.removeWhere((marker) => marker.markerId.value == 'driver');
    _markers.add(
      Marker(
        markerId: const MarkerId('driver'),
        position: position,
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure),
        infoWindow: const InfoWindow(
          title: 'Driver',
          snippet: 'Your driver is on the way',
        ),
      ),
    );
  }
  
  void _fitMapToBounds(LatLng pickup, LatLng dropoff) {
    if (_mapController == null) return;
    
    // Calculate bounds that include pickup and dropoff
    double minLat = pickup.latitude < dropoff.latitude ? pickup.latitude : dropoff.latitude;
    double maxLat = pickup.latitude > dropoff.latitude ? pickup.latitude : dropoff.latitude;
    double minLng = pickup.longitude < dropoff.longitude ? pickup.longitude : dropoff.longitude;
    double maxLng = pickup.longitude > dropoff.longitude ? pickup.longitude : dropoff.longitude;
    
    // Add some padding
    minLat -= 0.01;
    maxLat += 0.01;
    minLng -= 0.01;
    maxLng += 0.01;
    
    final bounds = LatLngBounds(
      southwest: LatLng(minLat, minLng),
      northeast: LatLng(maxLat, maxLng),
    );
    
    // Move camera to show bounds
    _mapController!.animateCamera(
      CameraUpdate.newLatLngBounds(bounds, 50),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GoogleMap(
      onMapCreated: _onMapCreated,
      initialCameraPosition: CameraPosition(
        target: LatLng(
          AppConstants.initialCameraPosition['latitude']!,
          AppConstants.initialCameraPosition['longitude']!,
        ),
        zoom: AppConstants.initialCameraPosition['zoom']!,
      ),
      markers: _markers,
      polylines: _polylines,
      myLocationEnabled: true,
      myLocationButtonEnabled: false,
      zoomControlsEnabled: false,
      mapToolbarEnabled: false,
      compassEnabled: true,
    );
  }
}
