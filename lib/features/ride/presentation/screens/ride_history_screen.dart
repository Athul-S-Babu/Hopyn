
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../../core/utils/constants.dart';
import '../../../../core/utils/extensions.dart';
import '../../../home/domain/entities/ride.dart';
import '../../../home/presentation/providers/home_providers.dart';


class RideHistoryScreen extends ConsumerWidget {
  const RideHistoryScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final rideHistory = ref.watch(rideHistoryProvider);

    final Map<String, List<Ride>> groupedRides = {};
    for (final ride in rideHistory) {
      if (ride.startTime != null) {
        final monthYear = DateFormat('MMMM yyyy').format(ride.startTime!);
        groupedRides.putIfAbsent(monthYear, () => []).add(ride);
      }
    }

    return Scaffold(
      backgroundColor: AppColors.kWhite,
      appBar: AppBar(
        title: const Text(
          'Ride History',
          style: TextStyle(color: AppColors.kPrimaryColor),
        ),
        backgroundColor: AppColors.kWhite,
        iconTheme: const IconThemeData(color: AppColors.kPrimaryColor),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/home'),
        ),
      ),
      body: rideHistory.isEmpty
          ? _buildEmptyState(context)
          : ListView(
        padding: const EdgeInsets.all(AppConstants.defaultPadding),
        children: [
          for (final entry in groupedRides.entries) ...[
            _SectionHeader(title: entry.key),
            ...entry.value.map((ride) => _RideHistoryItem(ride: ride)),
          ],
        ],
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.history,
            size: 64,
            color: AppColors.kPrimaryColor.withOpacity(0.5),
          ),
          const SizedBox(height: 16),
          Text(
            'No Ride History',
            style: context.textTheme.headlineMedium?.copyWith(
              color: AppColors.kPrimaryColor,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Your completed rides will appear here',
            style: context.textTheme.bodyLarge?.copyWith(
              color: AppColors.kPrimaryColor.withOpacity(0.7),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;

  const _SectionHeader({Key? key, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Text(
        title,
        style: context.textTheme.titleLarge?.copyWith(
          fontWeight: FontWeight.bold,
          color: AppColors.kPrimaryColor,
        ),
      ),
    );
  }
}

class _RideHistoryItem extends StatelessWidget {
  final Ride ride;

  const _RideHistoryItem({Key? key, required this.ride}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final dateFormatter = DateFormat('MMM d, h:mm a');
    final dateString = ride.startTime != null ? dateFormatter.format(ride.startTime!) : 'Unknown date';

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      color: AppColors.kWhite,
      shape: RoundedRectangleBorder(

        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: AppColors.kPrimaryColor
        )
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => _showRideDetails(context, ride),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Date & price
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    dateString,
                    style: context.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColors.kPrimaryColor,
                    ),
                  ),
                  Text(
                    ride.fare?.toCurrency ?? '\$0.00',
                    style: context.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColors.kPrimaryColor,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              // Ride type + metrics
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: AppColors.kPrimaryColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(
                      ride.vehicleType?.name ?? 'Ride',
                      style: context.textTheme.bodyMedium?.copyWith(
                        color: AppColors.kPrimaryColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Icon(Icons.straighten, size: 16, color: AppColors.kPrimaryColor.withOpacity(0.6)),
                  const SizedBox(width: 4),
                  Text(
                    ride.distance?.toDistance ?? '0 km',
                    style: context.textTheme.bodyMedium?.copyWith(
                      color: AppColors.kPrimaryColor.withOpacity(0.7),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Icon(Icons.access_time, size: 16, color: AppColors.kPrimaryColor.withOpacity(0.6)),
                  const SizedBox(width: 4),
                  Text(
                    ride.duration?.toTime ?? '0 min',
                    style: context.textTheme.bodyMedium?.copyWith(
                      color: AppColors.kPrimaryColor.withOpacity(0.7),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              // Pickup & dropoff with original green & red
              _LocationRow(
                icon: Icons.circle_outlined,
                text: ride.pickupLocation?.address ?? 'Unknown pickup',
                color: Colors.green,
              ),
              const SizedBox(height: 2),
              const Padding(
                padding: EdgeInsets.only(left: 12.0),
                child: SizedBox(
                  height: 16,
                  child: VerticalDivider(width: 1, thickness: 1, color: Colors.grey),
                ),
              ),
              const SizedBox(height: 2),
              _LocationRow(
                icon: Icons.location_on,
                text: ride.dropoffLocation?.address ?? 'Unknown destination',
                color: Colors.red,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showRideDetails(BuildContext context, Ride ride) {
    showModalBottomSheet(
      backgroundColor: AppColors.kGrey,
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20),

        ),
      ),
      builder: (context) {
        final dateFormatter = DateFormat('MMMM d, yyyy - h:mm a');
        final dateString = ride.startTime != null ? dateFormatter.format(ride.startTime!) : 'Unknown date';

        return Container(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(

                  width: 40, height: 4,
                  decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(2)),
                ),
              ),
              const SizedBox(height: 24),
              Text('Ride Details', style: context.textTheme.headlineSmall?.copyWith(color: AppColors.kPrimaryColor)),
              const SizedBox(height: 8),
              Text(dateString,
                style: context.textTheme.bodyLarge?.copyWith(
                  color: AppColors.kPrimaryColor.withOpacity(0.7),
                ),
              ),
              const SizedBox(height: 24),
              _DetailRow(title: 'Pickup', value: ride.pickupLocation?.address ?? 'Unknown', icon: Icons.circle_outlined, iconColor: Colors.green),
              const SizedBox(height: 16),
              _DetailRow(title: 'Dropoff', value: ride.dropoffLocation?.address ?? 'Unknown', icon: Icons.location_on, iconColor: Colors.red),
              const SizedBox(height: 24),
              const Divider(),
              const SizedBox(height: 16),
              _DetailRow(title: 'Vehicle Type', value: ride.vehicleType?.name ?? 'Unknown', icon: Icons.directions_car),
              const SizedBox(height: 16),
              _DetailRow(title: 'Driver', value: ride.driver?.name ?? 'Unknown', icon: Icons.person),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(child: _StatBox(title: 'Distance', value: ride.distance?.toDistance ?? '0 km', icon: Icons.straighten)),
                  const SizedBox(width: 16),
                  Expanded(child: _StatBox(title: 'Duration', value: ride.duration?.toTime ?? '0 min', icon: Icons.access_time)),
                  const SizedBox(width: 16),
                  Expanded(child: _StatBox(title: 'Total Fare', value: ride.fare?.toCurrency ?? '\$0.00', icon: Icons.attach_money)),
                ],
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.kPrimaryColor,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Close', style: TextStyle(color: AppColors.kWhite)),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _LocationRow extends StatelessWidget {
  final IconData icon;
  final String text;
  final Color color;

  const _LocationRow({Key? key, required this.icon, required this.text, required this.color}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: color, size: 20),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            style: context.textTheme.bodyMedium?.copyWith(
              color: AppColors.kPrimaryColor,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}

class _DetailRow extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color? iconColor;

  const _DetailRow({Key? key, required this.title, required this.value, required this.icon, this.iconColor}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: (iconColor ?? AppColors.kPrimaryColor).withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: iconColor ?? AppColors.kPrimaryColor, size: 20),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: context.textTheme.bodyMedium?.copyWith(
                color: AppColors.kPrimaryColor.withOpacity(0.7),
              )),
              const SizedBox(height: 4),
              Text(value, style: context.textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.w500,
                color: AppColors.kPrimaryColor,
              )),
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
  final IconData icon;

  const _StatBox({Key? key, required this.title, required this.value, required this.icon}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.kPrimaryColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Icon(icon, color: AppColors.kPrimaryColor, size: 20),
          const SizedBox(height: 8),
          Text(title, style: context.textTheme.bodySmall?.copyWith(
            color: AppColors.kPrimaryColor.withOpacity(0.7),
          )),
          const SizedBox(height: 4),
          Text(value, style: context.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: AppColors.kPrimaryColor,
          )),
        ],
      ),
    );
  }
}
