import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/utils/constants.dart';
import '../../../../core/utils/extensions.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/widgets/loading_indicator.dart';
import '../../../home/presentation/providers/home_providers.dart';

class DriverSearchScreen extends ConsumerStatefulWidget {
  const DriverSearchScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<DriverSearchScreen> createState() => _DriverSearchScreenState();
}

class _DriverSearchScreenState extends ConsumerState<DriverSearchScreen> with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;
  bool _cancellingRide = false;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat(reverse: true);

    // Start searching for a driver
    _findDriver();
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  Future<void> _findDriver() async {
    // Simulate network request to find a driver
    final success = await ref.read(currentRideProvider.notifier).assignDriver();

    if (success && mounted) {
      // Navigate to ride in progress screen
      context.go('/ride-in-progress');
    } else if (mounted) {
      // Show error and allow retry
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Could not find a driver. Please try again.'),
          action: SnackBarAction(
            label: 'Retry',
            onPressed: _findDriver,
          ),
        ),
      );
    }
  }

  void _cancelSearch() {
    setState(() {
      _cancellingRide = true;
    });

    // Simulate cancellation request
    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) {
        ref.read(currentRideProvider.notifier).cancelRide();
        context.go('/home');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final currentRide = ref.watch(currentRideProvider);
    final ride = currentRide.ride;

    return Scaffold(
      backgroundColor: AppColors.kGrey,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(AppConstants.defaultPadding),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Animation
                const PulsingLoadingIndicator(
                  color: AppColors.kPrimaryColor,
                  message: 'Finding your driver...',
                messageColor:  AppColors.kPrimaryColor,
                ),

                const SizedBox(height: 40),

                // Ride details
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.kPrimaryColor,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              //  color: AppColors.kWhite,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Icon(
                              Icons.directions_car,
                              color: AppColors.kWhite
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  ride.vehicleType?.name ?? 'Vehicle',
                                  style: context.textTheme.titleLarge,
                                ),
                                Text(
                                  '${ride.fare?.toCurrency ?? '\$0.00'} • ${ride.distance?.toDistance ?? '0 km'}',
                                  style: context.textTheme.bodyMedium?.copyWith(
                                    color: context.colorScheme.onSurface.withOpacity(0.7),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      const Divider(),
                      const SizedBox(height: 16),
                      _LocationItem(
                        icon: Icons.circle_outlined,
                        title: 'Pickup',
                        address: ride.pickupLocation?.address ?? 'Current Location',
                        color: Colors.green,
                      ),
                      const SizedBox(height: 8),
                      _LocationItem(
                        icon: Icons.location_on,
                        title: 'Dropoff',
                        address: ride.dropoffLocation?.address ?? 'Destination',
                        color: Colors.red,
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 40),

                // Cancel button
                _cancellingRide
                    ? const CircularProgressIndicator()
                    : CustomButton(
                        text: 'Cancel Ride',
                        onPressed: _cancelSearch,
                        buttonType: ButtonType.outline,
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _LocationItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String address;
  final Color color;

  const _LocationItem({
    Key? key,
    required this.icon,
    required this.title,
    required this.address,
    required this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: color),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: context.textTheme.bodyMedium?.copyWith(
                  color: context.colorScheme.onSurface.withOpacity(0.7),
                ),
              ),
              Text(
                address,
                style: context.textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
