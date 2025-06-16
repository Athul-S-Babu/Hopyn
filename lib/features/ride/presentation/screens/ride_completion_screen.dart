import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/utils/constants.dart';
import '../../../../core/utils/extensions.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../home/presentation/providers/home_providers.dart';

class RideCompletionScreen extends ConsumerWidget {
  const RideCompletionScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentRideState = ref.watch(currentRideProvider);
    final ride = currentRideState.ride;
    final driver = ride.driver;

    // Format the time and distance
    final duration = ride.duration?.toTime ?? '0 min';
    final distance = ride.distance?.toDistance ?? '0 km';
    final fare = ride.fare?.toCurrency ?? '\$0.00';

    return Scaffold(
      backgroundColor:AppColors.kGrey,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(AppConstants.defaultPadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Success icon
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: const BoxDecoration(
                    color: Colors.green,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.check,
                    color: Colors.white,
                    size: 48,
                  ),
                ),
                const SizedBox(height: 24),

                // Title
                Text(
                  'Ride Completed',
                  style: context.textTheme.displaySmall,
                ),
                const SizedBox(height: 8),

                // Subtitle
                Text(
                  'Thank you for riding with us',
                  style: context.textTheme.bodyLarge?.copyWith(
                    color: context.colorScheme.onSurface.withOpacity(0.7),
                  ),
                ),
                const SizedBox(height: 32),

                // Divider
                Divider(
                  color: context.colorScheme.onSurface.withOpacity(0.1),
                  thickness: 1,
                ),
                const SizedBox(height: 24),

                // Ride details
                _buildDetailItem(
                  context,
                  'Trip Fare',
                  fare,
                  Icons.attach_money,
                ),
                const SizedBox(height: 16),

                _buildDetailItem(
                  context,
                  'Distance',
                  distance,
                  Icons.straighten,
                ),
                const SizedBox(height: 16),

                _buildDetailItem(
                  context,
                  'Duration',
                  duration,
                  Icons.access_time,
                ),
                const SizedBox(height: 16),

                _buildDetailItem(
                  context,
                  'Payment Method',
                  ride.paymentMethod ?? 'Credit Card',
                  Icons.credit_card,
                ),
                const SizedBox(height: 24),

                // Divider
                Divider(
                  color: context.colorScheme.onSurface.withOpacity(0.1),
                  thickness: 1,
                ),
                const SizedBox(height: 24),

                // Driver details
                if (driver != null) ...[
                  Text(
                    'Your Driver',
                    style: context.textTheme.titleLarge,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      // Driver avatar
                      CircleAvatar(
                        radius: 32,
                        backgroundColor: context.colorScheme.primary,
                        child: Text(
                          driver.name.substring(0, 1),
                          style: context.textTheme.displayMedium?.copyWith(
                            color: Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),

                      // Driver info
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              driver.name,
                              style: context.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                const Icon(
                                  Icons.star,
                                  color: Colors.amber,
                                  size: 16,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  driver.rating.toString(),
                                  style: context.textTheme.bodyMedium,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  '${driver.totalRides}+ trips',
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
                  ),
                  const SizedBox(height: 32),
                ],

                // Rate driver button
                CustomButton(
                  text: 'Rate Your Trip',
                  onPressed: () {
                    // Show a rating dialog
                    _showRatingDialog(context, ref);
                  },
                ),
                const SizedBox(height: 16),

                // Go to home button
                CustomButton(
                  text: 'Back to Home',
                  onPressed: () {
                    // Reset the current ride
                    ref.read(currentRideProvider.notifier).resetRide();
                    context.go('/home');
                  },
                  buttonType: ButtonType.outline,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDetailItem(
    BuildContext context,
    String title,
    String value,
    IconData icon,
  ) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: context.colorScheme.primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            icon,
            color: context.colorScheme.primary,
          ),
        ),
        const SizedBox(width: 16),
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
                value,
                style: context.textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _showRatingDialog(BuildContext context, WidgetRef ref) {
    int selectedRating = 5;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(builder: (context, setState) {
        return AlertDialog(
          title: const Text('Rate Your Trip'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('How was your ride experience?'),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(5, (index) {
                  return IconButton(
                    icon: Icon(
                      index < selectedRating ? Icons.star : Icons.star_border,
                      color: index < selectedRating ? Colors.amber : Colors.grey,
                      size: 32,
                    ),
                    onPressed: () {
                      setState(() {
                        selectedRating = index + 1;
                      });
                    },
                  );
                }),
              ),
              const SizedBox(height: 16),
              TextField(
                decoration: InputDecoration(
                  hintText: 'Add a comment (optional)',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                maxLines: 3,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                // Submit rating
                Navigator.pop(context);
                // Show confirmation
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Thank you for your feedback!'),
                  ),
                );
                // Reset ride and go home
                ref.read(currentRideProvider.notifier).resetRide();
                context.go('/home');
              },
              child: const Text('Submit'),
            ),
          ],
        );
      }),
    );
  }
}
