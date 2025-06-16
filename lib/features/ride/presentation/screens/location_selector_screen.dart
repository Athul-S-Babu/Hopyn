import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/utils/constants.dart';
import '../../../../core/utils/extensions.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/widgets/custom_text_field.dart';
import '../../../home/domain/entities/location.dart';
import '../../../home/presentation/providers/home_providers.dart';
import '../../presentation/providers/ride_providers.dart';

class LocationSelectorScreen extends ConsumerStatefulWidget {
  const LocationSelectorScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<LocationSelectorScreen> createState() => _LocationSelectorScreenState();
}

class _LocationSelectorScreenState extends ConsumerState<LocationSelectorScreen> {
  final TextEditingController _pickupController = TextEditingController();
  final TextEditingController _dropoffController = TextEditingController();
  final FocusNode _pickupFocusNode = FocusNode();
  final FocusNode _dropoffFocusNode = FocusNode();

  bool _isPickupSelected = true;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();

    // Set focus to pickup field initially
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _pickupFocusNode.requestFocus();
    });

    // Check if we already have pickup/dropoff locations from a previous screen
    final currentRideState = ref.read(currentRideProvider);
    if (currentRideState.ride.pickupLocation != null) {
      _pickupController.text = currentRideState.ride.pickupLocation!.address;
    }
    if (currentRideState.ride.dropoffLocation != null) {
      _dropoffController.text = currentRideState.ride.dropoffLocation!.address;
    }
  }

  @override
  void dispose() {
    _pickupController.dispose();
    _dropoffController.dispose();
    _pickupFocusNode.dispose();
    _dropoffFocusNode.dispose();
    super.dispose();
  }

  void _onPickupFocused() {
    setState(() {
      _isPickupSelected = true;
      _searchQuery = _pickupController.text;
    });
  }

  void _onDropoffFocused() {
    setState(() {
      _isPickupSelected = false;
      _searchQuery = _dropoffController.text;
    });
  }

  void _onSearchChanged(String value) {
    setState(() {
      _searchQuery = value;
    });
  }

  void _selectLocation(Location location) {
    if (_isPickupSelected) {
      _pickupController.text = location.address;
      ref.read(currentRideProvider.notifier).setPickupLocation(location);
      // Auto-focus on dropoff if pickup is filled
      _dropoffFocusNode.requestFocus();
      setState(() {
        _isPickupSelected = false;
        _searchQuery = _dropoffController.text;
      });
    } else {
      _dropoffController.text = location.address;
      ref.read(currentRideProvider.notifier).setDropoffLocation(location);
      // If both fields are filled, enable the next button
      if (_pickupController.text.isNotEmpty) {
        FocusScope.of(context).unfocus();
      }
    }

    // Add to search history
    addToSearchHistory(ref, location.address);
  }

  void _navigateToVehicleSelection() {
    // Check if both pickup and dropoff are selected
    final currentRideState = ref.read(currentRideProvider);
    if (currentRideState.ride.pickupLocation != null && currentRideState.ride.dropoffLocation != null) {
      context.go('/vehicle-selection');
    } else {
      // Show error message
      context.showSnackBar('Please select both pickup and dropoff locations', isError: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final savedLocations = ref.watch(savedLocationsProvider);
    final recentLocations = ref.watch(recentLocationsProvider);
    final searchHistory = ref.watch(searchHistoryProvider);

    // Filter locations based on search query
    final filteredSavedLocations = _searchQuery.isEmpty
        ? savedLocations
        : savedLocations
            .where((loc) =>
                loc.address.toLowerCase().contains(_searchQuery.toLowerCase()) ||
                (loc.name?.toLowerCase().contains(_searchQuery.toLowerCase()) ?? false))
            .toList();

    final filteredRecentLocations = _searchQuery.isEmpty
        ? recentLocations
        : recentLocations.where((loc) => loc.address.toLowerCase().contains(_searchQuery.toLowerCase())).toList();

    final filteredSearchHistory = _searchQuery.isEmpty
        ? searchHistory
        : searchHistory.where((query) => query.toLowerCase().contains(_searchQuery.toLowerCase())).toList();

    final bool canProceed = _pickupController.text.isNotEmpty && _dropoffController.text.isNotEmpty;

    return Scaffold(
      backgroundColor: AppColors.kWhite,
      appBar: AppBar(
        backgroundColor: AppColors.kWhite,
        title: const Text('Select Location',style: TextStyle(
          color: AppColors.kPrimaryColor
        ),),
        leading: const BackButton(
          color: AppColors.kPrimaryColor,
        ),

      ),
      body: Column(
        children: [
          // Location input fields
          Padding(
            padding: const EdgeInsets.all(AppConstants.defaultPadding),
            child: Column(
              children: [
                // Pickup field
                CustomTextField(
                  controller: _pickupController,
                  focusNode: _pickupFocusNode,
                  label: 'Pickup',
                  hint: 'Enter pickup location',
                  prefixIcon: const Icon(Icons.circle_outlined, color: AppColors.kGreen),
                  onChanged: _isPickupSelected ? _onSearchChanged : null,
                  onTap: _onPickupFocused, labelStyle: const TextStyle(color: AppColors.kPrimaryColor),
                ),
                const SizedBox(height: 16),

                // Dropoff field
                CustomTextField(
                  controller: _dropoffController,
                  focusNode: _dropoffFocusNode,
                  label: 'Dropoff',
                  hint: 'Enter destination',
                  prefixIcon: const Icon(Icons.location_on, color: AppColors.kRed,),
                  onChanged: !_isPickupSelected ? _onSearchChanged : null,
                  onTap: _onDropoffFocused,  labelStyle: const TextStyle(color: AppColors.kPrimaryColor),
                ),
              ],
            ),
          ),

          // Divider
          const Divider(height: 1),

          // Location suggestions
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(AppConstants.defaultPadding),
              children: [
                // Show saved locations first
                if (filteredSavedLocations.isNotEmpty) ...[
                  const _SectionTitle(title: 'Saved Places'),
                  ...filteredSavedLocations.map((location) => _LocationItem(
                        icon: location.name == 'Home'
                            ? Icons.home
                            : location.name == 'Work'
                                ? Icons.work
                                : Icons.favorite,

                        title: location.name ?? 'Saved Location',
                        subtitle: location.address,

                        onTap: () => _selectLocation(location),color: AppColors.kPrimaryColor,
                      )),
                  const SizedBox(height: 16),
                  const Divider(color:  AppColors.kBlackShade,),
                ],

                // Show recent locations
                if (filteredRecentLocations.isNotEmpty) ...[
                  const _SectionTitle(title: 'Recent Locations'),
                  ...filteredRecentLocations.map((location) => _LocationItem(
                        icon: Icons.history,
                        title: location.address,

                        onTap: () => _selectLocation(location), color: AppColors.kPrimaryColor,
                      )),
                  const SizedBox(height: 16),
                  const Divider(color:  AppColors.kBlackShade,),
                ],

                // Show search history
                if (filteredSearchHistory.isNotEmpty) ...[
                  const _SectionTitle(title: 'Search History'),
                  ...filteredSearchHistory.map((query) => _LocationItem(
                        icon: Icons.history,

                        title: query,
                        onTap: () {
                          // Create a dummy location
                          final dummyLocation = Location(
                            id: DateTime.now().millisecondsSinceEpoch.toString(),
                            address: query,
                            latitude: 37.7749, // Default to San Francisco
                            longitude: -122.4194,
                          );
                          _selectLocation(dummyLocation);
                        }, color: AppColors.kPrimaryColor,
                      )),

                  // Clear search history button
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: TextButton(
                      onPressed: () {
                        clearSearchHistory(ref);
                      },
                      child: Text(
                        'Clear Search History',
                        style: context.textTheme.bodyMedium?.copyWith(
                          color: AppColors.kPrimaryColor
                        ),
                      ),
                    ),
                  ),
                ],

                // Show default suggestions if no search
                if (_searchQuery.isEmpty &&
                    filteredSavedLocations.isEmpty &&
                    filteredRecentLocations.isEmpty &&
                    filteredSearchHistory.isEmpty) ...[
                  const _SectionTitle(title: 'Popular Destinations'),
                  _LocationItem(
                    icon: Icons.location_on,
                    title: 'San Francisco Airport (SFO)',
                    subtitle: 'San Francisco, CA',

                    onTap: () {
                      final dummyLocation = Location(
                        id: 'sfo',
                        address: 'San Francisco Airport (SFO), San Francisco, CA',
                        latitude: 37.6213,
                        longitude: -122.3790,
                      );
                      _selectLocation(dummyLocation);
                    },color: AppColors.kPrimaryColor,
                  ),
                  _LocationItem(
                    icon: Icons.location_on,
                    title: 'Golden Gate Park',

                    subtitle: 'San Francisco, CA',

                    onTap: () {
                      final dummyLocation = Location(
                        id: 'ggp',
                        address: 'Golden Gate Park, San Francisco, CA',
                        latitude: 37.7694,
                        longitude: -122.4862,
                      );
                      _selectLocation(dummyLocation);
                    }, color:  AppColors.kPrimaryColor,
                  ),
                  _LocationItem(
                    icon: Icons.location_on,
                    title: 'Fisherman\'s Wharf',
                    subtitle: 'San Francisco, CA',

                    onTap: () {
                      final dummyLocation = Location(
                        id: 'wharf',
                        address: 'Fisherman\'s Wharf, San Francisco, CA',
                        latitude: 37.8080,
                        longitude: -122.4177,
                      );
                      _selectLocation(dummyLocation);
                    },color: AppColors.kPrimaryColor,
                  ),
                ],

                // No results message
                if (_searchQuery.isNotEmpty &&
                    filteredSavedLocations.isEmpty &&
                    filteredRecentLocations.isEmpty &&
                    filteredSearchHistory.isEmpty)
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 24.0),
                    child: Center(
                      child: Text('No matching locations found'),
                    ),
                  ),
              ],
            ),
          ),

          // Divider and continue button
          const Divider(height: 1),
          Padding(
            padding: const EdgeInsets.all(AppConstants.defaultPadding),
            child: CustomButton(
              text: 'Continue',
              onPressed: canProceed ? _navigateToVehicleSelection : () {},
              isLoading: false,
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;

  const _SectionTitle({
    Key? key,
    required this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        title,
        style: context.textTheme.titleMedium?.copyWith(
          color: AppColors.kYellow,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

class _LocationItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final VoidCallback onTap;
  final Color color;
  const _LocationItem({
    Key? key,
    required this.icon,
    required this.title,
    this.subtitle,
    required this.onTap, required this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12.0),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                icon,
                color: color,
                size: 20,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w500,
                      color: color, // 🔹 Title color
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (subtitle != null)
                    Text(
                      subtitle!,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: color.withOpacity(0.7),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: Colors.grey),
          ],
        ),
      ),
    );
  }
}
