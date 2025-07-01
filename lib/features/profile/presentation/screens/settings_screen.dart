// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:go_router/go_router.dart';
// import '../../../../core/utils/constants.dart';
// import '../../../../core/utils/extensions.dart';
//
// // Simple settings state provider
// final darkModeProvider = StateProvider<bool>((ref) => false);
// final notificationsEnabledProvider = StateProvider<bool>((ref) => true);
// final locationSharingProvider = StateProvider<bool>((ref) => true);
// final languageProvider = StateProvider<String>((ref) => 'English');
//
// class SettingsScreen extends ConsumerWidget {
//   const SettingsScreen({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final isDarkMode = ref.watch(darkModeProvider);
//     final notificationsEnabled = ref.watch(notificationsEnabledProvider);
//     final locationSharingEnabled = ref.watch(locationSharingProvider);
//     final language = ref.watch(languageProvider);
//
//     return Scaffold(
//       backgroundColor: AppColors.kWhite,
//       appBar: AppBar(
//         title: const Text('Settings'),
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back),
//           onPressed: () {
//             context.go('/profile');
//           },
//         ),
//       ),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(AppConstants.defaultPadding),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // App Preferences
//             const _SectionTitle(title: 'App Preferences',),
//
//             // Dark Mode
//             _ToggleSettingItem(
//               icon: Icons.dark_mode_outlined,
//               title: 'Dark Mode',
//               value: isDarkMode,
//
//               onChanged: (value) {
//                 ref.read(darkModeProvider.notifier).state = value;
//                 // In a real app, this would change the theme
//               },
//             ),
//
//             // Language
//             _ActionSettingItem(
//               icon: Icons.language_outlined,
//               title: 'Language',
//               subtitle: language,
//               onTap: () {
//                 _showLanguageSelector(context, ref);
//               },
//             ),
//
//             const Divider(),
//
//             // Notifications
//             const _SectionTitle(title: 'Notifications'),
//             _ToggleSettingItem(
//               icon: Icons.notifications_outlined,
//               title: 'Push Notifications',
//               value: notificationsEnabled,
//               onChanged: (value) {
//                 ref.read(notificationsEnabledProvider.notifier).state = value;
//               },
//             ),
//
//             const Divider(),
//
//             // Privacy
//             const _SectionTitle(title: 'Privacy'),
//             _ToggleSettingItem(
//               icon: Icons.location_on_outlined,
//               title: 'Location Sharing',
//               subtitle: 'Allow app to access your location',
//               value: locationSharingEnabled,
//               onChanged: (value) {
//                 ref.read(locationSharingProvider.notifier).state = value;
//               },
//             ),
//
//             const Divider(),
//
//             // About
//             const _SectionTitle(title: 'About'),
//             _ActionSettingItem(
//               icon: Icons.info_outline,
//               title: 'App Version',
//               subtitle: '1.0.0',
//               onTap: () {},
//               showChevron: false,
//             ),
//             _ActionSettingItem(
//               icon: Icons.description_outlined,
//               title: 'Terms of Service',
//               onTap: () {
//                 context.showSnackBar('Terms of Service not implemented in demo');
//               },
//             ),
//             _ActionSettingItem(
//               icon: Icons.privacy_tip_outlined,
//               title: 'Privacy Policy',
//               onTap: () {
//                 context.showSnackBar('Privacy Policy not implemented in demo');
//               },
//             ),
//
//             const SizedBox(height: 24),
//           ],
//         ),
//       ),
//     );
//   }
//
//   void _showLanguageSelector(BuildContext context, WidgetRef ref) {
//     final languages = ['English', 'Spanish', 'French', 'German', 'Japanese'];
//
//     showModalBottomSheet(
//       context: context,
//       shape: const RoundedRectangleBorder(
//         borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
//       ),
//       builder: (context) {
//         return Padding(
//           padding: const EdgeInsets.symmetric(vertical: 20),
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               Padding(
//                 padding: const EdgeInsets.all(16.0),
//                 child: Text(
//                   'Select Language',
//                   style: context.textTheme.headlineSmall,
//                 ),
//               ),
//               const Divider(),
//               ...languages.map((lang) {
//                 return ListTile(
//                   title: Text(lang),
//                   trailing:
//                       lang == ref.read(languageProvider) ? Icon(Icons.check, color: context.colorScheme.primary) : null,
//                   onTap: () {
//                     ref.read(languageProvider.notifier).state = lang;
//                     Navigator.pop(context);
//                   },
//                 );
//               }),
//             ],
//           ),
//         );
//       },
//     );
//   }
// }
//
// class _SectionTitle extends StatelessWidget {
//   final String title;
//
//   const _SectionTitle({
//     Key? key,
//     required this.title,
//   }) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 12.0),
//       child: Text(
//         title,
//         style: context.textTheme.titleLarge?.copyWith(
//           fontWeight: FontWeight.bold,
//         ),
//       ),
//     );
//   }
// }
//
// class _ToggleSettingItem extends StatelessWidget {
//   final IconData icon;
//   final String title;
//   final String? subtitle;
//   final bool value;
//   final ValueChanged<bool> onChanged;
//
//   const _ToggleSettingItem({
//     Key? key,
//     required this.icon,
//     required this.title,
//     this.subtitle,
//     required this.value,
//     required this.onChanged,
//   }) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 8.0),
//       child: Row(
//         children: [
//           Container(
//             padding: const EdgeInsets.all(12),
//             decoration: BoxDecoration(
//               color: context.colorScheme.primary.withOpacity(0.1),
//               borderRadius: BorderRadius.circular(12),
//             ),
//             child: Icon(
//               icon,
//               color: context.colorScheme.primary,
//             ),
//           ),
//           const SizedBox(width: 16),
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   title,
//                   style: context.textTheme.bodyLarge?.copyWith(
//                     fontWeight: FontWeight.w600,
//                   ),
//                 ),
//                 if (subtitle != null)
//                   Text(
//                     subtitle!,
//                     style: context.textTheme.bodyMedium?.copyWith(
//                       color: context.colorScheme.onSurface.withOpacity(0.7),
//                     ),
//                   ),
//               ],
//             ),
//           ),
//           Switch(
//             value: value,
//             onChanged: onChanged,
//             activeColor: context.colorScheme.primary,
//           ),
//         ],
//       ),
//     );
//   }
// }
//
// class _ActionSettingItem extends StatelessWidget {
//   final IconData icon;
//   final String title;
//   final String? subtitle;
//   final VoidCallback onTap;
//   final bool showChevron;
//
//   const _ActionSettingItem({
//     Key? key,
//     required this.icon,
//     required this.title,
//     this.subtitle,
//     required this.onTap,
//     this.showChevron = true,
//   }) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return InkWell(
//       onTap: onTap,
//       borderRadius: BorderRadius.circular(12),
//       child: Padding(
//         padding: const EdgeInsets.symmetric(vertical: 12.0),
//         child: Row(
//           children: [
//             Container(
//               padding: const EdgeInsets.all(12),
//               decoration: BoxDecoration(
//                 color: context.colorScheme.primary.withOpacity(0.1),
//                 borderRadius: BorderRadius.circular(12),
//               ),
//               child: Icon(
//                 icon,
//                 color: context.colorScheme.primary,
//               ),
//             ),
//             const SizedBox(width: 16),
//             Expanded(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     title,
//                     style: context.textTheme.bodyLarge?.copyWith(
//                       fontWeight: FontWeight.w600,
//                     ),
//                   ),
//                   if (subtitle != null)
//                     Text(
//                       subtitle!,
//                       style: context.textTheme.bodyMedium?.copyWith(
//                         color: context.colorScheme.onSurface.withOpacity(0.7),
//                       ),
//                     ),
//                 ],
//               ),
//             ),
//             if (showChevron) const Icon(Icons.chevron_right),
//           ],
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/utils/constants.dart';
import '../../../../core/utils/extensions.dart';

// Simple settings state provider
final darkModeProvider = StateProvider<bool>((ref) => false);
final notificationsEnabledProvider = StateProvider<bool>((ref) => true);
final locationSharingProvider = StateProvider<bool>((ref) => true);
final languageProvider = StateProvider<String>((ref) => 'English');

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDarkMode = ref.watch(darkModeProvider);
    final notificationsEnabled = ref.watch(notificationsEnabledProvider);
    final locationSharingEnabled = ref.watch(locationSharingProvider);
    final language = ref.watch(languageProvider);

    return Scaffold(
      backgroundColor: AppColors.kWhite,
      appBar: AppBar(
        backgroundColor: AppColors.kWhite,
        title: const Text('Settings',style: TextStyle(color:  AppColors.kPrimaryColor,),),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back,color:AppColors.kPrimaryColor, ),
          onPressed: () {
            context.go('/profile');
          },
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppConstants.defaultPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // App Preferences
            const _SectionTitle(title: 'App Preferences'),

            // Dark Mode
            _ToggleSettingItem(
              icon: Icons.dark_mode_outlined,
              title: 'Dark Mode',
              value: isDarkMode,
              onChanged: (value) {
                ref.read(darkModeProvider.notifier).state = value;
              },
            ),

            // Language
            _ActionSettingItem(
              icon: Icons.language_outlined,
              title: 'Language',
              subtitle: language,
              onTap: () {
                _showLanguageSelector(context, ref);
              },
            ),

            Divider(color: AppColors.kPrimaryColor.withOpacity(0.5)),

            // Notifications
            const _SectionTitle(title: 'Notifications'),
            _ToggleSettingItem(
              icon: Icons.notifications_outlined,
              title: 'Push Notifications',
              value: notificationsEnabled,
              onChanged: (value) {
                ref.read(notificationsEnabledProvider.notifier).state = value;
              },
            ),

            Divider(color: AppColors.kPrimaryColor.withOpacity(0.5)),

            // Privacy
            const _SectionTitle(title: 'Privacy'),
            _ToggleSettingItem(
              icon: Icons.location_on_outlined,
              title: 'Location Sharing',
              subtitle: 'Allow app to access your location',
              value: locationSharingEnabled,
              onChanged: (value) {
                ref.read(locationSharingProvider.notifier).state = value;
              },
            ),

            Divider(color: AppColors.kPrimaryColor.withOpacity(0.5)),

            // About
            const _SectionTitle(title: 'About'),
            _ActionSettingItem(
              icon: Icons.info_outline,
              title: 'App Version',
              subtitle: '1.0.0',
              onTap: () {},
              showChevron: false,
            ),
            _ActionSettingItem(
              icon: Icons.description_outlined,
              title: 'Terms of Service',
              onTap: () {
                context.showSnackBar('Terms of Service not implemented in demo');
              },
            ),
            _ActionSettingItem(
              icon: Icons.privacy_tip_outlined,
              title: 'Privacy Policy',
              onTap: () {
                context.showSnackBar('Privacy Policy not implemented in demo');
              },
            ),

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  void _showLanguageSelector(BuildContext context, WidgetRef ref) {
    final languages = ['English', 'Spanish', 'French', 'German', 'Japanese'];

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'Select Language',
                  style: context.textTheme.headlineSmall?.copyWith(
                    color: AppColors.kPrimaryColor,
                  ),
                ),
              ),
              Divider(color: AppColors.kPrimaryColor.withOpacity(0.5)),
              ...languages.map((lang) {
                return ListTile(
                  title: Text(
                    lang,
                    style: TextStyle(color: AppColors.kPrimaryColor),
                  ),
                  trailing: lang == ref.read(languageProvider)
                      ? Icon(Icons.check, color: AppColors.kPrimaryColor)
                      : null,
                  onTap: () {
                    ref.read(languageProvider.notifier).state = lang;
                    Navigator.pop(context);
                  },
                );
              }),
            ],
          ),
        );
      },
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
          color: AppColors.kPrimaryColor
        ),
      ),
    );
  }
}

