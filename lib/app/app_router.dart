import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../features/auth/presentation/screens/login_screen.dart';
import '../features/auth/presentation/screens/signup_screen.dart';
import '../features/home/presentation/screens/home_screen.dart';
import '../features/onboarding/presentation/screens/onboarding_screen.dart';
import '../features/onboarding/presentation/screens/splash_screen.dart';
import '../features/profile/presentation/screens/profile_screen.dart';
import '../features/profile/presentation/screens/settings_screen.dart';
import '../features/ride/presentation/screens/driver_search_screen.dart';
import '../features/ride/presentation/screens/location_selector_screen.dart';
import '../features/ride/presentation/screens/ride_completion_screen.dart';
import '../features/ride/presentation/screens/ride_history_screen.dart';
import '../features/ride/presentation/screens/ride_in_progress_screen.dart';
import '../features/ride/presentation/screens/vehicle_selection_screen.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();

final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: '/onboarding',
        builder: (context, state) => const OnboardingScreen(),
      ),
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/signup',
        builder: (context, state) => const SignupScreen(),
      ),
      GoRoute(
        path: '/home',
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        path: '/location-selector',
        builder: (context, state) => const LocationSelectorScreen(),
      ),
      GoRoute(
        path: '/vehicle-selection',
        builder: (context, state) => const VehicleSelectionScreen(),
      ),
      GoRoute(
        path: '/driver-search',
        builder: (context, state) => const DriverSearchScreen(),
      ),
      GoRoute(
        path: '/ride-in-progress',
        builder: (context, state) => const RideInProgressScreen(),
      ),
      GoRoute(
        path: '/ride-completion',
        builder: (context, state) => const RideCompletionScreen(),
      ),
      GoRoute(
        path: '/profile',
        builder: (context, state) => const ProfileScreen(),
      ),
      GoRoute(
        path: '/settings',
        builder: (context, state) => const SettingsScreen(),
      ),
      GoRoute(
        path: '/ride-history',
        builder: (context, state) => const RideHistoryScreen(),
      ),
    ],
  );
});
