import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../../../core/utils/constants.dart';
import '../../../../core/utils/extensions.dart';
import '../../../../core/widgets/custom_button.dart';
import '../providers/home_providers.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  GoogleMapController? _mapController;
  final Set<Marker> _markers = {};

  @override
  void initState() {
    super.initState();
    // Reset the current ride when returning to home screen
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(currentRideProvider.notifier).resetRide();
    });
  }

  @override
  void dispose() {
    _mapController?.dispose();
    super.dispose();
  }

  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;
  }

  void _addMarker(LatLng position, String markerId, BitmapDescriptor icon) {
    setState(() {
      _markers.add(
        Marker(
          markerId: MarkerId(markerId),
          position: position,
          icon: icon,
        ),
      );
    });
  }

  void _navigateToLocationSelector() {
    context.go('/location-selector');
  }

  void _navigateToProfile() {
    context.go('/profile');
  }

  void _navigateToRideHistory() {
    context.go('/ride-history');
  }

  // Flag to track if there was a Google Maps error
  bool _hasMapError = false;
  String _mapErrorMessage = "";

  @override
  Widget build(BuildContext context) {
    final savedLocations = ref.watch(savedLocationsProvider);

    return Scaffold(
      backgroundColor: AppColors.kWhite,
      body: Stack(
        children: [
          // Map View with error handling
          _buildMapWithErrorHandling(),

          // App Bar
          Positioned(
            top: 50,
            left: 16,
            right: 16,
            child: Row(
              children: [
                // Menu Button
                GestureDetector(
                  onTap: _navigateToProfile,
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color:AppColors.kWhite,
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: const Icon(Icons.menu, color: AppColors.kPrimaryColor,),
                  ),
                ),

                const Spacer(),

                // Ride History Button
                GestureDetector(
                  onTap: _navigateToRideHistory,
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color:AppColors.kWhite,
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: const Icon(Icons.history, color:AppColors.kPrimaryColor),
                  ),
                ),
              ],
            ),
          ),

          // Bottom Sheet
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppColors.kWhite,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(24),
                  topRight: Radius.circular(24),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, -4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Where to?',
                    style: context.textTheme.headlineMedium?.copyWith(
                      color: AppColors.kPrimaryColor
                    )
                  ),
                  const SizedBox(height: 16),

                  // Search Bar / Location Input
                  GestureDetector(
                    onTap: _navigateToLocationSelector,
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.kWhiteShade,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.search, color:AppColors.kPrimaryColor),
                          const SizedBox(width: 12),
                          Text(
                            'Enter destination',
                            style: context.textTheme.bodyLarge?.copyWith(
                              color: AppColors.kBlackShade
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Saved Locations
                  Text(
                    'Saved Places',
                    style: context.textTheme.titleLarge?.copyWith(
                      color: AppColors.kPrimaryColor
                    )

                  ),
                  const SizedBox(height: 12),

                  // Saved Locations List
                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: savedLocations.length > 3 ? 3 : savedLocations.length,
                    separatorBuilder: (context, index) => const Divider(
                      color: AppColors.kBlackShade
                    ),
                    itemBuilder: (context, index) {
                      final location = savedLocations[index];
                      return ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: AppColors.kGrey,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(
                            index == 0
                                ? Icons.home
                                : index == 1
                                    ? Icons.work
                                    : Icons.favorite,
                            color: AppColors.kPrimaryColor,
                          ),
                        ),
                        title: Text(location.name ?? 'Saved Location', style: const TextStyle(
                            color: AppColors.kPrimaryColor
                        ),),
                        subtitle: Text(
                          location.address,
                          maxLines: 1,

                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: AppColors.kPrimaryColor
                          ),
                        ),
                        onTap: () {
                          // Set this as dropoff location and navigate to location selector
                          ref.read(currentRideProvider.notifier).setDropoffLocation(location);
                          _navigateToLocationSelector();
                        },
                      );
                    },
                  ),

                  const SizedBox(height: 24),

                  // Book Now Button
                  CustomButton(
                    text: 'Book Ride Now',
                    onPressed: _navigateToLocationSelector,
                    icon: Icons.local_taxi,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Build map with error handling
  Widget _buildMapWithErrorHandling() {
    try {
      return _hasMapError ? _buildMapErrorWidget() : _buildGoogleMap();
    } catch (e) {
      // If an exception occurs during map rendering, show the error UI
      _hasMapError = true;
      _mapErrorMessage = e.toString();
      return _buildMapErrorWidget();
    }
  }

  // Build Google Map widget
  Widget _buildGoogleMap() {
    try {
      return GoogleMap(
        onMapCreated: (GoogleMapController controller) {
          _mapController = controller;
        },
        initialCameraPosition: CameraPosition(
          target: LatLng(
            AppConstants.initialCameraPosition['latitude']!,
            AppConstants.initialCameraPosition['longitude']!,
          ),
          zoom: AppConstants.initialCameraPosition['zoom']!,
        ),
        markers: _markers,
        myLocationEnabled: true,
        myLocationButtonEnabled: false,
        zoomControlsEnabled: false,
        compassEnabled: false,
        mapToolbarEnabled: false,
      );
    } catch (e) {
      // If there's an error in creating the map, update error state and return error UI
      setState(() {
        _hasMapError = true;
        _mapErrorMessage = e.toString();
      });
      return _buildMapErrorWidget();
    }
  }

  // Build error widget when map fails to load
  Widget _buildMapErrorWidget() {
    return Container(
      color: Colors.grey[200],
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.map_outlined,
              size: 72,
              color: Colors.grey[700],
            ),
            const SizedBox(height: 16),
            Text(
              'Map could not be loaded',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.grey[800],
              ),
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Text(
                'App features will still work without the map.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey[700]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