class _ToggleSettingItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  const _ToggleSettingItem({
    Key? key,
    required this.icon,
    required this.title,
    this.subtitle,
    required this.value,
    required this.onChanged,
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
              color: AppColors.kPrimaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: AppColors.kPrimaryColor,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: context.textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppColors.kPrimaryColor
                  ),
                ),
                if (subtitle != null)
                  Text(
                    subtitle!,
                    style: context.textTheme.bodyMedium?.copyWith(
                      color: AppColors.kPrimaryColor.withOpacity(0.7),
                    ),
                  ),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: AppColors.kPrimaryColor,
          ),
        ],
      ),
    );
  }
}

class _ActionSettingItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final VoidCallback onTap;
  final bool showChevron;

  const _ActionSettingItem({
    Key? key,
    required this.icon,
    required this.title,
    this.subtitle,
    required this.onTap,
    this.showChevron = true,
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
                color: AppColors.kPrimaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                color: AppColors.kPrimaryColor
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: context.textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: AppColors.kPrimaryColor
                    ),
                  ),
                  if (subtitle != null)
                    Text(
                      subtitle!,
                      style: context.textTheme.bodyMedium?.copyWith(
                        color: AppColors.kPrimaryColor.withOpacity(0.7),
                      ),
                    ),
                ],
              ),
            ),
            if (showChevron)
              Icon(Icons.chevron_right, color: AppColors.kPrimaryColor),
          ],
        ),
      ),
    );
  }
}
