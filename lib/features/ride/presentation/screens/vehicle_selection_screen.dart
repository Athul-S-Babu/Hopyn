import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/utils/constants.dart';
import '../../../../core/utils/extensions.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../home/presentation/providers/home_providers.dart';
import '../widgets/vehicle_type_card.dart';

class VehicleSelectionScreen extends ConsumerStatefulWidget {
  const VehicleSelectionScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<VehicleSelectionScreen> createState() => _VehicleSelectionScreenState();
}

class _VehicleSelectionScreenState extends ConsumerState<VehicleSelectionScreen> {
  bool _isBookingRide = false;
  String? _selectedPaymentMethod = 'Credit Card';

  final List<String> _paymentMethods = [
    'Credit Card',
    'Cash',
    'PayPal',
    'Apple Pay',
  ];

  @override
  void initState() {
    super.initState();
    // Ensure we have a vehicle type selected
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final vehicleTypes = ref.read(vehicleTypesProvider);
      if (vehicleTypes.isNotEmpty) {
        final currentRideState = ref.read(currentRideProvider);
        if (currentRideState.ride.vehicleType == null) {
          ref.read(currentRideProvider.notifier).setVehicleType(vehicleTypes.first);
          ref.read(selectedVehicleTypeProvider.notifier).state = vehicleTypes.first;
        }
      }
    });
  }

  Future<void> _requestRide() async {
    // Show loading state
    setState(() {
      _isBookingRide = true;
    });

    // Request a ride
    final success = await ref.read(currentRideProvider.notifier).requestRide();

    if (success && mounted) {
      // Navigate to driver search screen
      context.go('/driver-search');
    } else if (mounted) {
      // Show error message
      setState(() {
        _isBookingRide = false;
      });

      final errorMessage = ref.read(currentRideProvider).errorMessage ?? 'Failed to book ride. Please try again.';

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(errorMessage),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
    }
  }

  void _showPaymentMethodSelector() {
    showModalBottomSheet(
      backgroundColor: AppColors.kWhite,
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 24.0, horizontal: 16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Select Payment Method',
                    style: context.textTheme.titleLarge?.copyWith(
                      color: AppColors.kPrimaryColor
                    )
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: _paymentMethods.length,
                      itemBuilder: (context, index) {
                        final method = _paymentMethods[index];
                        return RadioListTile<String>(

                          title: Text(method, style: const TextStyle(color: AppColors.kPrimaryColor),),
                          value: method,
                          groupValue: _selectedPaymentMethod,
                          onChanged: (value) {
                            setState(() {
                              _selectedPaymentMethod = value;
                            });
                            // Update in parent widget state
                            this.setState(() {});
                          },
                          activeColor: context.colorScheme.primary,
                        );
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          foregroundColor: AppColors.kWhite,
                          backgroundColor: AppColors.kPrimaryColor
                        ),
                        child: const Text('Done'),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final vehicleTypes = ref.watch(vehicleTypesProvider);
    final selectedVehicleType = ref.watch(selectedVehicleTypeProvider);
    final currentRideState = ref.watch(currentRideProvider);
    final ride = currentRideState.ride;

    // Calculate estimated prices and times for each vehicle type
    final estimatedDistance = ride.distance ?? 8.5; // Default to 8.5 km if not set
    final estimatedDuration = ride.duration ?? 22.0; // Default to 22 minutes if not set

    return Scaffold(
      backgroundColor: AppColors.kWhite,
      appBar: AppBar(
        title: const Text('Select Vehicle'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/location-selector'),
        ),
      ),
      body: Column(
        children: [
          // Ride details summary
          Padding(
            padding: const EdgeInsets.all(AppConstants.defaultPadding),
            child: Column(
              children: [
                // Pickup and dropoff
                _LocationRow(
                  icon: Icons.circle_outlined,
                  text: ride.pickupLocation?.address ?? 'Current Location',
                  color: Colors.green,
                ),
                const SizedBox(height: 2),
                Padding(
                  padding: const EdgeInsets.only(left: 12.0),
                  child: Container(
                    width: 1,
                    height: 20,
                    color: Colors.grey[400],
                  ),
                ),
                const SizedBox(height: 2),
                _LocationRow(
                  icon: Icons.location_on,
                  text: ride.dropoffLocation?.address ?? 'Destination',
                  color: Colors.red,
                ),

                const SizedBox(height: 16),

                // Ride stats
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _RideStat(
                      icon: Icons.straighten,
                      value: estimatedDistance.toDistance,

                    ),
                    Container(
                      width: 1,
                      height: 24,
                      color: Colors.grey[300],
                    ),
                    _RideStat(
                      icon: Icons.access_time,
                      value: estimatedDuration.toTime,

                   ),
                  ],
                ),
              ],
            ),
          ),

          const Divider(height: 1,color: AppColors.kBlackShade),

          // Vehicle type selection
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(AppConstants.defaultPadding),
              itemCount: vehicleTypes.length,
              itemBuilder: (context, index) {
                final vehicleType = vehicleTypes[index];
                final isSelected = selectedVehicleType?.id == vehicleType.id;
                final estimatedPrice = vehicleType.calculateFare(estimatedDistance, estimatedDuration);

                return Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: VehicleTypeCard(
                    vehicleType: vehicleType,
                    isSelected: isSelected,
                    estimatedPrice: estimatedPrice,
                    onTap: () {
                      ref.read(selectedVehicleTypeProvider.notifier).state = vehicleType;
                      ref.read(currentRideProvider.notifier).setVehicleType(vehicleType);
                    },
                  ),
                );
              },
            ),
          ),

          // Divider
          const Divider(height: 1,color: AppColors.kBlackShade ,),

          // Book ride button and payment method
          Padding(
            padding: const EdgeInsets.all(AppConstants.defaultPadding),
            child: Column(
              children: [
                // Payment method selector
                InkWell(
                  onTap: _showPaymentMethodSelector,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Row(
                      children: [
                        const Icon(Icons.payment,color: AppColors.kPrimaryColor ,),
                        const SizedBox(width: 8),
                        Text(
                         // _selectedPaymentMethod ??
                              'Select Payment Method',
                          style: context.textTheme.bodyLarge?.copyWith(
                            color: AppColors.kPrimaryColor
                          )
                        ),
                        const Spacer(),
                       // const Icon(Icons.arrow_drop_down),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // Book ride button
                CustomButton(
                  text: _isBookingRide ? 'Booking Your Ride...' : 'Book ${selectedVehicleType?.name ?? 'Ride'}',
                  onPressed: _isBookingRide
                      ? () {}
                      : () async {
                          await _requestRide();
                        },
                  isLoading: _isBookingRide,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _LocationRow extends StatelessWidget {
  final IconData icon;
  final String text;
  final Color color;

  const _LocationRow({
    Key? key,
    required this.icon,
    required this.text,
    required this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: color, size: 20),
        const SizedBox(width: 16),
        Expanded(
          child: Text(
            text,
            style: context.textTheme.bodyMedium?.copyWith(
              color: AppColors.kPrimaryColor
            ),

            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}

class _RideStat extends StatelessWidget {
  final IconData icon;
  final String value;

  const _RideStat({
    Key? key,
    required this.icon,
    required this.value,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          icon,
          size: 16,
          color: AppColors.kPrimaryColor.withOpacity(0.7)
        ),
        const SizedBox(width: 4),
        Text(
          value,
          style: context.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w500,
            color: AppColors.kPrimaryColor
          ),
        ),
      ],
    );
  }
}
