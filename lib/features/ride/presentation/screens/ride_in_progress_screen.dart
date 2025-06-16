import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/utils/extensions.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../home/presentation/providers/home_providers.dart';
import '../widgets/ride_map.dart';

class RideInProgressScreen extends ConsumerStatefulWidget {
  const RideInProgressScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<RideInProgressScreen> createState() => _RideInProgressScreenState();
}

class _RideInProgressScreenState extends ConsumerState<RideInProgressScreen> {
  bool _isBottomSheetExpanded = false;
  bool _isRideStarted = false;
  bool _isRideEnded = false;

  @override
  void initState() {
    super.initState();
    // For demo purposes, start the ride after a delay
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        setState(() {
          _isRideStarted = true;
        });
        ref.read(currentRideProvider.notifier).startRide();
      }
    });
  }

  void _toggleBottomSheet() {
    setState(() {
      _isBottomSheetExpanded = !_isBottomSheetExpanded;
    });
  }

  void _endRide() {
    setState(() {
      _isRideEnded = true;
    });

    // Complete the ride after a short delay to show the loading state
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        ref.read(currentRideProvider.notifier).completeRide();
        context.go('/ride-completion');
      }
    });
  }

  void _contactDriver() {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Contact Driver',
              style: context.textTheme.titleLarge,
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _ContactButton(
                  icon: Icons.call,
                  label: 'Call',
                  onTap: () {
                    Navigator.pop(context);
                    context.showSnackBar('Calling driver feature not implemented in demo');
                  },
                ),
                _ContactButton(
                  icon: Icons.message,
                  label: 'Message',
                  onTap: () {
                    Navigator.pop(context);
                    context.showSnackBar('Messaging driver feature not implemented in demo');
                  },
                ),
              ],
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  void _cancelRide() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Cancel Ride?'),
        content: const Text('Are you sure you want to cancel this ride? Cancellation fees may apply.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('No, Keep Ride'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // Cancel the ride
              ref.read(currentRideProvider.notifier).cancelRide();
              context.go('/home');
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            child: const Text('Yes, Cancel'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final currentRideState = ref.watch(currentRideProvider);
    final ride = currentRideState.ride;
    final driver = ride.driver;

    // ETA calculation for demo
    final etaMinutes = !_isRideStarted
        ? '${driver?.name ?? 'Driver'} arriving in ${ride.vehicleType?.estimatedTime.toInt() ?? 5} min'
        : _isRideEnded
            ? 'Completing ride...'
            : 'Arriving in ${(ride.duration ?? 0).toInt()} min';

    final bottomSheetHeight = _isBottomSheetExpanded ? context.screenHeight * 0.5 : 240.0;

    return Scaffold(
      body: Stack(
        children: [
          // Map
          const Positioned.fill(
            child: RideMap(),
          ),

          // Status bar overlay (for better visibility of system UI)
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              height: MediaQuery.of(context).padding.top,
              color: Colors.black.withOpacity(0.1),
            ),
          ),

          // Back button
          Positioned(
            top: MediaQuery.of(context).padding.top + 16,
            left: 16,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  _cancelRide();
                },
              ),
            ),
          ),

          // ETA Card
          Positioned(
            top: MediaQuery.of(context).padding.top + 16,
            left: 0,
            right: 0,
            child: Center(
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Text(
                  etaMinutes,
                  style: context.textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),

          // Bottom Sheet
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: GestureDetector(
              onVerticalDragEnd: (details) {
                if (details.primaryVelocity! < 0) {
                  // Swipe up
                  if (!_isBottomSheetExpanded) {
                    _toggleBottomSheet();
                  }
                } else if (details.primaryVelocity! > 0) {
                  // Swipe down
                  if (_isBottomSheetExpanded) {
                    _toggleBottomSheet();
                  }
                }
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                height: bottomSheetHeight,
                decoration: BoxDecoration(
                  color: Colors.white,
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
                child: SingleChildScrollView(
                  physics: const NeverScrollableScrollPhysics(),
                  child: SizedBox(
                    height: bottomSheetHeight,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Drag handle
                        Container(
                          margin: const EdgeInsets.only(top: 12, bottom: 8),
                          width: 40,
                          height: 4,
                          decoration: BoxDecoration(
                            color: Colors.grey[300],
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),

                        // Driver info
                        if (driver != null) ...[
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Row(
                              children: [
                                // Driver avatar
                                CircleAvatar(
                                  radius: 28,
                                  backgroundColor: context.colorScheme.primary,
                                  child: Text(
                                    driver.name.substring(0, 1),
                                    style: context.textTheme.headlineSmall?.copyWith(
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 16),

                                // Driver details
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        driver.name,
                                        style: context.textTheme.bodyLarge?.copyWith(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Row(
                                        children: [
                                          const Icon(
                                            Icons.star,
                                            color: Colors.amber,
                                            size: 14,
                                          ),
                                          const SizedBox(width: 4),
                                          Text(
                                            driver.rating.toString(),
                                            style: context.textTheme.bodyMedium,
                                          ),
                                          Text(
                                            ' • ${driver.totalRides}+ trips',
                                            style: context.textTheme.bodyMedium?.copyWith(
                                              color: context.colorScheme.onSurface.withOpacity(0.7),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),

                                // Contact button
                                IconButton(
                                  icon: const Icon(Icons.phone),
                                  onPressed: _contactDriver,
                                  color: context.colorScheme.primary,
                                ),
                              ],
                            ),
                          ),

                          // Vehicle info
                          if (ride.vehicleType != null && driver.carModel != null) ...[
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16.0),
                              child: Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color: context.colorScheme.primary.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Icon(
                                      Icons.directions_car,
                                      color: context.colorScheme.primary,
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        '${driver.carColor} ${driver.carModel}',
                                        style: context.textTheme.bodyMedium?.copyWith(
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      Text(
                                        'License: ${driver.licensePlate}',
                                        style: context.textTheme.bodyMedium?.copyWith(
                                          color: context.colorScheme.onSurface.withOpacity(0.7),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],

                          const Divider(height: 32),
                        ],

                        // Ride details
                        if (_isBottomSheetExpanded) ...[
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Trip Details',
                                  style: context.textTheme.titleLarge,
                                ),
                                const SizedBox(height: 16),
                                _RideDetailItem(
                                  icon: Icons.circle_outlined,
                                  title: 'Pickup',
                                  subtitle: ride.pickupLocation?.address ?? 'Current Location',
                                  color: Colors.green,
                                ),
                                const SizedBox(height: 8),
                                const Padding(
                                  padding: EdgeInsets.only(left: 12.0),
                                  child: SizedBox(
                                    height: 20,
                                    child: VerticalDivider(
                                      width: 1,
                                      thickness: 1,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 8),
                                _RideDetailItem(
                                  icon: Icons.location_on,
                                  title: 'Dropoff',
                                  subtitle: ride.dropoffLocation?.address ?? 'Destination',
                                  color: Colors.red,
                                ),
                                const SizedBox(height: 16),
                                Row(
                                  children: [
                                    Expanded(
                                      child: _StatBox(
                                        title: 'Est. Distance',
                                        value: ride.distance?.toDistance ?? '0 km',
                                      ),
                                    ),
                                    const SizedBox(width: 16),
                                    Expanded(
                                      child: _StatBox(
                                        title: 'Est. Duration',
                                        value: ride.duration?.toTime ?? '0 min',
                                      ),
                                    ),
                                    const SizedBox(width: 16),
                                    Expanded(
                                      child: _StatBox(
                                        title: 'Est. Fare',
                                        value: ride.fare?.toCurrency ?? '\$0.00',
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],

                        const Spacer(),

                        // Ride action buttons
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            children: [
                              if (!_isRideStarted) ...[
                                // Waiting for driver
                                Text(
                                  'Driver is heading to your pickup location',
                                  style: context.textTheme.bodyMedium,
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 16),
                                CustomButton(
                                  text: 'Cancel Ride',
                                  onPressed: _cancelRide,
                                  buttonType: ButtonType.outline,
                                ),
                              ] else if (!_isRideEnded) ...[
                                // Ride in progress
                                CustomButton(
                                  text: 'End Ride',
                                  onPressed: _endRide,
                                ),
                                const SizedBox(height: 12),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    _ActionButton(
                                      icon: Icons.message,
                                      label: 'Message',
                                      onTap: () {
                                        _contactDriver();
                                      },
                                    ),
                                    _ActionButton(
                                      icon: Icons.share,
                                      label: 'Share Trip',
                                      onTap: () {
                                        context.showSnackBar('Share trip feature not implemented in demo');
                                      },
                                    ),
                                    _ActionButton(
                                      icon: Icons.help_outline,
                                      label: 'Help',
                                      onTap: () {
                                        context.showSnackBar('Help feature not implemented in demo');
                                      },
                                    ),
                                  ],
                                ),
                              ] else ...[
                                // Completing ride
                                const CircularProgressIndicator(),
                                const SizedBox(height: 16),
                                Text(
                                  'Processing your ride...',
                                  style: context.textTheme.bodyLarge,
                                ),
                              ],
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _RideDetailItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;

  const _RideDetailItem({
    Key? key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: color),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: context.textTheme.bodySmall?.copyWith(
                  color: context.colorScheme.onSurface.withOpacity(0.7),
                ),
              ),
              Text(
                subtitle,
                style: context.textTheme.bodyMedium?.copyWith(
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

class _StatBox extends StatelessWidget {
  final String title;
  final String value;

  const _StatBox({
    Key? key,
    required this.title,
    required this.value,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            title,
            style: context.textTheme.bodySmall?.copyWith(
              color: context.colorScheme.onSurface.withOpacity(0.7),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: context.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _ActionButton({
    Key? key,
    required this.icon,
    required this.label,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: context.colorScheme.primary,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: context.textTheme.bodySmall,
            ),
          ],
        ),
      ),
    );
  }
}

class _ContactButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _ContactButton({
    Key? key,
    required this.icon,
    required this.label,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: context.colorScheme.primary.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                color: context.colorScheme.primary,
                size: 28,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: context.textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
