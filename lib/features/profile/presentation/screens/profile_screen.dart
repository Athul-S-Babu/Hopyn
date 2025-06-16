import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/utils/constants.dart';
import '../../../../core/utils/extensions.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../auth/presentation/providers/auth_providers.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUser = ref.watch(currentUserProvider);

    return Scaffold(
      backgroundColor: AppColors.kWhite,
      appBar: AppBar(
        backgroundColor: AppColors.kWhite,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.kPrimaryColor),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),

        title: const Text(
          'Profile',
          style: TextStyle(color: AppColors.kPrimaryColor),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings, color: AppColors.kPrimaryColor),
            onPressed: () => context.go('/settings'),
          ),
        ],
      ),


      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppConstants.defaultPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Profile Image and Info
            Center(
              child: Column(
                children: [
                  // Profile Avatar
                  CircleAvatar(
                    radius: 60,
                    backgroundColor: AppColors.kBlackShade,
                    child: Text(
                      currentUser?.name.substring(0, 1) ?? 'U',
                      style: context.textTheme.displayLarge?.copyWith(
                        color: AppColors.kPrimaryColor,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // User Name
                  Text(
                    currentUser?.name ?? 'User',
                    style: context.textTheme.headlineMedium?.copyWith(
                      color: AppColors.kPrimaryColor
                    )

                  ),

                  // User Rating
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.star,
                        color: AppColors.kYellow,
                        size: 18,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${currentUser?.rating ?? 0.0}',
                        style: context.textTheme.bodyMedium?.copyWith(
                          color: AppColors.kPrimaryColor
                        )
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),

            // User Info Section
            const _SectionTitle(title: 'Account Information'),
            _InfoItem(
              icon: Icons.email_outlined,
              title: 'Email',
              subtitle: currentUser?.email ?? 'No email provided',

            ),
            _InfoItem(
              icon: Icons.phone_outlined,
              title: 'Phone',
              subtitle: currentUser?.phoneNumber ?? 'No phone provided',
            ),
            _InfoItem(
              icon: Icons.calendar_today_outlined,
              title: 'Member Since',
              subtitle: currentUser?.createdAt != null
                  ? '${currentUser!.createdAt.month}/${currentUser.createdAt.year}'
                  : 'Unknown',
            ),

            const SizedBox(height: 24),

            // Saved Places Section
            const _SectionTitle(title: 'Saved Places'),
            _ActionItem(
              icon: Icons.home_outlined,
              title: 'Home',
              onTap: () {
                // Navigate to edit home location screen
                context.showSnackBar('Edit home location not implemented in demo');
              },
            ),
            _ActionItem(
              icon: Icons.work_outline,
              title: 'Work',
              onTap: () {
                // Navigate to edit work location screen
                context.showSnackBar('Edit work location not implemented in demo');
              },
            ),
            _ActionItem(
              icon: Icons.add_circle_outline,
              title: 'Add Saved Place',
              onTap: () {
                // Navigate to add saved location screen
                context.showSnackBar('Add saved location not implemented in demo');
              },
            ),

            const SizedBox(height: 24),

            // Payment Methods Section
            const _SectionTitle(title: 'Payment Methods'),
            _ActionItem(
              icon: Icons.credit_card,
              title: 'Credit Card (...1234)',
              onTap: () {
                // Navigate to edit payment method screen
                context.showSnackBar('Edit payment method not implemented in demo');
              },
            ),
            _ActionItem(
              icon: Icons.add_circle_outline,
              title: 'Add Payment Method',
              onTap: () {
                // Navigate to add payment method screen
                context.showSnackBar('Add payment method not implemented in demo');
              },
            ),

            const SizedBox(height: 32),

            // Logout Button
            CustomButton(
              text: 'Log Out',
              onPressed: () async {
                await ref.read(authProvider.notifier).logout();
                if (context.mounted) {
                  context.go('/login');
                }
              },
              buttonType: ButtonType.outline,
            ),

            const SizedBox(height: 24),
          ],
        ),
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
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Text(
        title,
        style: context.textTheme.titleLarge?.copyWith(
          fontWeight: FontWeight.bold,
          color: AppColors.kYellow
        ),
      ),
    );
  }
}

class _InfoItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;

  const _InfoItem({
    Key? key,
    required this.icon,
    required this.title,
    required this.subtitle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: context.colorScheme.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: AppColors.kPrimaryColor
            ),
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: context.textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppColors.kPrimaryColor
                ),
              ),

              Text(
                subtitle,
                style: context.textTheme.bodyMedium?.copyWith(
                  color: AppColors.kPrimaryColor.withOpacity(0.7),
                ),
              )

            ],
          ),
        ],
      ),
    );
  }
}

class _ActionItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  const _ActionItem({
    Key? key,
    required this.icon,
    required this.title,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12.0),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: context.colorScheme.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                color: AppColors.kPrimaryColor,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: context.textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppColors.kPrimaryColor
                ),
              ),
            ),
            const Icon(Icons.chevron_right,color: AppColors.kPrimaryColor,),
          ],
        ),
      ),
    );
  }
}
